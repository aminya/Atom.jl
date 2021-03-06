let old_pwd = pwd()
cd(dirname(@__FILE__))

@testset "path utilities" begin
    @static if Sys.isapple()
        @warn "skipped a `realpath` test"
        @test_skip Atom.realpath′("./utils.jl") == realpath(@__FILE__)
    else
        @test Atom.realpath′("./utils.jl") == realpath(@__FILE__)
    end
    @test Atom.realpath′(".././dontexist") == ".././dontexist"

    @test Atom.isuntitled(".\\untitled-asdj2123:12") == true
    @test Atom.isuntitled(".\\untitled-asdj2cx3213") == true
    @test Atom.isuntitled("./untitled-asdj2124o3:12") == true
    @test Atom.isuntitled("./untitled-a1j2124o3:12") == true
    @test Atom.isuntitled("untitled-1651asdsd23") == true
    @test Atom.isuntitled("untitled1651asdsd23") == false
    @test Atom.isuntitled("untitled-1651asdsd23:as") == false
    @test Atom.isuntitled("./utils.jl") == false
    @test Atom.isuntitled("../test/utils.jl") == false

    @test Atom.pkgpath(@__FILE__) == "utils.jl"
    @test Atom.pkgpath("foo/bar/pkgname/src/foobar.jl") == "bar/pkgname/src/foobar.jl"
    @test Atom.pkgpath("foo\\bar\\pkgname ü\\src\\foobar.jl") == "bar\\pkgname ü\\src\\foobar.jl"

    @test Atom.fullpath("untitled-asdj2cx3213") == "untitled-asdj2cx3213"
    @test Atom.fullpath("/test/foobar.jl") == "/test/foobar.jl"
    @test joinpath(split(Atom.fullpath("foobar.jl"), Base.Filesystem.path_separator)[end-1:end]...)  == joinpath("base", "foobar.jl")

    @test Atom.appendline("test.jl", -1) == "test.jl"
    @test Atom.appendline("test.jl", 0) == "test.jl"
    @test Atom.appendline("test.jl", 10) == "test.jl:10"

    @test isfile(Atom.expandpath(Atom.view(first(methods(rand)))[2].file)[2])
end

@testset "REPL path finding" begin
    if Sys.iswindows()
        @test Atom.fullREPLpath(raw"@ Atom C:\Users\ads\.julia\dev\Atom\src\repl.jl:25") == (raw"C:\Users\ads\.julia\dev\Atom\src\repl.jl", 25)
        @test Atom.fullREPLpath(raw"@ Atom C:\Users\ads one\.julia\dev\Atom\src\repl.jl:25") == (raw"C:\Users\ads one\.julia\dev\Atom\src\repl.jl", 25)
        @test Atom.fullREPLpath(raw"C:\Users\ads\.julia\dev\Atom\src\repl.jl:25") == (raw"C:\Users\ads\.julia\dev\Atom\src\repl.jl", 25)
        @test Atom.fullREPLpath(raw"C:\Users\ads one\.julia\dev\Atom\src\repl.jl:25") == (raw"C:\Users\ads one\.julia\dev\Atom\src\repl.jl", 25)
        @test Atom.fullREPLpath(raw".\foo\bar.jl:1") == (Atom.fullpath(raw".\foo\bar.jl"), 1)
        @test Atom.fullREPLpath(raw".\fo o\bar.jl:1") == (Atom.fullpath(raw".\fo o\bar.jl"), 1)
        @test Atom.fullREPLpath(raw".\foo\ba r.jl:1") == (Atom.fullpath(raw".\foo\ba r.jl"), 1)
        @test Atom.fullREPLpath(raw"foo\bar.jl:1") == (Atom.fullpath(raw".\foo\bar.jl"), 1)
        @test Atom.fullREPLpath(raw"foo\ba r.jl:1") == (Atom.fullpath(raw".\foo\ba r.jl"), 1)
    else
        @test Atom.fullREPLpath("@ Atom /home/user/foo/.julia/bar.jl:25") == ("/home/user/foo/.julia/bar.jl", 25)
        @test Atom.fullREPLpath("/home/user/foo/.julia/bar.jl:25") == ("/home/user/foo/.julia/bar.jl", 25)
        @test Atom.fullREPLpath("./foo/bar.jl:1") == (Atom.fullpath("./foo/bar.jl"), 1)
        @test Atom.fullREPLpath("foo/bar.jl:1") == (Atom.fullpath("./foo/bar.jl"), 1)
    end
end

@testset "finding dev packages" begin
    @test Atom.finddevpackages() isa AbstractDict
end

@testset "finding project file" begin
    using Atom: find_project_file

    # when exists
    atomjl_project_file_path = joinpath′(atomjldir, "Project.toml")
    @test atomjl_project_file_path == find_project_file(atomjldir)
    @test atomjl_project_file_path == find_project_file(atomsrcdir)
    @test atomjl_project_file_path == find_project_file(joinpath′(atomsrcdir, "debugger"))
    @test atomjl_project_file_path == find_project_file(@__DIR__)
    @test atomjl_project_file_path == find_project_file(joinpath′(@__DIR__, "fixtures"))

    # when unexist
    @test nothing === find_project_file("")
    @test nothing === find_project_file("/home/user/foo/")
    @test nothing === find_project_file("C:\\Users\\foo") # don't fail into infinite calls
end

# TODO: baselink, edit

cd(old_pwd)
end

@testset "Undefined" begin
    using Atom: isundefined, undefined
    @test isundefined(undefined)
    @test !isundefined(isundefined)
end

@testset "get utilities" begin
    # TODO: others

    @testset "get docs" begin
        using Atom: getdocs
        using Markdown: MD

        # basic
        let doc = getdocs(Main.Junk, "imwithdoc")
            @test occursin("im a doc in Junk", string(doc))
        end

        # use fallback modules if `@doc` is not defined for a module passed as 1st argument
        let mod = Main.Junk.BareJunk
            doc = getdocs(mod, "imwithdoc") # by `@doc` in Main
            @test occursin("im a doc in BareJunk", string(doc))

            doc = getdocs(mod, "imwithdoc", Main.Junk) # by `@doc` in Junk
            @test occursin("im a doc in BareJunk", string(doc))

            # don't error even if `@doc` is not defined for a fallback module
            @test getdocs(mod, "imwithdoc", mod) isa MD
        end
    end

    @testset "getfield′" begin
        using Atom: getfield′, isundefined
        # find a thing in module
        @test getfield′(Atom, :getfield′) === getfield′
        @test getfield′(Atom, "getfield′") === getfield′
        # find a field in object
        @test getfield′(r"pat", :pattern) == "pat"
        @test getfield′(r"pat", "pattern") == "pat"
        # fallback default value
        @test isundefined(getfield′(Atom, :iwillfallback2undefined))
        @test !isundefined(getfield′(Atom, :iwillfallback2undefined, isdefined))
    end
end

@testset "is utilities" begin
    @testset "iskeyword" begin
        using Atom: iskeyword

        @test iskeyword(:begin)
        @test iskeyword("begin")
        @test !iskeyword(:iskeyword)
    end

    @testset "ismacro" begin
        using Atom: ismacro

        @test ismacro("@view")
        @test ismacro("r\"")
        @test ismacro(getfield(Main, Symbol("@view")))
    end
end

@testset "string utilities" begin
    @testset "limiting excessive strings" begin
        using Atom: strlimit

        # only including ASCII
        @test strlimit("julia", 5) == "julia"
        @test strlimit("julia", 4) == "jul…"
        @test strlimit("Julia in the Nutshell", 21, " ...") == "Julia in the Nutshell"
        @test strlimit("Julia in the Nutshell", 20, " ...") == "Julia in the Nut ..."

        # including Unicode: should respect _length_ of strings, not code units
        @test strlimit("jμλια", 5) == "jμλια"
        @test strlimit("jμλια", 4) == "jμλ…"
        @test strlimit("Jμλια in the Nutshell", 21, " ...") == "Jμλια in the Nutshell"
        @test strlimit("Jμλια in the Nutshell", 20, " ...") == "Jμλια in the Nut ..."
    end
end
