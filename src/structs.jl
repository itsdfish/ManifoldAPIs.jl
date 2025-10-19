"""
    Market

An abstract market type.
"""
abstract type Market end
"""
    Single <: Market

A market for a single binary outcome. 
"""
struct Single <: Market end

"""
    Multiple <: Multiple

An abstract type for markets with multiple outcomes
"""
abstract type Multiple <: Market end

"""
    MultipleLinked <: Multiple

A set of multiple related market with prices that sum to 1.  
"""
struct MultipleLinked <: Multiple end

"""
    MultipleUnlinked <: Multiple

A set of multiple related market with prices that are `not` required to sum to 1.  
"""
struct MultipleUnlinked <: Multiple end

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
