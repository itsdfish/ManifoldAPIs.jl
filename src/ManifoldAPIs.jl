module ManifoldAPIs

using HTTP
using JSON3

export ManifoldAPI
export Market
export MultipleLinked
export MultipleUnlinked
export Single

export buy_shares
export cancel_limit_order
export create_dataframe
export get_all_markets
export get_market_by_slug
export get_market_price
export get_bets
export plot_prices
export make_bet
export search_markets

include("structs.jl")
include("get_functions.jl")
include("post_functions.jl")
include("ext_functions.jl")
include("utilities.jl")

end
