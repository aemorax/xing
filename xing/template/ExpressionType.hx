package xing.template;

typedef ExpressionType = {
	var kind:ExpressionKind;
	var ?op:Token;
	var ?name:Token;
	var ?l:Expression;
	var ?r:Expression;
	var ?e:Expression;
	var ?a:Array<Expression>;
	var ?value:Dynamic;
	var ?type:XingTemplateType;
}

enum abstract XingTemplateType(Int) {
	var XBoolean;
	var XInt;
	var XFloat;
	var XString;
	var XArray;
}