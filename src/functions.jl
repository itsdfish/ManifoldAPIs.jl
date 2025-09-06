function get_market(api::AbstractAPI, market_description)
    resp = HTTP.request("GET", api.api_url * "/slug/" * "$market_description")
    return JSON3.read(resp.body)
end

function get_all_markets(api::AbstractAPI)
    resp = HTTP.request("GET", api.api_url * "markets")
    return JSON3.read(resp.body)
end

"""
    search_markets(api::AbstractAPI;
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
- `topic_slug = ""`:
- `creator_id = ""`:
- `limit = ""`:
- `offset = ""`:
- `liquidity = ""`:

# Example

```julia
using ManifoldAPIs
api = ManifoldAPI()
search_markets(api; search_terms = "", creator_id = "YGZdZUSFQyM8j2YzPaBqki8NBz23")
```
"""
function search_markets(api::AbstractAPI;
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
    resp = HTTP.request("GET", api.api_url * "search-markets?$config")
    return JSON3.read(resp.body)
end
