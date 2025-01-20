module SelfStarter

using UUIDs, Random

export @selfstart

macro selfstart(m)
    return esc(toselfstart(m))
end

function toselfstart(m::Expr)
    if m.head != :block
        error(ArgumentError("@selfstart with top level $(m.head) is not supported."))
    end

    packages = get_packages(m)

    env_name = random_env_name(@__FILE__)

    pkg_stmt = quote
        import Pkg
        redirect_stdio(stderr = devnull) do
            Pkg.activate(joinpath(tempdir(), $env_name))
            current_pkgs = keys(Pkg.project().dependencies)
            needed_pkgs = $(string.(packages))
            delete_pkgs = setdiff(current_pkgs, needed_pkgs)
            isempty(delete_pkgs) || foreach(delete_pkgs) do pkg
                Pkg.rm(pkg)
            end
            isempty(needed_pkgs) || foreach(needed_pkgs) do pkg
                Pkg.add(pkg)
            end
            Pkg.update()
        end
    end

    Expr(
         m.head,
         pkg_stmt,
         m.args...
        )
end

function random_env_name(s)
    rnd = MersenneTwister(s)
    return string(uuid4(rnd))
end

function relative_error(e)
    error("Relative import/using statements are not supported: $e.")
end

function get_packages(m::Expr)
    packge_blocks = filter(m.args) do arg
        arg isa Expr && arg.head in (:import, :using)
    end

    return mapreduce(union, packge_blocks, init = Set{Symbol}()) do block
        block_set = Set{Symbol}()

        for block_arg in block.args
            package_name = if block_arg.head == Symbol(":")
                first(first(block_arg.args).args)

            elseif block_arg.head == :. 
                first(block_arg.args)
            else
                error("Unexpected using/import head $(block_arg.head)")
            end

            if package_name == :. 
                relative_error(block_arg)
            end

            push!(block_set, package_name)
        end

        block_set
    end
end

end # module SelfStarter
