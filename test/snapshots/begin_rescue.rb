ProgramNode(0...578)(
  Scope(0...0)([IDENTIFIER(207...209)("ex")]),
  StatementsNode(0...578)(
    [BeginNode(0...33)(
       KEYWORD_BEGIN(0...5)("begin"),
       StatementsNode(7...8)(
         [CallNode(7...8)(
            nil,
            nil,
            IDENTIFIER(7...8)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(10...0)(
         KEYWORD_RESCUE(10...16)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(18...19)(
           [CallNode(18...19)(
              nil,
              nil,
              IDENTIFIER(18...19)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       ElseNode(21...29)(
         KEYWORD_ELSE(21...25)("else"),
         StatementsNode(27...28)(
           [CallNode(27...28)(
              nil,
              nil,
              IDENTIFIER(27...28)("c"),
              nil,
              nil,
              nil,
              nil,
              "c"
            )]
         ),
         SEMICOLON(28...29)(";")
       ),
       nil,
       KEYWORD_END(30...33)("end")
     ),
     BeginNode(35...79)(
       KEYWORD_BEGIN(35...40)("begin"),
       StatementsNode(42...43)(
         [CallNode(42...43)(
            nil,
            nil,
            IDENTIFIER(42...43)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(45...0)(
         KEYWORD_RESCUE(45...51)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(53...54)(
           [CallNode(53...54)(
              nil,
              nil,
              IDENTIFIER(53...54)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       ElseNode(56...64)(
         KEYWORD_ELSE(56...60)("else"),
         StatementsNode(62...63)(
           [CallNode(62...63)(
              nil,
              nil,
              IDENTIFIER(62...63)("c"),
              nil,
              nil,
              nil,
              nil,
              "c"
            )]
         ),
         SEMICOLON(63...64)(";")
       ),
       EnsureNode(65...79)(
         KEYWORD_ENSURE(65...71)("ensure"),
         StatementsNode(73...74)(
           [CallNode(73...74)(
              nil,
              nil,
              IDENTIFIER(73...74)("d"),
              nil,
              nil,
              nil,
              nil,
              "d"
            )]
         ),
         KEYWORD_END(76...79)("end")
       ),
       KEYWORD_END(76...79)("end")
     ),
     BeginNode(81...92)(
       KEYWORD_BEGIN(81...86)("begin"),
       StatementsNode(87...88)(
         [CallNode(87...88)(
            nil,
            nil,
            IDENTIFIER(87...88)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       nil,
       nil,
       nil,
       KEYWORD_END(89...92)("end")
     ),
     BeginNode(94...107)(
       KEYWORD_BEGIN(94...99)("begin"),
       StatementsNode(101...102)(
         [CallNode(101...102)(
            nil,
            nil,
            IDENTIFIER(101...102)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       nil,
       nil,
       nil,
       KEYWORD_END(104...107)("end")
     ),
     BeginNode(109...121)(
       KEYWORD_BEGIN(109...114)("begin"),
       StatementsNode(115...116)(
         [CallNode(115...116)(
            nil,
            nil,
            IDENTIFIER(115...116)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       nil,
       nil,
       nil,
       KEYWORD_END(118...121)("end")
     ),
     BeginNode(123...135)(
       KEYWORD_BEGIN(123...128)("begin"),
       StatementsNode(129...130)(
         [CallNode(129...130)(
            nil,
            nil,
            IDENTIFIER(129...130)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       nil,
       nil,
       nil,
       KEYWORD_END(132...135)("end")
     ),
     BeginNode(137...175)(
       KEYWORD_BEGIN(137...142)("begin"),
       StatementsNode(143...144)(
         [CallNode(143...144)(
            nil,
            nil,
            IDENTIFIER(143...144)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(145...0)(
         KEYWORD_RESCUE(145...151)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(152...153)(
           [CallNode(152...153)(
              nil,
              nil,
              IDENTIFIER(152...153)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         RescueNode(154...0)(
           KEYWORD_RESCUE(154...160)("rescue"),
           [],
           nil,
           nil,
           StatementsNode(161...162)(
             [CallNode(161...162)(
                nil,
                nil,
                IDENTIFIER(161...162)("c"),
                nil,
                nil,
                nil,
                nil,
                "c"
              )]
           ),
           RescueNode(163...0)(
             KEYWORD_RESCUE(163...169)("rescue"),
             [],
             nil,
             nil,
             StatementsNode(170...171)(
               [CallNode(170...171)(
                  nil,
                  nil,
                  IDENTIFIER(170...171)("d"),
                  nil,
                  nil,
                  nil,
                  nil,
                  "d"
                )]
             ),
             nil
           )
         )
       ),
       nil,
       nil,
       KEYWORD_END(172...175)("end")
     ),
     BeginNode(177...269)(
       KEYWORD_BEGIN(177...182)("begin"),
       StatementsNode(185...186)(
         [CallNode(185...186)(
            nil,
            nil,
            IDENTIFIER(185...186)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(194...203)(
         KEYWORD_RESCUE(187...193)("rescue"),
         [ConstantReadNode(194...203)()],
         EQUAL_GREATER(204...206)("=>"),
         LocalVariableWriteNode(207...209)(
           IDENTIFIER(207...209)("ex"),
           nil,
           nil
         ),
         StatementsNode(212...213)(
           [CallNode(212...213)(
              nil,
              nil,
              IDENTIFIER(212...213)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         RescueNode(221...255)(
           KEYWORD_RESCUE(214...220)("rescue"),
           [ConstantReadNode(221...237)(), ConstantReadNode(239...255)()],
           EQUAL_GREATER(256...258)("=>"),
           LocalVariableWriteNode(259...261)(
             IDENTIFIER(259...261)("ex"),
             nil,
             nil
           ),
           StatementsNode(264...265)(
             [CallNode(264...265)(
                nil,
                nil,
                IDENTIFIER(264...265)("c"),
                nil,
                nil,
                nil,
                nil,
                "c"
              )]
           ),
           nil
         )
       ),
       nil,
       nil,
       KEYWORD_END(266...269)("end")
     ),
     BeginNode(271...322)(
       KEYWORD_BEGIN(271...276)("begin"),
       StatementsNode(279...280)(
         [CallNode(279...280)(
            nil,
            nil,
            IDENTIFIER(279...280)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(288...297)(
         KEYWORD_RESCUE(281...287)("rescue"),
         [ConstantReadNode(288...297)()],
         EQUAL_GREATER(298...300)("=>"),
         LocalVariableWriteNode(301...303)(
           IDENTIFIER(301...303)("ex"),
           nil,
           nil
         ),
         StatementsNode(306...307)(
           [CallNode(306...307)(
              nil,
              nil,
              IDENTIFIER(306...307)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       EnsureNode(308...322)(
         KEYWORD_ENSURE(308...314)("ensure"),
         StatementsNode(317...318)(
           [CallNode(317...318)(
              nil,
              nil,
              IDENTIFIER(317...318)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         KEYWORD_END(319...322)("end")
       ),
       KEYWORD_END(319...322)("end")
     ),
     StringNode(324...330)(
       STRING_BEGIN(324...326)("%!"),
       STRING_CONTENT(326...329)("abc"),
       STRING_END(329...330)("!"),
       "abc"
     ),
     BeginNode(332...352)(
       KEYWORD_BEGIN(332...337)("begin"),
       StatementsNode(338...339)(
         [CallNode(338...339)(
            nil,
            nil,
            IDENTIFIER(338...339)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(340...0)(
         KEYWORD_RESCUE(340...346)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(347...348)(
           [CallNode(347...348)(
              nil,
              nil,
              IDENTIFIER(347...348)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(349...352)("end")
     ),
     BeginNode(354...374)(
       KEYWORD_BEGIN(354...359)("begin"),
       StatementsNode(360...361)(
         [CallNode(360...361)(
            nil,
            nil,
            IDENTIFIER(360...361)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(362...0)(
         KEYWORD_RESCUE(362...368)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(369...370)(
           [CallNode(369...370)(
              nil,
              nil,
              IDENTIFIER(369...370)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(371...374)("end")
     ),
     BeginNode(376...396)(
       KEYWORD_BEGIN(376...381)("begin"),
       StatementsNode(382...383)(
         [CallNode(382...383)(
            nil,
            nil,
            IDENTIFIER(382...383)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(384...0)(
         KEYWORD_RESCUE(384...390)("rescue"),
         [],
         nil,
         nil,
         StatementsNode(391...392)(
           [CallNode(391...392)(
              nil,
              nil,
              IDENTIFIER(391...392)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(393...396)("end")
     ),
     BeginNode(398...428)(
       KEYWORD_BEGIN(398...403)("begin"),
       StatementsNode(404...405)(
         [CallNode(404...405)(
            nil,
            nil,
            IDENTIFIER(404...405)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(413...422)(
         KEYWORD_RESCUE(406...412)("rescue"),
         [ConstantReadNode(413...422)()],
         nil,
         nil,
         StatementsNode(423...424)(
           [CallNode(423...424)(
              nil,
              nil,
              IDENTIFIER(423...424)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(425...428)("end")
     ),
     BeginNode(430...477)(
       KEYWORD_BEGIN(430...435)("begin"),
       StatementsNode(436...437)(
         [CallNode(436...437)(
            nil,
            nil,
            IDENTIFIER(436...437)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(445...471)(
         KEYWORD_RESCUE(438...444)("rescue"),
         [ConstantReadNode(445...454)(), ConstantReadNode(456...471)()],
         nil,
         nil,
         StatementsNode(472...473)(
           [CallNode(472...473)(
              nil,
              nil,
              IDENTIFIER(472...473)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(474...477)("end")
     ),
     BeginNode(479...536)(
       KEYWORD_BEGIN(479...484)("begin"),
       StatementsNode(487...488)(
         [CallNode(487...488)(
            nil,
            nil,
            IDENTIFIER(487...488)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(496...522)(
         KEYWORD_RESCUE(489...495)("rescue"),
         [ConstantReadNode(496...505)(), ConstantReadNode(507...522)()],
         EQUAL_GREATER(523...525)("=>"),
         LocalVariableWriteNode(526...528)(
           IDENTIFIER(526...528)("ex"),
           nil,
           nil
         ),
         StatementsNode(531...532)(
           [CallNode(531...532)(
              nil,
              nil,
              IDENTIFIER(531...532)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(533...536)("end")
     ),
     BeginNode(538...578)(
       KEYWORD_BEGIN(538...543)("begin"),
       StatementsNode(546...547)(
         [CallNode(546...547)(
            nil,
            nil,
            IDENTIFIER(546...547)("a"),
            nil,
            nil,
            nil,
            nil,
            "a"
          )]
       ),
       RescueNode(555...564)(
         KEYWORD_RESCUE(548...554)("rescue"),
         [ConstantReadNode(555...564)()],
         EQUAL_GREATER(565...567)("=>"),
         LocalVariableWriteNode(568...570)(
           IDENTIFIER(568...570)("ex"),
           nil,
           nil
         ),
         StatementsNode(573...574)(
           [CallNode(573...574)(
              nil,
              nil,
              IDENTIFIER(573...574)("b"),
              nil,
              nil,
              nil,
              nil,
              "b"
            )]
         ),
         nil
       ),
       nil,
       nil,
       KEYWORD_END(575...578)("end")
     )]
  )
)
