module DataFramesExt
using DataFrames
using Dates
using ManifoldAPIs
import ManifoldAPIs: create_dataframe

"""
    create_dataframe(
        market, 
        bets;
        columns = [
            "userId",
            "outcome",
            "amount",
            "shares",
            "answerId",
            "updatedTime",
            "createdTime",
            "probAfter"
        ]
    )

Converts JSON object holding market data to a `DataFrame`.

# Arguments

- `market`: a JSON3 object containing market information
- `bets`: a JSON3 object containing price history

# Keywords

- `columns`: columns to include in the `DataFrame`. See the function signature above for default columns.
"""
function create_dataframe(
    market, 
    bets;
    columns = [
        "userId",
        "outcome",
        "amount",
        "shares",
        "answerId",
        "updatedTime",
        "createdTime",
        "probAfter"
    ]
)
    _columns = filter(x -> haskey(bets[1], x), columns)
    if _columns ≠ columns
        invalid_keys = setdiff(columns, _columns)
        @warn "Keys $invalid_keys do not exist in bet info"
    end

    df = mapreduce(x -> select(DataFrame(x), _columns), vcat, bets)
    df.time .= unix2datetime.(df.updatedTime ./ 1000)
    sort!(df, :updatedTime)
    rename!(df, Dict(:probAfter => :price))
    select!(df, Not(:updatedTime, :createdTime))
    if haskey(bets[1], "answerId")
        id_to_label = Dict(x.id => x.text for x ∈ market.answers)
        df.answer_label = map(k -> id_to_label[k], df.answerId)
    else
        df.answer_label .= ""
    end
    df.volume .= market.volume
    df.url .= market.url
    df.outcome_type .= market.outcomeType
    df.is_resolved .= market.isResolved
    if market.isResolved
        df.resolution_time .= market.resolutionTime
    end
    df.creater_user_name .= market.creatorUsername
    rename!(df, camel_to_underscore.(names(df)))
    return df
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
