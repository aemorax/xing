package xing.template;

import xing.exception.template.ParserException;
import xing.template.ExpressionType;
import xing.template.ExpressionType.XingTemplateType;

abstract Expression(ExpressionType) from ExpressionType to ExpressionType {
	public function new(exp:ExpressionType) {
		this = exp;
	}

	public var kind(get, never):ExpressionKind;
	public var name(get, never):Null<Token>;

	function get_kind():ExpressionKind {
		return this.kind;
	}

	function get_name():Null<Token> {
		return this.name;
	}

	public function toString():String {
		return Std.string(this);
	}
}

abstract LiteralExpression(ExpressionType) to Expression {
	public function new(value:Dynamic, type:XingTemplateType, ?uprefix:TokenCode = -1, ?upostfix:TokenCode = -1) {
		if (uprefix != -1) {
			if (!UnaryPrefixExpression.supportedOperations.get(type).contains(uprefix))
				throw new ParserException('Can not parse prefix ${uprefix} for type ${type}.');
		}
		this = {
			kind: ELiteral,
			value: value,
			type: type,
		};
	}
}

abstract VariableExpression(ExpressionType) to Expression {
	public function new(name:Token) {
		this = {
			kind: EVariable,
			name: name,
		}
	}
}

abstract UnaryPrefixExpression(ExpressionType) to Expression {
	public static final ops:Array<TokenCode> = [TTilde, TExclam, TMinus, TPlusPlus, TMinusMinus];
	public static final supportedOperations:Map<XingTemplateType, Array<TokenCode>> = [
		XBoolean => [TExclam],
		XInt => [TTilde, TMinus, TPlusPlus, TMinusMinus],
		XFloat => [TMinus, TPlusPlus, TMinusMinus],
		XString => [],
		XArray => []
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

abstract BinaryExpression(ExpressionType) to Expression {
	public static final moduloOps:Array<TokenCode> = [TPrcent];
	public static final factorOps:Array<TokenCode> = [TAsterisk, TSlash];
	public static final termOps:Array<TokenCode> = [TPlus, TMinus];
	public static final shiftOps:Array<TokenCode> = [TALBrakBrak, TARBrakBrak];
	public static final bitwiseOps:Array<TokenCode> = [TAmp, TPipe, TCaret];
	public static final compareOps:Array<TokenCode> = [TDEqual, TNEqual, TALBrak, TARBrak, TALBrakEqual, TARBrakEqual];
	public static final logicalAndOp:Array<TokenCode> = [TDAmp];
	public static final logicalOrOp:Array<TokenCode> = [TDPipe];

	public function new(left:Expression, opr:Token, right:Expression) {
		this = {
			kind: EBinary,
			l: left,
			op: opr,
			r: right
		}
	}
}

abstract AssignmentExpression(ExpressionType) to Expression {
	public static final assignmentOps:Array<TokenCode> = [
		TEqual, TColonEqual,
		TPlusEqual, TMinusEqual, TAsteriskEqual, TSlashEqual, TPrcentEqual,
	];

	public function new(name:Token, value:Expression, op:TokenCode) {
		this = {
			kind: switch (op) {
				case TEqual: EAssignment;
				case TColonEqual: EPassAssignment;
				case TPlusEqual, TMinusEqual, TAsteriskEqual, TSlashEqual, TPrcentEqual: ECompAssignment;
				default: throw new ParserException("Invalid assignment operator.");
			},
			name: name,
			value: value,
		}
	}
}
