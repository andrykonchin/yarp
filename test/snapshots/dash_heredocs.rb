ProgramNode(7...219)(
  Scope(0...0)([]),
  StatementsNode(7...219)(
    [HeredocNode(7...11)(
       HEREDOC_START(0...6)("<<-EOF"),
       [StringNode(7...11)(
          nil,
          STRING_CONTENT(7...11)("  a\n"),
          nil,
          "  a\n"
        )],
       HEREDOC_END(11...15)("EOF\n"),
       0
     ),
     CallNode(37...51)(
       HeredocNode(37...41)(
         HEREDOC_START(16...24)("<<-FIRST"),
         [StringNode(37...41)(
            nil,
            STRING_CONTENT(37...41)("  a\n"),
            nil,
            "  a\n"
          )],
         HEREDOC_END(41...47)("FIRST\n"),
         0
       ),
       nil,
       PLUS(25...26)("+"),
       nil,
       ArgumentsNode(47...51)(
         [HeredocNode(47...51)(
            HEREDOC_START(27...36)("<<-SECOND"),
            [StringNode(47...51)(
               nil,
               STRING_CONTENT(47...51)("  b\n"),
               nil,
               "  b\n"
             )],
            HEREDOC_END(51...58)("SECOND\n"),
            0
          )]
       ),
       nil,
       nil,
       "+"
     ),
     InterpolatedXStringNode(68...77)(
       HEREDOC_START(59...67)("<<-`EOF`"),
       [StringNode(68...72)(
          nil,
          STRING_CONTENT(68...72)("  a\n"),
          nil,
          "  a\n"
        ),
        StringInterpolatedNode(72...76)(
          EMBEXPR_BEGIN(72...74)("\#{"),
          StatementsNode(74...75)(
            [CallNode(74...75)(
               nil,
               nil,
               IDENTIFIER(74...75)("b"),
               nil,
               nil,
               nil,
               nil,
               "b"
             )]
          ),
          EMBEXPR_END(75...76)("}")
        ),
        StringNode(76...77)(nil, STRING_CONTENT(76...77)("\n"), nil, "\n")],
       HEREDOC_END(77...81)("EOF\n")
     ),
     HeredocNode(98...102)(
       HEREDOC_START(82...88)("<<-EOF"),
       [StringNode(98...102)(
          nil,
          STRING_CONTENT(98...102)("  a\n"),
          nil,
          "  a\n"
        )],
       HEREDOC_END(102...106)("EOF\n"),
       0
     ),
     HeredocNode(114...122)(
       HEREDOC_START(107...113)("<<-EOF"),
       [StringNode(114...122)(
          nil,
          STRING_CONTENT(114...122)("  a\n" + "  b\n"),
          nil,
          "  a\n" + "  b\n"
        )],
       HEREDOC_END(122...128)("  EOF\n"),
       0
     ),
     HeredocNode(138...147)(
       HEREDOC_START(129...137)("<<-\"EOF\""),
       [StringNode(138...142)(
          nil,
          STRING_CONTENT(138...142)("  a\n"),
          nil,
          "  a\n"
        ),
        StringInterpolatedNode(142...146)(
          EMBEXPR_BEGIN(142...144)("\#{"),
          StatementsNode(144...145)(
            [CallNode(144...145)(
               nil,
               nil,
               IDENTIFIER(144...145)("b"),
               nil,
               nil,
               nil,
               nil,
               "b"
             )]
          ),
          EMBEXPR_END(145...146)("}")
        ),
        StringNode(146...147)(
          nil,
          STRING_CONTENT(146...147)("\n"),
          nil,
          "\n"
        )],
       HEREDOC_END(147...151)("EOF\n"),
       0
     ),
     HeredocNode(159...168)(
       HEREDOC_START(152...158)("<<-EOF"),
       [StringNode(159...163)(
          nil,
          STRING_CONTENT(159...163)("  a\n"),
          nil,
          "  a\n"
        ),
        StringInterpolatedNode(163...167)(
          EMBEXPR_BEGIN(163...165)("\#{"),
          StatementsNode(165...166)(
            [CallNode(165...166)(
               nil,
               nil,
               IDENTIFIER(165...166)("b"),
               nil,
               nil,
               nil,
               nil,
               "b"
             )]
          ),
          EMBEXPR_END(166...167)("}")
        ),
        StringNode(167...168)(
          nil,
          STRING_CONTENT(167...168)("\n"),
          nil,
          "\n"
        )],
       HEREDOC_END(168...172)("EOF\n"),
       0
     ),
     StringNode(173...179)(
       STRING_BEGIN(173...175)("%#"),
       STRING_CONTENT(175...178)("abc"),
       STRING_END(178...179)("#"),
       "abc"
     ),
     HeredocNode(188...196)(
       HEREDOC_START(181...187)("<<-EOF"),
       [StringNode(188...196)(
          nil,
          STRING_CONTENT(188...196)("  a\n" + "  b\n"),
          nil,
          "  a\n" + "  b\n"
        )],
       HEREDOC_END(196...200)("EOF\n"),
       0
     ),
     HeredocNode(210...219)(
       HEREDOC_START(201...209)("<<-'EOF'"),
       [StringNode(210...219)(
          nil,
          STRING_CONTENT(210...219)("  a \#{1}\n"),
          nil,
          "  a \#{1}\n"
        )],
       HEREDOC_END(219...223)("EOF\n"),
       0
     )]
  )
)
