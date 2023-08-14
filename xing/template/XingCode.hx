package xing.template;

enum abstract Speical(Int) from Int to Int {
	var Next = -1;
	var Accum = -2;
}

enum Address {
	Absolute(addr:Int);
	Relative(addr:Int);
}

enum XingOpCode {
	NOP;
	ORA;
	XOR;
	AND;
	SHL;
	SHR;
	JMP;
	JEQ;
	JNQ;
	ADD;
	SUB;
	MUL;
	DIV;
	MOD;
	JLT;
	MOV;
	DOC;

	CEQ; // check equality
	CNQ;
	CLT;
	CGT;
	CLTE;
	CGTE;

	LGA; // logical and
	LGO; // logical or

	LDA; // load to accumulator
}

typedef OpcodeArg = {
	var ?Literal : Dynamic;
	var ?Special : Speical;
	var ?Address : Address;
	var ?Variable : String;
}

typedef XingCode = {
	var opcode : XingOpCode;
	var ?arg1 : OpcodeArg;
	var ?arg2 : OpcodeArg;
	var ?arg3 : OpcodeArg;
}