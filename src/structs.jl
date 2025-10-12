abstract type AbstractAPI end

"""
    ManifoldAPI <: AbstractAPI

Basic object for Manifold API 

# Fields 

- `api_url::String`: base url for API
"""
struct ManifoldAPI <: AbstractAPI
    api_url::String
end

function ManifoldAPI(; api_url = "https://api.manifold.markets/v0/")
    return ManifoldAPI(api_url)
end
