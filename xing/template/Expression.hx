package xing.template;

import xing.exception.template.ParserException;
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
	public function new(value:Dynamic, type:XingTemplateType, ?uprefix:TokenCode = -1, ?upostfix:TokenCode = -1) {
		if(uprefix != -1) {
			if(!UnaryPrefixExpression.supportedOperations.get(type).contains(uprefix))
				throw new ParserException('Can not parse prefix ${uprefix} for type ${type}.');
		}
		this = {
			kind: ELiteral,
			value: value,
			type: type,
		};
	}
}

abstract UnaryPrefixExpression(ExpressionType) to Expression {
	public static final ops : Array<TokenCode> = [TTilde, TExclam, TMinus, TPlusPlus, TMinusMinus];
	public static final supportedOperations : Map<XingTemplateType, Array<TokenCode>> = [
		XBoolean=> [TExclam],
		XInt=> [TTilde, TMinus, TPlusPlus, TMinusMinus],
		XFloat=> [TMinus, TPlusPlus, TMinusMinus],
		XString=> [],
		XArray=> []
	];

	public function new(opr:Token, expression:Expression) {
		this = {
			kind: EPrefixUnary,
			op: opr,
			e: expression
		}
	}
}

abstract UnaryPostExpression(ExpressionType) to Expression {
	public function new(opr:Token, expression:Expression) {
		this = {
			kind: EPostfixUnary,
			op: opr,
			e: expression
		}
	}
}