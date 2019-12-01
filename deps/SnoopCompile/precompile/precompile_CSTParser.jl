function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    precompile(Tuple{typeof(CSTParser.parse_string_or_cmd), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.get_iters), CSTParser.EXPR, Array{Any, 1}})
    precompile(Tuple{typeof(CSTParser._if_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.accept_rbrace), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser._unescape_string), Base.GenericIOBuffer{Array{UInt8, 1}}, String})
    precompile(Tuple{typeof(CSTParser.parse_ref), CSTParser.ParseState, Int})
    precompile(Tuple{typeof(CSTParser.rem_invis), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.accept_rparen), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.mWhereOpCall), CSTParser.EXPR, CSTParser.EXPR, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.accept_rbrace), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.closer), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_operator_dot), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.accept_rsquare), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    isdefined(CSTParser, Symbol("#kw##parse_parameters")) && precompile(Tuple{getfield(CSTParser, Symbol("#kw##parse_parameters")), NamedTuple{(:usekw,), Tuple{Bool}}, typeof(CSTParser.parse_parameters), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.convert_iter_assign), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Tuple{Tokenize.Tokens.Kind, Tokenize.Tokens.Kind, Tokenize.Tokens.Kind}, Bool})
    precompile(Tuple{typeof(CSTParser.parse_macro), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_array), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.mark_sig_args!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_range), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser._do_kw_convert), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_string_or_cmd), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Tuple{Tokenize.Tokens.Kind}, Bool})
    precompile(Tuple{typeof(CSTParser.parse_unary_colon), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_struct), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.defines_function), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.mark_typealias_bindings!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Tuple{Tokenize.Tokens.Kind, Tokenize.Tokens.Kind}, Bool})
    precompile(Tuple{typeof(CSTParser.parse_module), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_barray), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_comma_sep), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Bool})
    precompile(Tuple{typeof(CSTParser.parse_while), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_tuple), CSTParser.ParseState, Int})
    precompile(Tuple{typeof(CSTParser.parse_call), CSTParser.ParseState, CSTParser.EXPR, Bool})
    precompile(Tuple{typeof(CSTParser._binary_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_begin), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_compound), CSTParser.ParseState, Int})
    precompile(Tuple{typeof(CSTParser.parse_do), CSTParser.ParseState, Int})
    precompile(Tuple{typeof(CSTParser.mBinaryOpCall), CSTParser.EXPR, CSTParser.EXPR, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.fix_range), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.mIDENTIFIER), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_primitive), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_ranges), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.rem_where_subtype), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_quote), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.is_func_call), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.dropleadlingnewline), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_function), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_comp_operator), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.create_tmp), CSTParser.Closer})
    precompile(Tuple{typeof(CSTParser.parse), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.parse_for), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.mPUNCTUATION), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_unary), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_const), CSTParser.ParseState})
    isdefined(CSTParser, Symbol("##parse_parameters#10")) && precompile(Tuple{getfield(CSTParser, Symbol("##parse_parameters#10")), Bool, typeof(CSTParser.parse_parameters), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.isajuxtaposition), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_export), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser._unary_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_macrocall), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.longest_common_prefix), String, String})
    precompile(Tuple{typeof(CSTParser._where_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_operator), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.get_name), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.read_comment), Tokenize.Lexers.Lexer{Base.GenericIOBuffer{Array{UInt8, 1}}, Tokenize.Tokens.RawToken}})
    precompile(Tuple{typeof(CSTParser.accept_rsquare), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_doc), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_operator_colon), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.read_ws), Tokenize.Lexers.Lexer{Base.GenericIOBuffer{Array{UInt8, 1}}, Tokenize.Tokens.RawToken}, Bool, Bool})
    precompile(Tuple{typeof(CSTParser.mUnaryOpCall), CSTParser.EXPR, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.defines_anon_function), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_operator_where), CSTParser.ParseState, Int, CSTParser.EXPR, Bool})
    precompile(Tuple{typeof(CSTParser.accept_end), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.parse_local), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser._kw_convert), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.accept_rparen), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.parse_operator_anon_func), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_imports), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_operator_cond), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_dot_mod), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.parse_abstract), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.mLITERAL), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_if), CSTParser.ParseState, Bool})
    precompile(Tuple{typeof(CSTParser.GlobalRefDOC)})
    precompile(Tuple{typeof(CSTParser.precedence), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_curly), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.INSTANCE), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.skip_to_nl), String, Int64})
    precompile(Tuple{typeof(CSTParser.parse_iter), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.Expr_cmd), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_try), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_paren), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser._let_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.Expr_char), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_expression), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_global), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.accept_end), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_generator), CSTParser.ParseState, Int})
    precompile(Tuple{typeof(CSTParser._continue_doc_parse), CSTParser.EXPR, CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.lex_ws_comment), Tokenize.Lexers.Lexer{Base.GenericIOBuffer{Array{UInt8, 1}}, Tokenize.Tokens.RawToken}, Char})
    precompile(Tuple{typeof(CSTParser.parse_kw), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.setiterbinding!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.requires_ws), CSTParser.EXPR, CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_return), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.is_assignment), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.get_inner_gen), CSTParser.EXPR, Array{Any, 1}, Array{Any, 1}})
    precompile(Tuple{typeof(CSTParser.strip_where_scopes), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_operator_power), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.update_from_tmp!), CSTParser.Closer, CSTParser.Closer_TMP})
    precompile(Tuple{typeof(CSTParser.mKEYWORD), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.rem_subtype), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.Expr_tcmd), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_comma_sep), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Bool, Bool, Bool})
    precompile(Tuple{typeof(CSTParser.is_number), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.markparameters!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.update_span!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.setbinding!), CSTParser.EXPR, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_decl), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.mOPERATOR), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.is_colon), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_lparen), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_issubt), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_dot), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.Expr_float), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_issupt), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_where), Nothing})
    precompile(Tuple{typeof(CSTParser.update_to_default!), CSTParser.Closer})
    precompile(Tuple{typeof(CSTParser.Expr_int), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_curly), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_where), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_let), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.expr_import), CSTParser.EXPR, Symbol})
    precompile(Tuple{typeof(CSTParser.parse_operator_eq), CSTParser.ParseState, Int, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.is_wrapped_assignment), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.get_sig), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_call), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.next), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.sized_uint_oct_literal), String})
    precompile(Tuple{typeof(CSTParser._literal_expr), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.rem_subtype), Nothing})
    precompile(Tuple{typeof(CSTParser.parse_call), CSTParser.ParseState, CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.setbinding!), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.str_value), CSTParser.EXPR})
    precompile(Tuple{typeof(CSTParser.parse_mutable), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_braces), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Tuple{Tokenize.Tokens.Kind, Tokenize.Tokens.Kind}})
    precompile(Tuple{typeof(CSTParser.sized_uint_literal), String, Int64})
    isdefined(CSTParser, Symbol("#kw##parse_parameters")) && precompile(Tuple{getfield(CSTParser, Symbol("#kw##parse_parameters")), NamedTuple{(:usekw,), Tuple{Bool}}, typeof(CSTParser.parse_parameters), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Tuple{Tokenize.Tokens.Kind, Tokenize.Tokens.Kind, Tokenize.Tokens.Kind}})
    precompile(Tuple{typeof(CSTParser.parse_block), CSTParser.ParseState, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.parse_parameters), CSTParser.ParseState, Array{CSTParser.EXPR, 1}, Array{CSTParser.EXPR, 1}})
    precompile(Tuple{typeof(CSTParser.parse_string_or_cmd), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_array), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_dot_mod), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_ranges), CSTParser.ParseState})
    precompile(Tuple{typeof(CSTParser.parse_if), CSTParser.ParseState})
end
