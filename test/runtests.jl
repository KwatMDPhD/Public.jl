using Public

# ------------------------------------ #

for nd in 1:1

    @info "🎬 Testing $nd"

    run(`julia --project $nd.jl`)

end
