module ManifoldAPIs

using HTTP
using JSON3

export create_dataframe
export interpolate
export ManifoldAPI
export get_market_by_slug
export get_all_markets
export get_bets
export search_markets

include("structs.jl")
include("requesting.jl")
include("ext_functions.jl")

end
