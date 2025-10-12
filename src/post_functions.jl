"""
    make_bet(api::AbstractAPI, header, body)

Completes a transaction for a specified amount and market. Details about the API can be found at 
https://docs.manifold.markets/api#post-v0bet

# Arguments

- `api::AbstractAPI`: API object 
- `header`: a dictionary or other compliant data structure containing authorization details 
- `body`: a dictionary or other compliant data structure containing details of transaction. 

# Example 

```julia 
using ManifoldAPIs

header = Dict(
    "Authorization" => "Key authorization_key_here",
    "Content-Type" => "application/json"
)

body = Dict(
    "contractId" => "HtsxyBopv0MSywM0f0Yp",
    "amount" => 10,
    "outcome" => "YES",
    "dryRun" => true
)

make_bet(api, header, body)
```
"""
function make_bet(api::AbstractAPI, header, body)
    response = HTTP.request("POST", api.api_url * "bet", header, JSON3.write(body))
    return JSON3.read(response.body)
end

"""
    cancel_limit_order(api::AbstractAPI, header, bet_id)

Cancels a limit order based on bet ID. 

https://docs.manifold.markets/api#post-v0bet

# Arguments

- `api::AbstractAPI`: API object 
- `bet_id`: the bet id found in the server response: `response.betId` 

# Example 

The example below illustrates how to submit a limit order and cancel it based on the `betId`.
Note that "dryRun" needs to be set to `false` for the example to fully work. 

```julia 
using ManifoldAPIs

header = Dict(
    "Authorization" => "Key authorization_key_here",
    "Content-Type" => "application/json"
)

body = Dict(
    "contractId" => "HtsxyBopv0MSywM0f0Yp",
    "amount" => 10,
    "outcome" => "YES",
    "limitProb => .10,
    "dryRun" => true
)

response = make_bet(api, header, body)
cancel_limit_order(api, response.betId)
```
"""
function cancel_limit_order(api::AbstractAPI, header, bet_id)
    response = HTTP.request("POST", api.api_url * "bet/cancel/$bet_id", header)
    return JSON3.read(response.body)
end
