using Public

########################################

const N1_ = [0, 1, 2, 3, 5, 9, 5, 3, 2, 1, 0]

const N2_ = [0, 1, 2, 3, 5, 18, 7, 5, 4, 3, 2]

const N3_ = map((n1, n2) -> (n1 + n2) * 0.1, N1_, N2_)

const N4_ = map((n1, n2) -> (n1 + n2) * 0.5, N1_, N2_)

function write(s1, n1_)

    Public.write_plotly(
        "",
        (
            Dict("name" => s2, "y" => n2_, "mode" => "lines") for (s2, n2_) in
            (("A", N1_), ("Ab", N3_), ("AB", N4_), ("B", N2_), (s1, n1_))
        ),
    )

end

for (st, nu_) in (
    ("A|B", map(Public.number_divergence, N1_, N2_)),
    (
        "A|B - B|A",
        map((n1, n2) -> Public.number_divergence(-, n1, n2), N1_, N2_),
    ),
    (
        "A|B + B|A",
        map((n1, n2) -> Public.number_divergence(+, n1, n2), N1_, N2_),
    ),
    (
        "A|Ab - B|Ab",
        map(
            (n1, n2, n3) -> Public.number_divergence(-, n1, n3, n2, n3),
            N1_,
            N2_,
            N3_,
        ),
    ),
    (
        "A|Ab + B|Ab",
        map(
            (n1, n2, n3) -> Public.number_divergence(+, n1, n3, n2, n3),
            N1_,
            N2_,
            N3_,
        ),
    ),
    (
        "A|AB + B|AB",
        map(
            (n1, n2, n3) -> Public.number_divergence(+, n1, n3, n2, n3),
            N1_,
            N2_,
            N4_,
        ),
    ),
)

    write(st, nu_)

end
