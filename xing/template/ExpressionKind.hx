package xing.template;

enum abstract ExpressionKind(Int) from Int to Int {
	var EPrefixUnary;
	var EPostfixUnary;
	var EBinary;
	var EGroup;
	var ELiteral;
	var EVariable;
	var EAssignment;
	var EPassAssignment;
	var ECompAssignment;
	var EIterator;
	var EForCondition;
}
