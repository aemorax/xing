package xing.template;

import xing.template.ExpressionType;
import xing.template.ExpressionType.XingTemplateType;

abstract Expression(ExpressionType) from ExpressionType to ExpressionType {
	public function new(exp:ExpressionType) {
		this = exp;
	}

	public function toString():String {
		return Std.string(this);
	}
}

abstract LiteralExpression(ExpressionType) to Expression {
	public function new(value:Dynamic, type:XingTemplateType) {
		this = {
			kind: ELiteral,
			value: value,
			type: type,
		};
	}
}