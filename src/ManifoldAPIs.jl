module ManifoldAPIs

using HTTP
using JSON3

export ManifoldAPI
export get_market
export get_all_markets
export search_markets

include("structs.jl")
include("functions.jl")

end
