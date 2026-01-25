using Public

# ------------------------------------ #

for st in sort!(
    filter!(!=("runtests.jl"), readdir());
    by = st -> parse(Int, split(st, '.'; limit = 2)[1]),
)

    @info "🎬 $st"

    run(`julia --project $st`)

end
