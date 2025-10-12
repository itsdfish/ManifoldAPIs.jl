using ManifoldAPIs
using Documenter

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
    #Base.get_extension(ManifoldAPIs, :StatsPlotsExt)
    ],
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(repo = "github.com/itsdfish/ManifoldAPIs.jl.git")
