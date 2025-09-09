module ManifoldAPIs

using HTTP
using JSON3

export create_dataframe
export ManifoldAPI
export get_all_markets
export get_market_by_slug
export get_market_price
export get_market_positions
export get_bets
export plot_prices
export make_bet
export search_markets

include("structs.jl")
include("get_functions.jl")
include("post_functions.jl")
include("ext_functions.jl")

end
