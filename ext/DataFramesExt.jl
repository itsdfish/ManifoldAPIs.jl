module DataFramesExt 
using DataFrames
using Dates
using ManifoldAPIs
import ManifoldAPIs: create_dataframe

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