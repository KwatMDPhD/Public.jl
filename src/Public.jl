module Public

# ------------------------------------ #

using CSV: read

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame

using JSON: parsefile, print

using Mmap: mmap

using TOML: parsefile as parsefile2

using XLSX: readtable

########################################
# String
########################################

function text_index(st, an, nd)

    split(st, an; limit = nd + 1)[nd]

end

########################################
# Text
########################################

function text_low(st)

    replace(lowercase(st), r"[^._0-9a-z]" => '_')

end

function text_title(s1)

    s2 = uppercasefirst(s1)

    for pa in (
        '_' => ' ',
        r"'m"i => "'m",
        r"'re"i => "'re",
        r"'s"i => "'s",
        r"'ve"i => "'ve",
        r"'d"i => "'d",
        r"1st"i => "1st",
        r"2nd"i => "2nd",
        r"3rd"i => "3rd",
        r"(?<=\d)th"i => "th",
        r"(?<= )a(?= )"i => 'a',
        r"(?<= )an(?= )"i => "an",
        r"(?<= )and(?= )"i => "and",
        r"(?<= )as(?= )"i => "as",
        r"(?<= )at(?= )"i => "at",
        r"(?<= )but(?= )"i => "but",
        r"(?<= )by(?= )"i => "by",
        r"(?<= )for(?= )"i => "for",
        r"(?<= )from(?= )"i => "from",
        r"(?<= )in(?= )"i => "in",
        r"(?<= )into(?= )"i => "into",
        r"(?<= )nor(?= )"i => "nor",
        r"(?<= )of(?= )"i => "of",
        r"(?<= )off(?= )"i => "off",
        r"(?<= )on(?= )"i => "on",
        r"(?<= )onto(?= )"i => "onto",
        r"(?<= )or(?= )"i => "or",
        r"(?<= )out(?= )"i => "out",
        r"(?<= )over(?= )"i => "over",
        r"(?<= )the(?= )"i => "the",
        r"(?<= )to(?= )"i => "to",
        r"(?<= )up(?= )"i => "up",
        r"(?<= )vs(?= )"i => "vs",
        r"(?<= )with(?= )"i => "with",
    )

        s2 = replace(s2, pa)

    end

    s2

end

function text_space(st)

    replace(strip(st), r" +" => ' ')

end

function text_limit(s1, um)

    if length(s1) <= um

        return s1

    end

    s2 = s1[1:um]

    "$s2..."

end

########################################
# Dictionary
########################################

function pair_merge(::Any, an)

    an

end

function pair_merge(d1::AbstractDict, d2)

    d3 = Dict{
        Union{eltype(keys(d1)), eltype(keys(d2))},
        Union{eltype(values(d1)), eltype(values(d2))},
    }()

    for an in union(keys(d1), keys(d2))

        d3[an] = if haskey(d1, an) && haskey(d2, an)

            pair_merge(d1[an], d2[an])

        elseif haskey(d1, an)

            d1[an]

        else

            d2[an]

        end

    end

    d3

end

function read_dictionary(pa)

    if endswith(pa, "toml")

        parsefile2(pa)

    else

        parsefile(pa)

    end

end

function write_dictionary(pa, di)

    open(pa, "w") do io

        print(io, di, 2)

    end

end

########################################
# Path
########################################

function path_short(p1, p2 = pwd())

    p1[(length(p2) + 2):end]

end

function is_path(pa, u1)

    u2 = 0

    bo = false

    while !bo && u2 < u1

        sleep(1)

        u2 += 1

        @info "Waited for $pa ($u2 / $u1)."

        bo = ispath(pa)

    end

    bo

end

function read_path(pa)

    run(`open --background $pa`; wait = false)

end

########################################
# Table
########################################

function read_table(pa; ke_...)

    @assert isfile(pa) pa

    in_ = mmap(pa)

    read(if endswith(pa, "gz")

        transcode(GzipDecompressor, in_)

    else

        in_

    end, DataFrame; ke_...)

end

function read_sheet(pa, st; ke_...)

    DataFrame(readtable(pa, st; infer_eltypes = true, ke_...))

end

function make_part(A)

    st_ = names(A)

    st_[1], A[!, 1], st_[2:end], Matrix(A[!, 2:end])

end

end
