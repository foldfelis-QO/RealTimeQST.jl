using RealTimeQST
using Documenter

DocMeta.setdocmeta!(RealTimeQST, :DocTestSetup, :(using RealTimeQST); recursive=true)

makedocs(;
    modules=[RealTimeQST],
    authors="JingYu Ning <foldfelis@gmail.com> and contributors",
    repo="https://github.com/foldfelis-QO/RealTimeQST.jl/blob/{commit}{path}#{line}",
    sitename="RealTimeQST.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://foldfelis-QO.github.io/RealTimeQST.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/foldfelis-QO/RealTimeQST.jl",
)
