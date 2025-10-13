# Examples

The two examples below demonstrate two of the most common operations used to interact with Manifold. See the API for a complete list of avaiable functions and examples. 

## Example 1


Example 1 demonstrates how to (1) request market information, (2) request market price history and (3) plot the price history.

```@example
using ManifoldAPIs
using DataFrames 
using StatsPlots 

api = ManifoldAPI()
market_slug = "supreme-court-rules-trump-tariffs-u"
market = get_market_by_slug(api, market_slug)
bets = get_bets(api; market_slug)

df = create_dataframe(market, bets)
plot_prices(df; size = (800, 400))
```

## Example 2

Example 2 demonstrates how to submit buy shares and cancel a limit order. There are three basic ways you can buy shares. 

1. Immediately buy shares at the current price. The optional keyword `limitProb` is ignored in this case.
2. Set a limit order for a price less than the current price, which will be executed if the price reaches the limit. 
3. Set a limit order above the current price (probability), prompting the purchase of shares to be purchased until the price reaches the `limitePrice` the specified `amount` has been purchased, whichever happens first. If the limit is reached, any remaining funds will be spent if the price falls below `limitProb`. Alternatively, the user can explicitly cancel the limit order for the remaining funds by explicitly calling `cancel_limit_order`. 


The example below demonstrates how to perform the 3 option above. Here, we assume the current price is .60 and we want to buy shares until the target price has been reached, or all 100 Mana has been spent. Note that the authorization key can be found by clicking on your profile picture, clicking on the settings gear at the top right, and clicking on the `Account Settings` tab. The authorization key is in the field called `API key`.

```julia 
using ManifoldAPIs

header = Dict(
    "Authorization" => "Key authorization_key_here",
    "Content-Type" => "application/json"
)

order = Dict(
    "contractId" => "HtsxyBopv0MSywM0f0Yp",
    "amount" => 100,
    "outcome" => "YES",
    "limitProb" => .70,
    "dryRun" => true
)

api = ManifoldAPI()
response = make_bet(api, header, order)
cancel_limit_order(api, response.betId)
```