package xing.template;

typedef ExpressionType = {
	var kind:ExpressionKind;
	var ?op:Token;
	var ?name:Token;
	var ?l:Expression;
	var ?r:Expression;
	var ?e:Expression;
	var ?a:Array<Expression>;
}