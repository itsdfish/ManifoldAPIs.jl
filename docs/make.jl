using DataFrames
using Documenter
using ManifoldAPIs
using StatsPlots

DocMeta.setdocmeta!(ManifoldAPIs, :DocTestSetup, :(using ManifoldAPIs); recursive = true)

makedocs(
    warnonly = true,
    sitename = "ManifoldAPIs",
    format = Documenter.HTML(
        assets = [
            asset(
            "https://fonts.googleapis.com/css?family=Montserrat|Source+Code+Pro&display=swap",
            class = :css
        )
        ],
        collapselevel = 1
    ),
    modules = [
        ManifoldAPIs,
        Base.get_extension(ManifoldAPIs, :DataFramesExt),
        Base.get_extension(ManifoldAPIs, :StatsPlotsExt)
    ],
    pages = [
        "Home" => "index.md",
        "Basic Usage" => "basic_usage.md",
        "API" => "api.md"
    ]
)

deploydocs(repo = "github.com/itsdfish/ManifoldAPIs.jl.git")
