#include <Array.au3>


Global $aUserProgram = [ "INC A", "INC A", "INC B", "INC B", "INC B", "ADD A, B" ]

init()
progloader()
exec()
disasm()

;;Initialise
Func init()
   Global $iMemorySize = 16
   Global $aMemory[ $iMemorySize ]
   For $PC = 0 to UBound( $aMemory ) - 1
	  $aMemory[ $PC ] = 0
   Next
   Global $aMemDisAsm[ $iMemorySize ]
   Global $iRegAcc = 0
   Global $iRegB = 0
   Global $aStack = [ 00, 00, 00, 00, 00, 00, 00, 00 ]
EndFunc

;;Program Loader
Func progloader()
   asm( $aUserProgram )
   For $PC = 0 to UBound( $aMemAsm ) - 1
	  $aMemory[ $PC ] = $aMemAsm[ $PC ]
   Next
EndFunc

;;Assembler
Func asm( $aProgram )
   Global $aMemAsm[ $iMemorySize ]
   For $PC = 0 to UBound( $aProgram ) - 1
	  $PCOp = $aProgram[ $PC ]
	  Switch $PCOp
	  Case "NOP"
		 $aMemAsm[ $PC ] = 0
	  Case "INC A"
		 $aMemAsm[ $PC ] = 1
	  Case "INC B"
		 $aMemAsm[ $PC ] = 2
	  Case "PUSH A"
		 $aMemAsm[ $PC ] = 3
	  Case "PUSH B"
		 $aMemAsm[ $PC ] = 4
	  Case "POP A"
		 $aMemAsm[ $PC ] = 5
	  Case "POP B"
		 $aMemAsm[ $PC ] = 6
	  Case "DEC A"
		 $aMemAsm[ $PC ] = 7
	  Case "DEC B"
		 $aMemAsm[ $PC ] = 8
	  Case "MOV A, B"
		 $aMemAsm[ $PC ] = 9
	  Case "MOV B, A"
		 $aMemAsm[ $PC ] = 10
	  Case "ADD A, B"
		 $aMemAsm[ $PC ] = 11
	  EndSwitch
   Next
EndFunc

;;Actual opcode execution
Func exec()
   For $PC = 0 to 15
	  $PCop = $aMemory[ $PC ]
	  Switch $PCOp
	  Case 0
		 nop()
	  Case 1
		 inc_a()
	  Case 2
		 inc_b()
	  Case 3
		 push_a()
	  Case 4
		 push_b()
	  Case 5
		 pop_a()
	  Case 6
		 pop_b()
	  Case 7
		 dec_a()
	  Case 8
		 dec_b()
	  Case 9
		 mov_ab()
	  Case 10
		 mov_ba()
	  Case 11
		 add_ab()
	  EndSwitch
   Next
   MsgBox( 0, "Machine State", "Mem: " & _ArrayToString( $aMemory ) & @CRLF & "Acc:" & $iRegAcc & @CRLF & "B:" & $iRegB & @CRLF & "Stk:" & _ArrayToString( $aStack ) )
EndFunc

;;Disassembler
Func disasm()
   For $PC = 0 to UBound( $aMemory ) - 1
	  $PCOp = $aMemory[ $PC ]
	  Switch $PCOp
	  Case 0
		 $aMemDisAsm[ $PC ] = "NOP"
	  Case 1
		 $aMemDisAsm[ $PC ] = "INC A"
	  Case 2
		 $aMemDisAsm[ $PC ] = "INC B"
	  Case 3
		 $aMemDisAsm[ $PC ] = "PUSH A"
	  Case 4
		 $aMemDisAsm[ $PC ] = "PUSH B"
	  Case 5
		 $aMemDisAsm[ $PC ] = "POP A"
	  Case 6
		 $aMemDisAsm[ $PC ] = "POP B"
	  Case 7
		 $aMemDisAsm[ $PC ] = "DEC A"
	  Case 8
		 $aMemDisAsm[ $PC ] = "DEC B"
	  Case 9
		 $aMemDisAsm[ $PC ] = "MOV A, B"
	  Case 10
		 $aMemDisAsm[ $PC ] = "MOV B, A"
	  Case 11
		 $aMemDisAsm[ $PC ] = "ADD A, B"
	  EndSwitch
   Next
   MsgBox( 0, "Memory Disassembler", _ArrayToString( $aMemory, @CRLF ) & @CRLF & @CRLF & _ArrayToString( $aMemDisAsm, @CRLF ) )
EndFunc

;;Opcodes
Func nop()
   Return Null
EndFunc

Func inc_a()
   $iRegAcc = $iRegAcc + 1
   Return $iRegAcc
EndFunc

Func inc_b()
   $iRegB = $iRegB + 1
   Return $iRegB
EndFunc

Func push_a( )
   _ArrayPush( $aStack, $iRegAcc, 1 )
   Return $iRegAcc
EndFunc

Func push_b( )
   _ArrayPush( $aStack, $iRegB, 1 )
   Return $iRegB
EndFunc

Func pop_a()
   $iRegAcc = $aStack[0]
   _ArrayDelete( $aStack, 0 )
   _ArrayAdd( $aStack, 00 )
   Return $iRegAcc
EndFunc

Func pop_b()
   $iRegB = $aStack[0]
   _ArrayDelete( $aStack, 0 )
   _ArrayAdd( $aStack, 00 )
   Return $iRegB
EndFunc

Func dec_a()
   $iRegAcc = $iRegAcc - 1
   If $iRegAcc <= 0 Then
	  $iRegAcc = 0
   EndIf
   Return $iRegAcc
EndFunc

Func dec_b()
   $iRegB = $iRegB - 1
   If $iRegB <= 0 Then
	  $iRegB = 0
   EndIf
   Return $iRegB
EndFunc

Func mov_ab()
   $iRegAcc = $iRegB
   $iRegB = 0
   Return $iRegAcc
EndFunc

Func mov_ba()
   $iRegB = $iRegAcc
   $iRegAcc = 0
   Return $iRegB
EndFunc

Func add_ab()
   $iRegAcc = $iRegAcc + $iRegB
   Return $iRegAcc
EndFunc