package xing.template;

enum abstract ExpressionKind(Int) from Int to Int {
	var EDummy;
	var EUnary;
	var EBinary;
	var EGroup;
	var ELiteral;
	var EVariable;
	var EAssignment;
	var EPassAssignment;
	var EArray;
}