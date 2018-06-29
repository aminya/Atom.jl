import REPL
# FIXME: Should refactor all REPL related functions into a struct that keeps track
#        of global state (terminal size, current prompt, current module etc).
# FIXME: Find a way to reprint what's currently entered in the REPL after changing
#        the module (or delete it in the buffer).

isREPL() = isdefined(Base, :active_repl)

handle("changeprompt") do prompt
  isREPL() || return
  global current_prompt = prompt

  if !isempty(prompt)
    changeREPLprompt(prompt)
  end
  nothing
end

handle("changemodule") do data
  isREPL() || return

  @destruct [mod || ""] = data
  if !isempty(mod) && !isdebugging()
    parts = split(mod, '.')
    if length(parts) > 1 && parts[1] == "Main"
      popfirst!(parts)
    end
    changeREPLmodule(mod)
  end
  nothing
end

handle("fullpath") do uri
  uri1 = match(r"(.+)\:(\d+)$", uri)
  uri2 = match(r"@ ([^\s]+)\s(.*?)\:(\d+)", uri)
  if uri2 !== nothing
    return Atom.package_file_path(String(uri2[1]), String(uri2[2])), parse(Int, uri2[3])
  elseif uri1 !== nothing
    return Atom.fullpath(uri1[1]), parse(Int, uri1[2])
  end
  return "", 0
end

function package_file_path(pkg, sfile)
  occursin(".", pkg) && (pkg = String(first(split(pkg, '.'))))

  pkg == "Main" && return false

  path = if pkg in ("Base", "Core")
    Atom.basepath("")
  else
    Base.locate_package(Base.identify_package(pkg))
  end

  path == nothing && return false

  for (root, _, files) in walkdir(dirname(path))
    for file in files
      basename(file) == sfile && (return joinpath(root, file))
    end
  end
  return nothing
end

handle("validatepath") do uri
  uri1 = match(r"(.+?)(:\d+)?$", uri)
  uri2 = match(r"@ ([^\s]+)\s(.*?)\:(\d+)", uri)
  if uri2 ≠ nothing
    # FIXME: always returns the first found file
    path = package_file_path(String(uri2[1]), String(uri2[2]))
    return path ≠ nothing
  elseif uri1 ≠ nothing
    path = Atom.fullpath(uri1[1])
    return isfile(path)
  else
    return false
  end
end

juliaprompt = "julia> "

handle("resetprompt") do linebreak
  isREPL() || return
  linebreak && println()
  changeREPLprompt(juliaprompt)
  nothing
end

current_prompt = juliaprompt

function hideprompt(f)
  isREPL() || return f()

  print(stdout, "\e[1K\r")
  flush(stdout)
  flush(stderr)
  r = f()
  flush(stdout)
  flush(stderr)
  sleep(0.05)

  pos = @rpc cursorpos()
  pos[1] != 0 && println()
  changeREPLprompt(current_prompt)
  r
end

function changeREPLprompt(prompt; color = :green)
  repl = Base.active_repl
  main_mode = repl.interface.modes[1]
  main_mode.prompt = prompt
  main_mode.prompt_prefix = Base.text_colors[:bold] * Base.text_colors[color]
  print(stdout, "\e[1K\r")
  printstyled(prompt, bold = true, color = color)
  nothing
end

# FIXME: This is ugly and bad, but lets us work around the fact that REPL.run_interface
#        doesn't seem to stop the currently active repl from running. This global
#        switches between two interpreter codepaths when debugging over in ./debugger/stepper.jl.
repleval = false

function changeREPLmodule(mod)
  islocked(evallock) && return nothing

  mod = getthing(mod)

  repl = Base.active_repl
  main_mode = repl.interface.modes[1]
  main_mode.on_done = REPL.respond(repl, main_mode; pass_empty = false) do line
    if !isempty(line)
      if isdebugging()
        quote
          try
            $msg("working")
            $Atom.Debugger.interpret($line)
          finally
            $msg("updateWorkspace")
            $msg("doneWorking")
          end
        end
      else
        quote
          try
            lock($evallock)
            $msg("working")
            Core.eval($Atom, :(repleval = true))
            Base.CoreLogging.with_logger($(Atom.JunoProgressLogger)(Base.CoreLogging.current_logger())) do
              global ans = Core.eval($mod, Meta.parse($line))
            end
            ans
          finally
            unlock($evallock)
            $msg("doneWorking")
            Core.eval($Atom, :(repleval = false))
            @async $msg("updateWorkspace")
          end
        end
      end
    end
  end
end

# make sure DisplayHook() is higher than REPLDisplay() in the display stack
@init begin
  atreplinit((i) -> begin
    Base.Multimedia.popdisplay(Media.DisplayHook())
    Base.Multimedia.pushdisplay(Media.DisplayHook())
    Media.unsetdisplay(Editor(), Any)
    Base.Multimedia.pushdisplay(JunoDisplay())
  end)
end
