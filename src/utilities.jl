"""
    buy_shares(
        api,
        market_type; 
        target_prices,
        max_amount,
        header,
        slug,
        dry_run = false,
    )


Specifiy a vector of target prices and buy shares for a total up to `max_amount` of Mana. Outstanding limit orders are 
automatically canceled.

# Arguments

- `api::AbstractAPI`: API object 
- `market_type`: the market type. Currently `Single` and `Multiple` are supported. 

# Keywords 

`target_prices`: a vector of target prices for `Multiple` markets or a scalar for a `Single` market
`max_amount`: the maximum amount of Mana to be spent 
- `header`: a dictionary or other compliant data structure containing authorization details 
`slug`:
- `dry_run = false`: if false, executes the order. If true, simulates the execution of an order 

# Example

The market used in the example below consists of 9 unlinked markets (i.e., their prices are not required to sum to 1), which
can be found here: https://manifold.markets/dfish/will-the-sp-500-be-greater-than-or-cqz5Sct5Rg

The function `buy_shares` uses a heuristic to purchase up to `max_amount` worth of shares in sub-markets that have high payoffs. 

Note: `dry_run` must be set to `false` in order to execute the transaction

```julia
using ManifoldAPIs

header = Dict(
    "Authorization" => "Key authorization_key_here",
    "Content-Type" => "application/json"
)

api = ManifoldAPI()
slug = "will-the-sp-500-be-greater-than-or-cqz5Sct5Rg"
max_amount = 25
target_prices = [.9, .8, .7, .6, .5, .4, .3, .2, .1]
results = buy_shares(
    api,
    Multiple; 
    target_prices,
    max_amount,
    header,
    slug,
    dry_run = true,
)
```
"""
function buy_shares(
    api,
    market_type;
    target_prices,
    max_amount,
    header,
    slug,
    dry_run = false
)
    responses = []
    can_buy = true
    prev_amount = 0
    sorted_target_prices = sort_target_prices(api, target_prices, slug)
    while max_amount > 1 && can_buy
        order = make_order(
            api,
            market_type;
            target_prices = sorted_target_prices,
            max_amount,
            slug,
            dry_run,
            header
        )

        response = make_bet(api, header, order)
        push!(responses, response)
        dry_run ? nothing : cancel_limit_order(api, header, response.betId)
        prev_amount = max_amount
        max_amount -= response.amount
        can_buy = max_amount < prev_amount
    end
    return responses
end

function sort_target_prices(api, target_prices::Dict, slug)
    market = get_market_by_slug(api, slug)
    labels = map(x -> x.text, market.answers)
    return map(x -> target_prices[x], labels)
end

sort_target_prices(api, target_prices::Vector, slug) = target_prices
sort_target_prices(api, target_prices::Real, slug) = target_prices

function get_question_prices(market)
    n = length(market.answers)
    prices = fill(0.0, n)
    for i ∈ 1:n
        prices[i] = market.answers[i].probability
    end
    return prices
end

function get_question_ids(market)
    n = length(market.answers)
    ids = fill("", n)
    for i ∈ 1:n
        ids[i] = market.answers[i].id
    end
    return ids
end

function make_order(
    api,
    ::Type{<:Multiple};
    target_prices,
    max_amount,
    slug,
    dry_run = false,
    header
)
    market = get_market_by_slug(api, slug)
    prices = get_question_prices(market)
    question_ids = get_question_ids(market)
    diffs = target_prices .- prices
    evs = compute_expected_values(api, market, target_prices, max_amount; header)
    max_ev, max_id = findmax(evs)

    outcome = diffs[max_id] > 0 ? "YES" : "NO"
    limit_prob = target_prices[max_id]
    question_id = question_ids[max_id]

    order = Dict(
        "contractId" => market.id,
        "answerId" => question_id,
        "amount" => max_amount,
        "outcome" => outcome,
        "dryRun" => dry_run,
        "limitProb" => round(limit_prob, digits = 2)
    )
    return order
end

function compute_expected_values(api, market, target_prices, max_amount; header)
    n = length(market.answers)
    evs = fill(0.0, n)
    for i ∈ 1:n
        evs[i] =
            compute_expected_value(api, market, i, target_prices[i], max_amount; header)
    end
    return evs
end

function compute_expected_value(
    api,
    market,
    question_idx,
    target_price,
    max_amount;
    header
)
    opt_price = round(target_price, digits = 2)
    diff = opt_price - market.answers[question_idx].probability
    outcome = diff > 0 ? "YES" : "NO"
    order = Dict(
        "contractId" => market.id,
        "answerId" => market.answers[question_idx].id,
        "amount" => max_amount,
        "outcome" => outcome,
        "dryRun" => true,
        "limitProb" => opt_price
    )
    response = make_bet(api, header, order)
    _opt_price = outcome == "YES" ? opt_price : (1 - opt_price)
    ev = (response.shares * _opt_price - response.amount) / response.amount
    return isnan(ev) ? 0.0 : ev
end

function make_order(
    api,
    ::Type{<:Single};
    target_prices,
    max_amount,
    slug,
    dry_run = false,
    kwargs...
)
    opt_price = round(target_prices, digits = 2)
    market = get_market_by_slug(api, slug)
    price = market.probability
    diff = opt_price - price

    outcome = diff > 0 ? "YES" : "NO"

    order = Dict(
        "contractId" => market.id,
        "amount" => max_amount,
        "outcome" => outcome,
        "dryRun" => dry_run,
        "limitProb" => opt_price
    )
    return order
end

"""
    schedule(
        api::AbstractAPI; 
        transact,
        can_transact,
        delay = 1, 
        args_can = (),
        kwargs_can = (),
        args = (),
        kwargs = ()
    )

Schedules a transaction by calling the function `transact` when the conditions specified in the function `can_transact` are satisfied.

# Arguments

- `api = ManifoldAPI()`: Manifold API object which is passed to `transact` and `can_transact`

# Keywords

- `transact`: a function that executes a transaction. Function signature: `transact(api, args_can...; kwargs_can...)` 
- `can_transact`: a function that specifies the conditions under which `transact` can be executed. Function signature: `can_transact(api, args_can...; kwargs_can...)` 
- `delay = 1`: delay in seconds to wait before checking `can_transact`
- `args_can = ()`: optional arguments for `can_transact`
- `kwargs_can = ()`: optional keyword arguments for `can_transact`
- `args = ()`: optional arguments for `transact`
- `kwargs = ()`: optional keyword arguments for `transact`

# Example 

```julia 
using Dates 
using ManifoldAPIs

api = ManifoldAPI()

header = Dict(
    "Authorization" => "Key authorization_key_here",
    "Content-Type" => "application/json"
)

order = Dict(
    "contractId" => "HtsxyBopv0MSywM0f0Yp",
    "amount" => 10,
    "outcome" => "YES",
    "dryRun" => true
)

can_transact(api; time) = now() ≥ time
transact(api; header, order) = make_bet(api, header, order)

@async transaction = schedule(
    api; 
    transact,
    can_transact,
    kwargs = (; header, order),
    kwargs_can = (; time = now() + Second(10)),
)
```
"""
function schedule(
    api::AbstractAPI;
    transact,
    can_transact,
    delay = 1,
    args_can = (),
    kwargs_can = (),
    args = (),
    kwargs = ()
)
    while true
        can_transact(api, args_can...; kwargs_can...) ?
        (return transact(api, args...; kwargs...)) : nothing
        sleep(delay)
    end
    return nothing
end
