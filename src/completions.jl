handle("completions") do data
  @destruct [path || nothing,
             mod || "Main",
             editorContent || "",
             lineNumber || 1,
             startLine || 0,
             column || 1,
             line, force] = data

  withpath(path) do
    m = getmodule(mod)

    comps, prefix = basecompletionadapter(line, m, force, lineNumber - startLine, column, editorContent)

    Dict(:completions => comps,
         :prefix      => string(prefix))
  end
end

using REPL.REPLCompletions

const MAX_COMPLETIONS = Ref{Int}(100)

"""
    set_max_completions(max_completions::Int)

Set the maximum number of auto-completion suggestions to `max_completions`.
"""
set_max_completions(max_completions::Int) = MAX_COMPLETIONS[] = max_completions
export set_max_completions

function basecompletionadapter(line, mod, force, lineNumber, column, text)
  cs, replace, shouldcomplete = try
    completions(line, lastindex(line), mod; filter_nonpositive_scores = !force, max_completions = MAX_COMPLETIONS[])
  catch err
    # might error when e.g. type inference fails
    [], 1:0, false
  end

  prefix = line[replace]
  comps = []
  for c in cs
    if REPLCompletions.afterusing(line, Int(first(replace))) # need `Int` for correct dispatch on x86
      c isa REPLCompletions.PackageCompletion || continue
    end
    try
      push!(comps, completion(mod, c))
    catch err
      continue
    end
  end

  (!isempty(prefix) || force) && @>> begin
    localcompletions(text, lineNumber, column)
    filter!(c -> REPL.fuzzyscore(prefix, c[:text]) ≥ 0)
    sort!(; by = c -> REPL.fuzzyscore(prefix, c[:text]), rev = true)
    prepend!(comps)
  end

  comps, prefix
end

function completion(mod, c)
  return Dict(:type               => completiontype(c),
              :icon               => completionicon(c),
              :rightLabel         => completionmodule(mod, c),
              :leftLabel          => completionreturntype(c),
              :text               => completiontext(c),
              :description        => completionsummary(mod, c),
              :descriptionMoreURL => completionurl(c))
end

completiontext(c) = completion_text(c)
completiontext(c::REPLCompletions.MethodCompletion) = begin
  ct = completion_text(c)
  m = match(r"^(.*) in .*$", ct)
  m isa Nothing ? ct : m[1]
end
completiontext(c::REPLCompletions.DictCompletion) = rstrip(completion_text(c), [']', '"'])
completiontext(c::REPLCompletions.PathCompletion) = rstrip(completion_text(c), '"')

using JuliaInterpreter: sparam_syms

completionreturntype(c) = ""
completionreturntype(c::REPLCompletions.MethodCompletion) = begin
  m = c.method
  atypes = m.sig
  sparams = Core.svec(sparam_syms(m)...)
  wa = Core.Compiler.Params(typemax(UInt))  # world age
  inf = try
    Core.Compiler.typeinf_type(m, atypes, sparams, wa)
  catch err
    nothing
  end
  inf in (nothing, Any, Union{}) && return ""
  shortstr(inf)
end
completionreturntype(c::REPLCompletions.PropertyCompletion) =
  shortstr(typeof(getproperty(c.value, c.property)))
completionreturntype(c::REPLCompletions.FieldCompletion) =
  shortstr(fieldtype(c.typ, c.field))
completionreturntype(c::REPLCompletions.DictCompletion) =
  shortstr(valtype(c.dict))
completionreturntype(::REPLCompletions.PathCompletion) = "Path"

using Base.Docs

completionsummary(mod, c) = ""
completionsummary(mod, c::REPLCompletions.ModuleCompletion) = begin
  m, word = c.parent, c.mod
  cangetdocs(m, word) || return ""
  docs = getdocs(m, word, mod)
  description(docs)
end
completionsummary(mod, c::REPLCompletions.MethodCompletion) = begin
  ct = Symbol(c.func)
  cangetdocs(mod, ct) || return ""
  docs = try
    Docs.doc(Docs.Binding(mod, ct), Base.tuple_type_tail(c.method.sig))
  catch err
    ""
  end
  description(docs)
end
completionsummary(mod, c::REPLCompletions.KeywordCompletion) =
  description(getdocs(mod, c.keyword))

using Markdown

description(docs) = ""
description(docs::Markdown.MD) = begin
  md = CodeTools.flatten(docs).content
  for part in md
    if part isa Markdown.Paragraph
      desc = Markdown.plain(part)
      occursin("No documentation found.", desc) && return ""
      return strlimit(desc, 200)
    end
  end
  return ""
end

completionurl(c) = ""
completionurl(c::REPLCompletions.ModuleCompletion) = begin
  mod, name = c.parent, c.mod
  val = getfield′(mod, name)
  if val isa Module # module info
    urimoduleinfo(parentmodule(val) == val || val ∈ (Base, Core) ? name : "$mod.$name")
  else
    uridocs(mod, name)
  end
end
completionurl(c::REPLCompletions.MethodCompletion) = uridocs(c.method.module, c.method.name)
completionurl(c::REPLCompletions.PackageCompletion) = urimoduleinfo(c.package)
completionurl(c::REPLCompletions.KeywordCompletion) = uridocs("Main", c.keyword)

completionmodule(mod, c) = shortstr(mod)
completionmodule(mod, c::REPLCompletions.ModuleCompletion) = shortstr(c.parent)
completionmodule(mod, c::REPLCompletions.MethodCompletion) = shortstr(c.method.module)
completionmodule(mod, c::REPLCompletions.FieldCompletion) = shortstr(c.typ) # predicted type
completionmodule(mod, ::REPLCompletions.KeywordCompletion) = ""
completionmodule(mod, ::REPLCompletions.PathCompletion) = ""

completiontype(c) = "variable"
completiontype(c::REPLCompletions.ModuleCompletion) = begin
  ct = completion_text(c)
  ismacro(ct) && return "snippet"
  ct == "Vararg" && return ""
  mod, name = c.parent, Symbol(ct)
  val = getfield′(mod, name)
  wstype(mod, name, val)
end
completiontype(::REPLCompletions.MethodCompletion) = "method"
completiontype(::REPLCompletions.PackageCompletion) = "import"
completiontype(::REPLCompletions.PropertyCompletion) = "property"
completiontype(::REPLCompletions.FieldCompletion) = "property"
completiontype(::REPLCompletions.DictCompletion) = "property"
completiontype(::REPLCompletions.KeywordCompletion) = "keyword"
completiontype(::REPLCompletions.PathCompletion) = "path"

completionicon(c) = ""
completionicon(c::REPLCompletions.ModuleCompletion) = begin
  ismacro(c.mod) && return "icon-mention"
  mod, name = c.parent, Symbol(c.mod)
  val = getfield′(mod, name)
  wsicon(mod, name, val)
end
completionicon(::REPLCompletions.DictCompletion) = "icon-key"
completionicon(::REPLCompletions.PathCompletion) = "icon-file"

localcompletions(text, line, col) = localcompletion.(reverse!(locals(text, line, col)))

function localcompletion(l)
  return Dict(
    :type        => l[:type] == "variable" ? "attribute" : l[:type],
    :icon        => l[:icon] == "v" ? "icon-chevron-right" : l[:icon],
    :rightLabel  => l[:root],
    :leftLabel   => "",
    :text        => l[:name],
    :description => ""
  )
end
