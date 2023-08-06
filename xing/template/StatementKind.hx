package xing.template;

enum abstract StatementKind(Int) from Int to Int {
	var SExpression;
	var SBlock;
	var SIf;
	var SWhile;
	var SFor;
	var SDoc;
}
