module DataFramesExt 
using DataFrames
using Dates
using ManifoldAPIs
import ManifoldAPIs: create_dataframe
import ManifoldAPIs: interpolate

function create_dataframe(market, bets; 
    columns = [
        "userId",
        "outcome",
        "amount",
        "shares",
        "answerId",
        "updatedTime", 
        "createdTime",
        "probAfter",
    ]
)
    df = mapreduce(x -> select(DataFrame(x), columns), vcat, bets)
    df.time .= unix2datetime.(df.updatedTime ./ 1000)
    sort!(df, :updatedTime)
    rename!(df, Dict(:probAfter => :price))
    select!(df, Not(:updatedTime, :createdTime))
    id_to_label = Dict(x.id => x.text for x ∈ market.answers)
    df.answer_label = map(k -> id_to_label[k], df.answerId)
    df.volume .= market.volume
    df.url .= market.url 
    df.outcome_type .= market.outcomeType
    df.resolution_time .= market.resolutionTime
    df.creater_user_name .= market.creatorUsername
    rename!(df, camel_to_underscore.(names(df)))
    return df
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
        new_row.time = rows[r+1].time
        push!(df_new, new_row)

    end
    push!(df_new, rows[n_rows])
    new_row = deepcopy(rows[n_rows])
    new_row.time = unix2datetime(new_row.resolution_time  / 1000)
    push!(df_new, new_row)
    return df_new
end

function camel_to_underscore(s::String)
    result = ""
    for (i, c) in enumerate(s)
        if isuppercase(c)
            # Add underscore before uppercase letter, except at start
            if i > 1
                result *= "_"
            end
            result *= lowercase(c)
        else
            result *= c
        end
    end
    return result
end

end