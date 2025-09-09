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
function make_bet(api::AbstractAPI, header, body)
    resp = HTTP.request("POST", api.api_url * "bet", header, body)
end
