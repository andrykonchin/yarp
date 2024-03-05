# frozen_string_literal: true

require_relative "test_helper"

File.delete("passing.txt") if File.exist?("passing.txt")
File.delete("failing.txt") if File.exist?("failing.txt")

module Prism
  class RipperTestCase < TestCase
    private

    def truffleruby?
      RUBY_ENGINE == "truffleruby"
    end

    # Ripper produces certain ambiguous structures. For instance, it often
    # adds an :args_add_block with "false" as the block meaning there is
    # no block call. It can be hard to tell which of multiple equivalent
    # structures it will produce. This method attempts to return a normalized
    # comparable structure.
    def normalized_sexp(parsed)
      if parsed.is_a?(Array)
        # For args_add_block, if the third entry is nil or false, remove it.
        # Note that CRuby Ripper uses false for no block, while older JRuby
        # uses nil. We need to do this for both.
        return normalized_sexp(parsed[1]) if parsed[0] == :args_add_block && !parsed[2]

        parsed.each.with_index do |item, idx|
          if item.is_a?(Array)
            parsed[idx] = normalized_sexp(parsed[idx])
          end
        end
      end

      parsed
    end

    def assert_ripper_equivalent(source, path: "inline source code")
      expected = Ripper.sexp_raw(source)

      refute_nil expected, "Could not parse #{path} with Ripper!"
      expected = normalized_sexp(expected)
      actual = Prism::Translation::Ripper.sexp_raw(source)
      refute_nil actual, "Could not parse #{path} with Prism!"
      actual = normalized_sexp(actual)
      assert_equal expected, actual, "Expected Ripper and Prism to give equivalent output for #{path}!"
    end
  end

  class RipperShortSourceTest < RipperTestCase
    def test_binary
      assert_equivalent("1 + 2")
      assert_equivalent("3 - 4 * 5")
      assert_equivalent("6 / 7; 8 % 9")
    end

    def test_unary
      assert_equivalent("-7")
    end

    def test_unary_parens
      assert_equivalent("-(7)")
      assert_equivalent("(-7)")
      assert_equivalent("(-\n7)")
    end

    def test_binary_parens
      assert_equivalent("(3 + 7) * 4")
    end

    def test_method_calls_with_variable_names
      assert_equivalent("foo")
      assert_equivalent("foo()")
      assert_equivalent("foo -7")
      assert_equivalent("foo(-7)")
      assert_equivalent("foo(1, 2, 3)")
      assert_equivalent("foo 1")
      assert_equivalent("foo bar")
      assert_equivalent("foo 1, 2")
      assert_equivalent("foo.bar")

      # TruffleRuby prints emoji symbols differently in a way that breaks here.
      unless truffleruby?
        assert_equivalent("🗻")
        assert_equivalent("🗻.location")
        assert_equivalent("foo.🗻")
        assert_equivalent("🗻.😮!")
        assert_equivalent("🗻 🗻,🗻,🗻")
      end

      assert_equivalent("foo&.bar")
      assert_equivalent("foo { bar }")
      assert_equivalent("foo.bar { 7 }")
      assert_equivalent("foo(1) { bar }")
      assert_equivalent("foo(bar)")
      assert_equivalent("foo(bar(1))")
      assert_equivalent("foo(bar(1)) { 7 }")
      assert_equivalent("foo bar(1)")
    end

    def test_method_call_blocks
      assert_equivalent("foo { |a| a }")

      assert_equivalent("foo(bar 1)")
      assert_equivalent("foo bar 1")
      assert_equivalent("foo(bar 1) { 7 }")
      assert_equivalent("foo(bar 1) {; 7 }")
      assert_equivalent("foo(bar 1) {;}")

      assert_equivalent("foo do\n  bar\nend")
      assert_equivalent("foo do\nend")
      assert_equivalent("foo do; end")
      assert_equivalent("foo do bar; end")
      assert_equivalent("foo do bar end")
      assert_equivalent("foo do; bar; end")
    end

    def test_method_calls_on_immediate_values
      assert_equivalent("7.even?")
      assert_equivalent("!1")
      assert_equivalent("7 && 7")
      assert_equivalent("7 and 7")
      assert_equivalent("7 || 7")
      assert_equivalent("7 or 7")
      assert_equivalent("'racecar'.reverse")
    end

    def test_range
      assert_equivalent("(...2)")
      assert_equivalent("(..2)")
      assert_equivalent("(1...2)")
      assert_equivalent("(1..2)")
      assert_equivalent("(foo..-7)")
    end

    def test_parentheses
      assert_equivalent("()")
      assert_equivalent("(1)")
      assert_equivalent("(1; 2)")
    end

    def test_numbers
      assert_equivalent("[1, -1, +1, 1.0, -1.0, +1.0]")
      assert_equivalent("[1r, -1r, +1r, 1.5r, -1.5r, +1.5r]")
      assert_equivalent("[1i, -1i, +1i, 1.5i, -1.5i, +1.5i]")
      assert_equivalent("[1ri, -1ri, +1ri, 1.5ri, -1.5ri, +1.5ri]")
    end

    def test_begin_end
      # Empty begin
      assert_equivalent("begin; end")
      assert_equivalent("begin end")
      assert_equivalent("begin; rescue; end")

      assert_equivalent("begin:s.l end")
    end

    def test_begin_rescue
      # Rescue with exception(s)
      assert_equivalent("begin a; rescue Exception => ex; c; end")
      assert_equivalent("begin a; rescue RuntimeError => ex; c; rescue Exception => ex; d; end")
      assert_equivalent("begin a; rescue RuntimeError => ex; c; rescue Exception => ex; end")
      assert_equivalent("begin a; rescue RuntimeError,FakeError,Exception => ex; c; end")
      assert_equivalent("begin a; rescue RuntimeError,FakeError,Exception; c; end")

      # Empty rescue
      assert_equivalent("begin a; rescue; ensure b; end")
      assert_equivalent("begin a; rescue; end")

      assert_equivalent("begin; a; ensure; b; end")
    end

    def test_begin_ensure
      # Empty ensure
      assert_equivalent("begin a; rescue; c; ensure; end")
      assert_equivalent("begin a; ensure; end")
      assert_equivalent("begin; ensure; end")

      # Ripper treats statements differently, depending whether there's
      # a semicolon after the keyword.
      assert_equivalent("begin a; rescue; c; ensure b; end")
      assert_equivalent("begin a; rescue c; ensure b; end")
      assert_equivalent("begin a; rescue; c; ensure; b; end")

      # Need to make sure we're handling multibyte characters correctly for source offsets
      assert_equivalent("begin 🗻; rescue; c;     ensure;🗻🗻🗻🗻🗻; end")
      assert_equivalent("begin 🗻; rescue; c;     ensure 🗻🗻🗻🗻🗻; end")
    end

    def test_break
      assert_equivalent("foo { break }")
      assert_equivalent("foo { break 7 }")
      assert_equivalent("foo { break [1, 2, 3] }")
    end

    def test_constants
      assert_equivalent("Foo")
      assert_equivalent("Foo + F🗻")
      assert_equivalent("Foo = 'soda'")
    end

    def test_op_assign
      assert_equivalent("a += b")
      assert_equivalent("a -= b")
      assert_equivalent("a *= b")
      assert_equivalent("a /= b")
    end

    def test_arrays
      assert_equivalent("[1, 2, 7]")
      assert_equivalent("[1, [2, 7]]")
    end

    def test_array_refs
      assert_equivalent("a[1]")
      assert_equivalent("a[1] = 7")
    end

    def test_strings
      assert_equivalent("'a'")
      assert_equivalent("'a\01'")
      assert_equivalent("`a`")
      assert_equivalent("`a\07`")
      assert_equivalent('"a#{1}c"')
      assert_equivalent('"a#{1}b#{2}c"')
      assert_equivalent("`f\oo`")
    end

    def test_symbols
      assert_equivalent(":a")
      assert_equivalent(":'a'")
      assert_equivalent(':"a"')
      assert_equivalent("%s(foo)")
    end

    def test_assign
      assert_equivalent("a = b")
      assert_equivalent("a = 1")
    end

    def test_alias
      assert_equivalent("alias :foo :bar")
      assert_equivalent("alias $a $b")
      assert_equivalent("alias $a $'")
      assert_equivalent("alias foo bar")
      assert_equivalent("alias foo if")
      assert_equivalent("alias :'def' :\"abc\#{1}\"")
      assert_equivalent("alias :\"abc\#{1}\" :'def'")

      unless truffleruby?
        assert_equivalent("alias :foo :Ę") # Uppercase Unicode character is a constant
        assert_equivalent("alias :Ę :foo")
      end

      assert_equivalent("alias foo +")
      assert_equivalent("alias foo :+")
      assert_equivalent("alias :foo :''")
      assert_equivalent("alias :'' :foo")
    end

    def test_keyword_aliases
      assert_equivalent("alias :foo :if")
      assert_equivalent("alias :foo :self")
      assert_equivalent("alias :foo :__FILE__")
      assert_equivalent("alias foo __ENCODING__")
    end

    private

    def assert_equivalent(source)
      assert_ripper_equivalent(source)
    end
  end

  class RipperFixturesTest < RipperTestCase
    base = File.join(__dir__, "fixtures")
    relatives = ENV["FOCUS"] ? [ENV["FOCUS"]] : Dir["**/*.txt", base: base]

    skips = %w[
      arrays.txt
      begin_ensure.txt
      begin_rescue.txt
      blocks.txt
      case.txt
      classes.txt
      command_method_call.txt
      constants.txt
      dash_heredocs.txt
      dos_endings.txt
      embdoc_no_newline_at_end.txt
      emoji_method_calls.txt
      endless_methods.txt
      for.txt
      global_variables.txt
      hashes.txt
      heredoc_with_escaped_newline_at_start.txt
      heredoc_with_trailing_newline.txt
      heredocs_leading_whitespace.txt
      heredocs_nested.txt
      heredocs_with_ignored_newlines.txt
      if.txt
      keyword_method_names.txt
      lambda.txt
      method_calls.txt
      methods.txt
      modules.txt
      multi_write.txt
      non_alphanumeric_methods.txt
      not.txt
      patterns.txt
      procs.txt
      regex.txt
      regex_char_width.txt
      repeat_parameters.txt
      rescue.txt
      return.txt
      seattlerb/TestRubyParserShared.txt
      seattlerb/and_multi.txt
      seattlerb/array_lits_trailing_calls.txt
      seattlerb/attr_asgn_colon_id.txt
      seattlerb/attrasgn_primary_dot_constant.txt
      seattlerb/begin_rescue_else_ensure_bodies.txt
      seattlerb/begin_rescue_else_ensure_no_bodies.txt
      seattlerb/block_break.txt
      seattlerb/block_call_dot_op2_brace_block.txt
      seattlerb/block_call_dot_op2_cmd_args_do_block.txt
      seattlerb/block_call_operation_colon.txt
      seattlerb/block_call_operation_dot.txt
      seattlerb/block_call_paren_call_block_call.txt
      seattlerb/block_command_operation_colon.txt
      seattlerb/block_command_operation_dot.txt
      seattlerb/block_decomp_anon_splat_arg.txt
      seattlerb/block_decomp_arg_splat.txt
      seattlerb/block_decomp_arg_splat_arg.txt
      seattlerb/block_decomp_splat.txt
      seattlerb/block_next.txt
      seattlerb/block_paren_splat.txt
      seattlerb/block_return.txt
      seattlerb/bug169.txt
      seattlerb/bug179.txt
      seattlerb/bug190.txt
      seattlerb/bug191.txt
      seattlerb/bug_215.txt
      seattlerb/bug_249.txt
      seattlerb/bug_args__19.txt
      seattlerb/bug_args_masgn.txt
      seattlerb/bug_args_masgn2.txt
      seattlerb/bug_args_masgn_outer_parens__19.txt
      seattlerb/bug_call_arglist_parens.txt
      seattlerb/bug_comma.txt
      seattlerb/bug_hash_args_trailing_comma.txt
      seattlerb/bug_hash_interp_array.txt
      seattlerb/bug_masgn_right.txt
      seattlerb/bug_not_parens.txt
      seattlerb/call_args_assoc_quoted.txt
      seattlerb/call_args_assoc_trailing_comma.txt
      seattlerb/call_args_command.txt
      seattlerb/call_array_lambda_block_call.txt
      seattlerb/call_assoc_new_if_multiline.txt
      seattlerb/call_assoc_trailing_comma.txt
      seattlerb/call_bang_command_call.txt
      seattlerb/call_block_arg_named.txt
      seattlerb/call_colon2.txt
      seattlerb/call_colon_parens.txt
      seattlerb/call_dot_parens.txt
      seattlerb/call_not.txt
      seattlerb/call_stabby_do_end_with_block.txt
      seattlerb/call_stabby_with_braces_block.txt
      seattlerb/call_trailing_comma.txt
      seattlerb/case_in.txt
      seattlerb/case_in_37.txt
      seattlerb/case_in_else.txt
      seattlerb/case_in_hash_pat.txt
      seattlerb/case_in_hash_pat_assign.txt
      seattlerb/case_in_hash_pat_paren_assign.txt
      seattlerb/case_in_hash_pat_paren_true.txt
      seattlerb/case_in_hash_pat_rest.txt
      seattlerb/case_in_hash_pat_rest_solo.txt
      seattlerb/class_comments.txt
      seattlerb/defn_arg_forward_args.txt
      seattlerb/defn_args_forward_args.txt
      seattlerb/defn_forward_args.txt
      seattlerb/defn_forward_args__no_parens.txt
      seattlerb/defn_kwarg_lvar.txt
      seattlerb/defn_oneliner_eq2.txt
      seattlerb/defn_oneliner_rescue.txt
      seattlerb/defns_reserved.txt
      seattlerb/defs_as_arg_with_do_block_inside.txt
      seattlerb/defs_comments.txt
      seattlerb/defs_endless_command.txt
      seattlerb/defs_endless_command_rescue.txt
      seattlerb/defs_kwarg.txt
      seattlerb/defs_oneliner.txt
      seattlerb/defs_oneliner_eq2.txt
      seattlerb/defs_oneliner_rescue.txt
      seattlerb/difficult1_line_numbers.txt
      seattlerb/difficult2_.txt
      seattlerb/difficult3_.txt
      seattlerb/difficult3_4.txt
      seattlerb/difficult3_5.txt
      seattlerb/difficult3__10.txt
      seattlerb/difficult3__11.txt
      seattlerb/difficult3__12.txt
      seattlerb/difficult3__6.txt
      seattlerb/difficult3__7.txt
      seattlerb/difficult3__8.txt
      seattlerb/difficult3__9.txt
      seattlerb/difficult6__7.txt
      seattlerb/difficult6__8.txt
      seattlerb/difficult7_.txt
      seattlerb/do_lambda.txt
      seattlerb/heredoc__backslash_dos_format.txt
      seattlerb/heredoc_backslash_nl.txt
      seattlerb/heredoc_bad_hex_escape.txt
      seattlerb/heredoc_bad_oct_escape.txt
      seattlerb/heredoc_nested.txt
      seattlerb/heredoc_squiggly.txt
      seattlerb/heredoc_squiggly_blank_line_plus_interpolation.txt
      seattlerb/heredoc_squiggly_blank_lines.txt
      seattlerb/heredoc_squiggly_empty.txt
      seattlerb/heredoc_squiggly_interp.txt
      seattlerb/heredoc_squiggly_tabs.txt
      seattlerb/heredoc_squiggly_tabs_extra.txt
      seattlerb/heredoc_squiggly_visually_blank_lines.txt
      seattlerb/heredoc_with_carriage_return_escapes.txt
      seattlerb/heredoc_with_carriage_return_escapes_windows.txt
      seattlerb/heredoc_with_only_carriage_returns.txt
      seattlerb/heredoc_with_only_carriage_returns_windows.txt
      seattlerb/if_elsif.txt
      seattlerb/index_0.txt
      seattlerb/index_0_opasgn.txt
      seattlerb/interpolated_symbol_array_line_breaks.txt
      seattlerb/interpolated_word_array_line_breaks.txt
      seattlerb/iter_args_2__19.txt
      seattlerb/iter_args_3.txt
      seattlerb/lambda_do_vs_brace.txt
      seattlerb/lasgn_command.txt
      seattlerb/lasgn_middle_splat.txt
      seattlerb/magic_encoding_comment.txt
      seattlerb/masgn_anon_splat_arg.txt
      seattlerb/masgn_arg_colon_arg.txt
      seattlerb/masgn_arg_ident.txt
      seattlerb/masgn_arg_splat_arg.txt
      seattlerb/masgn_colon2.txt
      seattlerb/masgn_colon3.txt
      seattlerb/masgn_command_call.txt
      seattlerb/masgn_double_paren.txt
      seattlerb/masgn_lhs_splat.txt
      seattlerb/masgn_paren.txt
      seattlerb/masgn_splat_arg.txt
      seattlerb/masgn_splat_arg_arg.txt
      seattlerb/masgn_star.txt
      seattlerb/masgn_var_star_var.txt
      seattlerb/messy_op_asgn_lineno.txt
      seattlerb/method_call_assoc_trailing_comma.txt
      seattlerb/method_call_trailing_comma.txt
      seattlerb/mlhs_back_anonsplat.txt
      seattlerb/mlhs_back_splat.txt
      seattlerb/mlhs_front_anonsplat.txt
      seattlerb/mlhs_front_splat.txt
      seattlerb/mlhs_keyword.txt
      seattlerb/mlhs_mid_anonsplat.txt
      seattlerb/mlhs_mid_splat.txt
      seattlerb/module_comments.txt
      seattlerb/non_interpolated_symbol_array_line_breaks.txt
      seattlerb/non_interpolated_word_array_line_breaks.txt
      seattlerb/op_asgn_command_call.txt
      seattlerb/op_asgn_dot_ident_command_call.txt
      seattlerb/op_asgn_index_command_call.txt
      seattlerb/op_asgn_primary_colon_identifier1.txt
      seattlerb/op_asgn_primary_colon_identifier_command_call.txt
      seattlerb/op_asgn_val_dot_ident_command_call.txt
      seattlerb/parse_if_not_canonical.txt
      seattlerb/parse_if_not_noncanonical.txt
      seattlerb/parse_line_defn_complex.txt
      seattlerb/parse_line_dstr_escaped_newline.txt
      seattlerb/parse_line_dstr_soft_newline.txt
      seattlerb/parse_line_evstr_after_break.txt
      seattlerb/parse_line_heredoc_hardnewline.txt
      seattlerb/parse_line_iter_call_no_parens.txt
      seattlerb/parse_line_multiline_str_literal_n.txt
      seattlerb/parse_line_return.txt
      seattlerb/parse_line_str_with_newline_escape.txt
      seattlerb/parse_opt_call_args_assocs_comma.txt
      seattlerb/parse_opt_call_args_lit_comma.txt
      seattlerb/parse_pattern_051.txt
      seattlerb/parse_pattern_058.txt
      seattlerb/parse_pattern_058_2.txt
      seattlerb/parse_pattern_069.txt
      seattlerb/parse_pattern_076.txt
      seattlerb/parse_until_not_canonical.txt
      seattlerb/parse_until_not_noncanonical.txt
      seattlerb/parse_while_not_canonical.txt
      seattlerb/parse_while_not_noncanonical.txt
      seattlerb/pctW_lineno.txt
      seattlerb/pct_nl.txt
      seattlerb/pct_w_heredoc_interp_nested.txt
      seattlerb/qWords_space.txt
      seattlerb/qsymbols.txt
      seattlerb/qsymbols_empty.txt
      seattlerb/qsymbols_empty_space.txt
      seattlerb/qsymbols_interp.txt
      seattlerb/quoted_symbol_hash_arg.txt
      seattlerb/quoted_symbol_keys.txt
      seattlerb/qw_escape_term.txt
      seattlerb/qwords_empty.txt
      seattlerb/read_escape_unicode_curlies.txt
      seattlerb/read_escape_unicode_h4.txt
      seattlerb/regexp_esc_C_slash.txt
      seattlerb/regexp_escape_extended.txt
      seattlerb/rescue_do_end_ensure_result.txt
      seattlerb/rescue_do_end_no_raise.txt
      seattlerb/rescue_do_end_raised.txt
      seattlerb/rescue_do_end_rescued.txt
      seattlerb/rescue_in_block.txt
      seattlerb/rescue_parens.txt
      seattlerb/return_call_assocs.txt
      seattlerb/safe_attrasgn.txt
      seattlerb/safe_attrasgn_constant.txt
      seattlerb/safe_call_dot_parens.txt
      seattlerb/safe_call_operator.txt
      seattlerb/safe_calls.txt
      seattlerb/safe_op_asgn.txt
      seattlerb/safe_op_asgn2.txt
      seattlerb/slashy_newlines_within_string.txt
      seattlerb/stabby_arg_no_paren.txt
      seattlerb/stabby_block_iter_call.txt
      seattlerb/stabby_block_iter_call_no_target_with_arg.txt
      seattlerb/str_double_double_escaped_newline.txt
      seattlerb/str_double_escaped_newline.txt
      seattlerb/str_interp_ternary_or_label.txt
      seattlerb/str_lit_concat_bad_encodings.txt
      seattlerb/str_newline_hash_line_number.txt
      seattlerb/str_single_double_escaped_newline.txt
      seattlerb/symbol_list.txt
      seattlerb/symbols.txt
      seattlerb/symbols_empty.txt
      seattlerb/symbols_empty_space.txt
      seattlerb/symbols_interp.txt
      seattlerb/thingy.txt
      seattlerb/when_splat.txt
      seattlerb/words_interp.txt
      seattlerb/yield_call_assocs.txt
      seattlerb/yield_empty_parens.txt
      single_method_call_with_bang.txt
      spanning_heredoc.txt
      spanning_heredoc_newlines.txt
      strings.txt
      super.txt
      symbols.txt
      ternary_operator.txt
      tilde_heredocs.txt
      undef.txt
      unescaping.txt
      unless.txt
      unparser/corpus/literal/assignment.txt
      unparser/corpus/literal/block.txt
      unparser/corpus/literal/case.txt
      unparser/corpus/literal/class.txt
      unparser/corpus/literal/control.txt
      unparser/corpus/literal/def.txt
      unparser/corpus/literal/defined.txt
      unparser/corpus/literal/defs.txt
      unparser/corpus/literal/dstr.txt
      unparser/corpus/literal/empty.txt
      unparser/corpus/literal/for.txt
      unparser/corpus/literal/if.txt
      unparser/corpus/literal/kwbegin.txt
      unparser/corpus/literal/lambda.txt
      unparser/corpus/literal/literal.txt
      unparser/corpus/literal/module.txt
      unparser/corpus/literal/opasgn.txt
      unparser/corpus/literal/pattern.txt
      unparser/corpus/literal/rescue.txt
      unparser/corpus/literal/send.txt
      unparser/corpus/literal/since/27.txt
      unparser/corpus/literal/since/31.txt
      unparser/corpus/literal/since/32.txt
      unparser/corpus/literal/super.txt
      unparser/corpus/literal/while.txt
      unparser/corpus/literal/yield.txt
      unparser/corpus/semantic/block.txt
      unparser/corpus/semantic/dstr.txt
      unparser/corpus/semantic/kwbegin.txt
      unparser/corpus/semantic/literal.txt
      unparser/corpus/semantic/send.txt
      unparser/corpus/semantic/while.txt
      until.txt
      variables.txt
      while.txt
      whitequark/ambiuous_quoted_label_in_ternary_operator.txt
      whitequark/and_asgn.txt
      whitequark/anonymous_blockarg.txt
      whitequark/arg_scope.txt
      whitequark/args.txt
      whitequark/args_args_assocs.txt
      whitequark/args_args_assocs_comma.txt
      whitequark/args_args_comma.txt
      whitequark/args_args_star.txt
      whitequark/args_assocs.txt
      whitequark/args_assocs_comma.txt
      whitequark/args_assocs_legacy.txt
      whitequark/args_block_pass.txt
      whitequark/args_cmd.txt
      whitequark/args_star.txt
      whitequark/array_splat.txt
      whitequark/array_symbols.txt
      whitequark/array_symbols_empty.txt
      whitequark/array_symbols_interp.txt
      whitequark/array_words.txt
      whitequark/array_words_empty.txt
      whitequark/array_words_interp.txt
      whitequark/asgn_mrhs.txt
      whitequark/break_block.txt
      whitequark/bug_435.txt
      whitequark/bug_447.txt
      whitequark/bug_452.txt
      whitequark/bug_466.txt
      whitequark/bug_480.txt
      whitequark/bug_ascii_8bit_in_literal.txt
      whitequark/bug_cmd_string_lookahead.txt
      whitequark/bug_cmdarg.txt
      whitequark/bug_do_block_in_cmdarg.txt
      whitequark/bug_do_block_in_hash_brace.txt
      whitequark/bug_heredoc_do.txt
      whitequark/bug_interp_single.txt
      whitequark/bug_rescue_empty_else.txt
      whitequark/bug_while_not_parens_do.txt
      whitequark/case_cond_else.txt
      whitequark/case_expr_else.txt
      whitequark/character.txt
      whitequark/class_definition_in_while_cond.txt
      whitequark/dedenting_heredoc.txt
      whitequark/dedenting_interpolating_heredoc_fake_line_continuation.txt
      whitequark/dedenting_non_interpolating_heredoc_line_continuation.txt
      whitequark/def.txt
      whitequark/defs.txt
      whitequark/empty_stmt.txt
      whitequark/endless_method.txt
      whitequark/endless_method_command_syntax.txt
      whitequark/endless_method_forwarded_args_legacy.txt
      whitequark/endless_method_with_rescue_mod.txt
      whitequark/endless_method_without_args.txt
      whitequark/for_mlhs.txt
      whitequark/forward_arg.txt
      whitequark/forward_arg_with_open_args.txt
      whitequark/forward_args_legacy.txt
      whitequark/forwarded_argument_with_kwrestarg.txt
      whitequark/forwarded_argument_with_restarg.txt
      whitequark/forwarded_kwrestarg.txt
      whitequark/forwarded_kwrestarg_with_additional_kwarg.txt
      whitequark/forwarded_restarg.txt
      whitequark/hash_label_end.txt
      whitequark/if_else.txt
      whitequark/if_elsif.txt
      whitequark/interp_digit_var.txt
      whitequark/kwbegin_compstmt.txt
      whitequark/kwoptarg_with_kwrestarg_and_forwarded_args.txt
      whitequark/lbrace_arg_after_command_args.txt
      whitequark/lparenarg_after_lvar__since_25.txt
      whitequark/lvar_injecting_match.txt
      whitequark/masgn.txt
      whitequark/masgn_attr.txt
      whitequark/masgn_nested.txt
      whitequark/masgn_splat.txt
      whitequark/method_definition_in_while_cond.txt
      whitequark/multiple_pattern_matches.txt
      whitequark/newline_in_hash_argument.txt
      whitequark/next_block.txt
      whitequark/not.txt
      whitequark/not_cmd.txt
      whitequark/numbered_args_after_27.txt
      whitequark/numparam_outside_block.txt
      whitequark/op_asgn.txt
      whitequark/op_asgn_cmd.txt
      whitequark/op_asgn_index.txt
      whitequark/op_asgn_index_cmd.txt
      whitequark/or_asgn.txt
      whitequark/parser_bug_272.txt
      whitequark/parser_bug_507.txt
      whitequark/parser_bug_525.txt
      whitequark/parser_bug_604.txt
      whitequark/parser_bug_640.txt
      whitequark/parser_drops_truncated_parts_of_squiggly_heredoc.txt
      whitequark/parser_slash_slash_n_escaping_in_literals.txt
      whitequark/pattern_matching_blank_else.txt
      whitequark/pattern_matching_else.txt
      whitequark/pattern_matching_single_line_allowed_omission_of_parentheses.txt
      whitequark/procarg0.txt
      whitequark/resbody_var.txt
      whitequark/rescue_else.txt
      whitequark/rescue_else_ensure.txt
      whitequark/rescue_in_lambda_block.txt
      whitequark/rescue_without_begin_end.txt
      whitequark/return.txt
      whitequark/return_block.txt
      whitequark/ruby_bug_10653.txt
      whitequark/ruby_bug_11107.txt
      whitequark/ruby_bug_11380.txt
      whitequark/ruby_bug_11873.txt
      whitequark/ruby_bug_11873_a.txt
      whitequark/ruby_bug_11873_b.txt
      whitequark/ruby_bug_11989.txt
      whitequark/ruby_bug_11990.txt
      whitequark/ruby_bug_12073.txt
      whitequark/ruby_bug_12402.txt
      whitequark/ruby_bug_12686.txt
      whitequark/ruby_bug_13547.txt
      whitequark/ruby_bug_14690.txt
      whitequark/ruby_bug_15789.txt
      whitequark/send_attr_asgn.txt
      whitequark/send_attr_asgn_conditional.txt
      whitequark/send_block_chain_cmd.txt
      whitequark/send_call.txt
      whitequark/send_index.txt
      whitequark/send_index_asgn.txt
      whitequark/send_index_asgn_legacy.txt
      whitequark/send_index_cmd.txt
      whitequark/send_index_legacy.txt
      whitequark/send_lambda.txt
      whitequark/send_lambda_args_noparen.txt
      whitequark/send_lambda_legacy.txt
      whitequark/send_op_asgn_conditional.txt
      whitequark/send_plain.txt
      whitequark/send_plain_cmd.txt
      whitequark/send_self.txt
      whitequark/slash_newline_in_heredocs.txt
      whitequark/space_args_arg.txt
      whitequark/space_args_arg_block.txt
      whitequark/space_args_arg_call.txt
      whitequark/space_args_arg_newline.txt
      whitequark/space_args_block.txt
      whitequark/space_args_cmd.txt
      whitequark/string_concat.txt
      whitequark/super.txt
      whitequark/super_block.txt
      whitequark/ternary.txt
      whitequark/ternary_ambiguous_symbol.txt
      whitequark/trailing_forward_arg.txt
      whitequark/unless_else.txt
      whitequark/when_splat.txt
      whitequark/yield.txt
      xstring.txt
      yield.txt
    ]

    relatives.each do |relative|
      filepath = File.join(__dir__, "fixtures", relative)

      define_method "test_ripper_#{relative}" do
        source = File.read(filepath, binmode: true, external_encoding: Encoding::UTF_8)
        assert_ripper(source, filepath, skips.include?(relative))
      end
    end

    private

    def assert_ripper(source, filepath, allowed_failure)
      expected = Ripper.sexp_raw(source)

      begin
        assert_equal expected, Prism::Translation::Ripper.sexp_raw(source)
      rescue Exception, NoMethodError
        File.open("failing.txt", "a") { |f| f.puts filepath }
        raise unless allowed_failure
      else
        File.open("passing.txt", "a") { |f| f.puts filepath } if allowed_failure
      end
    end
  end
end
