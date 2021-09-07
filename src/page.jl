using QuantumStateBase
using SqState
using Dash
using DashHtmlComponents
using DashCoreComponents
using PlotlyJS

export start_real_time_system

const DIM = 70
const WF = WignerFunction(LinRange(-3, 3, 101), LinRange(-3, 3, 101), dim=DIM)
const M = SqState.get_model("model")

function banner()
    return html_div([
        html_h1("Real Time Quantum State Tomography"),
        html_div("Real time QST: A real time state inference system for RK Lee's lab in NTHU"),
    ])
end

function ctl()
    return html_div([
        dcc_interval(id="interval", interval=3*1000, n_intervals=0),
        html_h2("Inference"),
        dcc_radioitems(id="mode", options=[
            Dict("label"=>"Single", "value"=>"S"),
            Dict("label"=>"Continuous", "value"=>"C"),
        ], value="S"),
        html_button(id="snap", children="Snap", n_clicks=0),
    ])
end

function get_plots(filename::String, width::Integer, height::Integer)
    isempty(filename) && (return [])
    ρ, w = get_𝛒_and_𝐰(filename, fix_θ=false, wf=WF, m=M)

    return [
        dcc_graph(figure=wigner_surface(w, width, height)),
        dcc_graph(figure=wigner_heatmap(w, width, height)),
        dcc_graph(figure=density_matrix(ρ, width, height))
    ]
end

function plots(init_filename::String, width::Integer, height::Integer)
    return html_div(
        id="plots",
        style=Dict("columnCount"=>3),
        get_plots(init_filename, width, height)
    )
end

function gen_app(; data_path=datadep"QSTDemo", width=500, height=500)
    files = readdir(data_path)

    app = dash(external_stylesheets=["https://codepen.io/chriddyp/pen/bWLwgP.css"])
    app.layout = html_div([
        banner(),
        ctl(),
        plots(joinpath(data_path, files[1]), width, height),
    ])

    callback!(
        app,
        Output("plots", "children"),
        Input("snap", "n_clicks"),
    ) do n

        return get_plots(joinpath(data_path, files[(n-1) % length(files) + 1]), width, height)
    end

    callback!(
        app,
        Output("snap", "n_clicks"),
        Input("interval", "n_intervals"),
        State("mode", "value")
    ) do n, mode
        (mode=="S") && (return no_update())

        return n
    end

    return app
end

start_real_time_system() = run_server(gen_app(), "127.0.0.1", 8080)
