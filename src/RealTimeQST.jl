module RealTimeQST
    using DataDeps
    using Fetch

    function __init__()
        register(DataDep(
            "WignerFlow",
            """Wigner flow dataset""",
            "https://drive.google.com/file/d/1hQIvFJ8B-VFhM_VBWfSmz_S0KpPwtzH8/view?usp=sharing",
            fetch_method=gdownload,
            post_fetch_method=unpack
        ))
        register(DataDep(
            "QSTDemo",
            """Quantum state tomography demo dataset""",
            "https://drive.google.com/file/d/1Z6g2ZEhMUhqSEQFebVrilQ2gACRJkTVU/view?usp=sharing",
            fetch_method=gdownload,
            post_fetch_method=unpack
        ))
    end

    include("utils.jl")
    include("page.jl")
end
