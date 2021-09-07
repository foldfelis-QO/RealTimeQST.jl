using MAT

#############
# inference #
#############

function get_data(data_name::String, field::String="data_sq")
    data_file = matopen(data_name)
    data = read(data_file, field)
    close(data_file)

    return data
end

function sample(data::Matrix, n::Integer)
    data_indices = sort!(rand(1:size(data, 1), n))

    return data[data_indices, 1] # 1: x; 2: θ
end

reshape_inferred_data(data::Matrix) = [data[:, i] for i in 1:size(data, 2)]

function get_𝛒_and_𝐰(
    data_name::String;
    n_sample=10, fix_θ=true,
    wf=WignerFunction(LinRange(-3, 3, 101), LinRange(-3, 3, 101), dim=70),
    m=get_model("model")
)
    data = get_data(data_name)

    argv = zeros(Float32, 6)
    for _ in 1:n_sample
        argv += SqState.infer(m, sample(data, 4096))
    end
    argv ./= n_sample

    argv[4:6] ./= sum(argv[4:6])
    r, θ, n̄, c1, c2, c3 = argv
    θ = fix_θ ? zero(typeof(θ)) : θ

    state = SqState.construct_state(r, θ, n̄, c1, c2, c3, wf.m_dim)

    return reshape_inferred_data(real.(𝛒(state))), reshape_inferred_data(wf(state).𝐰_surface)
end

#############
# gen plots #
#############

const color_config = [:colorscale=>"twilight", :cmid=>0, :zmid=>0]

function wigner_surface(data::Vector, width::Integer, height::Integer)
    data = PlotlyJS.surface(z=data; color_config...)
    layout = Layout(title="Wigner Function", width=width, height=height)

    return plot(data, layout)
end

function wigner_heatmap(data::Vector, width::Integer, height::Integer)
    data = PlotlyJS.heatmap(z=data; color_config...)
    layout = Layout(title="Wigner Function", width=width, height=height)

    return plot(data, layout)
end

function density_matrix(data::Vector, width::Integer, height::Integer)
    data = PlotlyJS.heatmap(z=data; color_config...)
    layout = Layout(title="Density Matrix (Real Part)", width=width, height=height)

    return plot(data, layout)
end
