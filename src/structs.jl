abstract type AbstractAPI end

mutable struct ManifoldAPI <: AbstractAPI
    api_url::String
end

function ManifoldAPI(; api_url = "https://api.manifold.markets/v0/")
    return ManifoldAPI(api_url)
end
