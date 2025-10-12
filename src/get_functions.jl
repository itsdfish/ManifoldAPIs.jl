"""
    get_market_by_slug(api::AbstractAPI, market_slug)

Returns prediction market information by slug.

# Arguments

- `api::AbstractAPI`: API object 
- `market_slug`: market descriptor e.g., `supreme-court-rules-trump-tariffs-u` in `https://manifold.markets/QuimLast/supreme-court-rules-trump-tariffs-u`
"""
function get_market_by_slug(api::AbstractAPI, market_slug)
    response = HTTP.request("GET", api.api_url * "/slug/" * "$market_slug")
    return JSON3.read(response.body)
end

"""
    get_all_markets(api::AbstractAPI)

Returns information for 1000 prediction markets. 

# Arguments

- `api::AbstractAPI`: API object 
"""
function get_all_markets(api::AbstractAPI)
    response = HTTP.request("GET", api.api_url * "markets")
    return JSON3.read(response.body)
end

"""
    search_markets(
        api::AbstractAPI;
        search_terms = "",
        sort_by = "most-popular",
        filter_by = "all",
        contract_type = "ALL",
        topic_slug = "",
        creator_id = "",
        limit = "",
        offset = "",
        liquidity = ""
    )

Search for markets based on criteria specified as Keywords. 

# Arguments 

- `api::AbstractAPI`: API object 

# Keywords

- `search_terms = ""`: search terms separated by comma. 
- `sort_by = "most-popular"`: according to one of the following options: most-popular, newest,
    score, daily-score, freshness-score, 24-hour-volume, liquidity, subsidy, last-updated, close-date,
    start-time, resolve-date, random, bounty-amount, prob-descending, prob-ascending 
- `filter_by = "all"`: filter markets by closing state with one optional value: all, open, closed, 
    resolved, news, closing-90-days, closing-week, closing-month, closing-day
- `contract_type = "ALL"`:
- `topic_slug = ""`: the topic slug e.g., `supreme-court-rules-trump-tariffs-u` in `https://manifold.markets/QuimLast/supreme-court-rules-trump-tariffs-u`
- `creator_id = ""`: unique numeric id for market creator 
- `limit = ""`: the number of contracts to return from 0 to 1000. Default 100.
- `offset = ""`: the number of contracts to skip. Use with limit to paginate the results.
- `liquidity = ""`: Minimum liquidity per contract 

# Example

```julia
using ManifoldAPIs
api = ManifoldAPI()
search_markets(api; search_terms = "", creator_id = "YGZdZUSFQyM8j2YzPaBqki8NBz23")
```
"""
function search_markets(
    api::AbstractAPI;
    search_terms = "",
    sort_by = "most-popular",
    filter_by = "all",
    contract_type = "ALL",
    topic_slug = "",
    creator_id = "",
    limit = "",
    offset = "",
    liquidity = ""
)
    config = "term=$search_terms&sort=$sort_by&contractType=$contract_type&filter=$filter_by"
    config *= topic_slug ≠ "" ? "&topicSlug=$topic_slug" : ""
    config *= creator_id ≠ "" ? "&creatorId=$creator_id" : ""
    config *= limit ≠ "" ? "&limit=$limit" : ""
    config *= offset ≠ "" ? "&offset=$offset" : ""
    config *= liquidity ≠ "" ? "&liquidity=$liquidity" : ""
    response = HTTP.request("GET", api.api_url * "search-markets?$config")
    return JSON3.read(response.body)
end

"""
    get_bets(api::AbstractAPI;
        market_id = "",
        user_name = "",
        market_slug = "",
        limit  = "",
        before  = "",
        after  = "",
        before_time  = "",
        after_time  = "",
        kinds  = "",
        order  = "",
    )

Returns a vector of bets or trades for a given market id and/or user. 

# Arguments 

- `api::AbstractAPI`: API object 

# Keywords

- `market_id = ""`: unique market id
- `username = ""`: username associated with a trader
- `market_slug = ""`: market descriptor e.g., `supreme-court-rules-trump-tariffs-u` in `https://manifold.markets/QuimLast/supreme-court-rules-trump-tariffs-u`
- `limit  = ""`:  the number of bets to return. The default and maximum are both 1000.
- `before  = ""`:  Include only bets created before the bet with this ID.
    For example, if you ask for the most recent 10 bets, and then perform a second query for 10 more bets with 
    before=[the id of the 10th bet], you will get bets 11 through 20.
- `after  = ""`: Include only bets created after the bet with this ID.
    For example, if you request the 10 most recent bets and then perform a second query with after=[the id of the 1st bet], 
    you will receive up to 10 new bets, if available.
- `before_time  = ""`: include only bets created before this timestamp.
- `after_time  = ""`: include only bets created after this timestamp.
- `kinds  = ""`: Specifies subsets of bets to return. Possible kinds: open-limit (open limit orders, 
    including ones on closed and reolved markets).
- `order  = ""`: asc or desc (default). The sorting order for returned bets.

# Example 

```julia 
using ManifoldAPIs
api = ManifoldAPI()
get_bets(api; market_slug = "supreme-court-rules-trump-tariffs-u")
```
"""
function get_bets(api::AbstractAPI;
    market_id = "",
    username = "",
    market_slug = "",
    limit = "",
    before = "",
    after = "",
    before_time = "",
    after_time = "",
    kinds = "",
    order = ""
)
    config = market_id ≠ "" ? "&contractId=$market_id" : ""
    config *= market_slug ≠ "" ? "&contractSlug=$market_slug" : ""
    config *= username ≠ "" ? "&username=$username" : ""
    config *= limit ≠ "" ? "&limit=$limit" : ""
    config *= before ≠ "" ? "&before=$before" : ""
    config *= after ≠ "" ? "&after=$after" : ""
    config *= before_time ≠ "" ? "&beforeTime=$before_time" : ""
    config *= after_time ≠ "" ? "&afterTime=$after_time" : ""
    config *= kinds ≠ "" ? "&kinds=$kinds" : ""
    config *= order ≠ "" ? "&order=$order" : ""

    response = HTTP.request("GET", api.api_url * "bets?$config")
    return JSON3.read(response.body)
end

"""
    get_market_price(api::AbstractAPI, market_id)

Returns market price based on market id. 

# Arguments

- `api::AbstractAPI`: API object 
- `market_id`: unique market id 

# Example 

```julia 
using ManifoldAPIs
api = ManifoldAPI()
get_market_price(api, "9t61v9e7x4")
```
"""
function get_market_price(api::AbstractAPI, market_id)
    response = HTTP.request("GET", api.api_url * "market/$market_id/prob")
    return JSON3.read(response.body)
end
