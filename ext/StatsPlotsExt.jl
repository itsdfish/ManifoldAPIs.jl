module StatsPlotsExt
using DataFrames
using Dates
import ManifoldAPIs: plot_prices
using StatsPlots

"""
    plot_prices(df::DataFrame; kwargs...)

# Arguments 

- `df::DataFrame`: a `DataFrame` containing market information and price history 

# Keywords 

- `config...`: optional keyword arguments to modify the plot configuration

# Example 

```julia 
using ManifoldAPIs
using DataFrames 
using StatsPlots 

api = ManifoldAPI()
market_slug = "supreme-court-rules-trump-tariffs-u"
market = get_market_by_slug(api, market_slug)
bets = get_bets(api; market_slug)

df = create_dataframe(market, bets)
plot_prices(df; size = (800, 400))
```
"""
function plot_prices(df::DataFrame; config...)
    df1 = interpolate(df)
    return @df df1 plot(
        :time,
        :price,
        grid = false,
        ylims = (0, 1),
        ylabel = "Price",
        group = :answer_label;
        config...
    )
end

"""
    interpolate(df)

interpolate time points for the purpose of plotting time series. 

# Arguments

- `df`: a DataFrame with the following columns: `time`, 
"""
function interpolate(df)
    sort!(df, :time)
    return combine(groupby(df, :answer_label), x -> (interpolate(x)))
end

function interpolate(df::SubDataFrame)
    df_new = DataFrame()
    rows = eachrow(df)
    n_rows = length(rows)
    for r ∈ 1:(n_rows - 1)
        push!(df_new, deepcopy(rows[r]))
        new_row = deepcopy(rows[r])
        new_row.time = rows[r + 1].time
        push!(df_new, new_row)
    end
    push!(df_new, rows[n_rows])
    new_row = deepcopy(rows[n_rows])
    if df.is_resolved[1]
        new_row.time = unix2datetime(new_row.resolution_time / 1000)
    else
        new_row.time = unix2datetime(time())
    end
    push!(df_new, new_row)
    return df_new
end
end
