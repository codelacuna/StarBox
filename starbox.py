import ctypes

aUserProgram = [ "INC A", "INC A", "INC B", "INC B", "INC B", "ADD A, B" ]
iMemorySize = 16
aMemDisAsm = [ 0 ] * iMemorySize
iRegAcc = 0
iRegB = 0
aStack = [ 0 ] * int( ( iMemorySize / 4 ) )
aMemAsm = [ 0 ] * iMemorySize
aMemory = [ 0 ] * iMemorySize

#Program Loader
def progloader():
	global aMemory
	asm( aUserProgram )
	aMemory = aMemAsm

#Assembler
def asm( aProgram ):
	i = -1
	for PC in aProgram:
		i += 1
		if PC == "NOP":
			aMemAsm[ i ] = 0
		if PC == "INC A":
			aMemAsm[ i ] = 1
		if PC == "INC B":
			aMemAsm[ i ] = 2
		if PC == "PUSH A":
			aMemAsm[ i ] = 3
		if PC == "PUSH B":
			aMemAsm[ i ] = 4
		if PC == "POP A":
			aMemAsm[ i ] = 5
		if PC == "POP B":
			aMemAsm[ i ] = 6
		if PC == "DEC A":
			aMemAsm[ i ] = 7
		if PC == "DEC B":
			aMemAsm[ i ] = 8
		if PC == "MOV A, B":
			aMemAsm[ i ] = 9
		if PC == "MOV B, A":
			aMemAsm[ i ] = 10
		if PC == "ADD A, B":
			aMemAsm[ i ] = 11

#Actual opcode execution
def execute():
	for PC in aMemory:
		if PC == 0:
			nop()
		if PC == 1:
			inc_a()
		if PC == 2:
			inc_b()
		if PC == 3:
			push_a()
		if PC == 4:
			push_b()
		if PC == 5:
			pop_a()
		if PC == 6:
			pop_b()
		if PC == 7:
			dec_a()
		if PC == 8:
			dec_b()
		if PC == 9:
			mov_ab()
		if PC == 10:
			mov_ba()
		if PC == 11:
			add_ab()
	print( "Mem: " + str( aMemory ) + "\r\nAcc:" + str( iRegAcc ) + "\r\nB:" + str( iRegB ) + "\r\nStk:" + str( aStack ) )

#Disassembler
def disasm():
	global aMemDisAsm
	i = -1
	for PC in aMemory:
		i += 1
		PCOp = aMemory[ i ]
		if PCOp == 0:
			aMemDisAsm[ i ] = "NOP"
		if PCOp == 1:
			aMemDisAsm[ i ] = "INC A"
		if PCOp == 2:
			aMemDisAsm[ i ] = "INC B"
		if PCOp == 3:
			aMemDisAsm[ i ] = "PUSH A"
		if PCOp == 4:
			aMemDisAsm[ i ] = "PUSH B"
		if PCOp == 5:
			aMemDisAsm[ i ] = "POP A"
		if PCOp == 6:
			aMemDisAsm[ i ] = "POP B"
		if PCOp == 7:
			aMemDisAsm[ i ] = "DEC A"
		if PCOp == 8:
			aMemDisAsm[ i ] = "DEC B"
		if PCOp == 9:
			aMemDisAsm[ i ] = "MOV A, B"
		if PCOp == 10:
			aMemDisAsm[ i ] = "MOV B, A"
		if PCOp == 11:
			aMemDisAsm[ i ] = "ADD A, B"
	#print( "Mem: " + str( aMemory ) + "\r\nMemDisAsm: " + str( aMemDisAsm ) )

def mbox( title, text, style ):
    return ctypes.windll.user32.MessageBoxW(0, text, title, style)

#Opcodes
def nop( ):
	pass

def inc_a( ):
	global iRegAcc
	iRegAcc += 1
	return iRegAcc

def inc_b( ):
	global iRegB
	iRegB += 1
	return iRegB

def push_a( ):
	aStack.insert( 0, iRegAcc )
	return iRegAcc

def push_b( ):
	aStack.insert( 0, iRegB )
	return iRegB

def pop_a( ):
	global iRegAcc
	iRegAcc = aStack[0]
	aStack.pop( 0 )
	aStack.append( 00 )
	return iRegAcc

def pop_b( ):
	global iRegB
	iRegB = aStack[0]
	aStack.pop( 0 )
	aStack.append( 00 )
	return iRegB

def dec_a( ):
	global iRegAcc
	iRegAcc -= 1
	if iRegAcc <= 0:
		iRegAcc = 0
	return iRegAcc

def dec_b( ):
	global iRegB
	iRegB -= 1
	if iRegB <= 0:
		iRegB = 0
	return iRegB

def mov_ab( ):
	global iRegAcc
	global iRegB
	iRegAcc = iRegB
	iRegB = 0
	return iRegAcc

def mov_ba( ):
	global iRegAcc
	global iRegB
	iRegB = iRegAcc
	iRegAcc = 0
	return iRegB

def add_ab( ):
	global iRegAcc
	iRegAcc += iRegB
	return iRegAcc

#main
progloader()
execute()
disasm()