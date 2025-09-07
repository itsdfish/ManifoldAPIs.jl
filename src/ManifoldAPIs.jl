module ManifoldAPIs

using HTTP
using JSON3

export create_dataframe
export ManifoldAPI
export get_market_by_slug
export get_all_markets
export get_bets
export plot_prices
export search_markets

include("structs.jl")
include("requesting.jl")
include("ext_functions.jl")

end
