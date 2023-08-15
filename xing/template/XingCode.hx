package xing.template;

enum abstract Speical(Int) from Int to Int {
	var Accum = 1;
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
	ADD;
	SUB;
	MUL;
	DIV;
	MOD;
	LGA; // logical and
	LGO; // logical or
	JMP;
	JEQ;
	JNQ;
	CEQ; // check equality
	CNQ;
	CLT;
	CGT;
	CLTE;
	CGTE;
	LDA; // load to accumulator
	MOV;
	EVL; // Evaluate everything inside accumulator.
	DOC;
	EOF;
}

typedef OpcodeArg = {
	var kind:OpcodeArgKind;
	var ?Literal:Dynamic;
	var ?Special:Speical;
	var ?Address:Address;
	var ?Variable:String;
}

enum OpcodeArgKind {
	Literal;
	Special;
	Address;
	Variable;
}

typedef XingCode = {
	var opcode:XingOpCode;
	var ?arg1:OpcodeArg;
	var ?arg2:OpcodeArg;
	var ?arg3:OpcodeArg;
}
