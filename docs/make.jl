using ManifoldAPIs
using Documenter

DocMeta.setdocmeta!(ManifoldAPIs, :DocTestSetup, :(using ManifoldAPIs); recursive = true)

makedocs(;
    modules = [ManifoldAPIs],
    authors = "itsdfish <itsdfish@gmail.com> and contributors",
    sitename = "ManifoldAPIs.jl",
    format = Documenter.HTML(;
        edit_link = "main",
        assets = String[]
    ),
    pages = [
        "Home" => "index.md",
    ]
)
