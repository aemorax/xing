package xing.template;

import xing.exception.template.ParserException;
import xing.template.ExpressionType.XingTemplateType;
import xing.template.ExpressionType;

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
		switch (this.kind) {
			case EGroup:
				return '(group (${this.e}))';
			case EAssignment:
				return '(${this.name} = (${this.e}))';
			case EPassAssignment:
				return '(${this.name} := (${this.e}))';
			case ECompAssignment:
				return '(${this.name} (comp:${this.op.code})= (${this.e}))';
			case EPrefixUnary:
				return '(unary:${this.op} ${this.e})';
			case EPostfixUnary:
				return '(${this.e} unary:${this.op})';
			case EVariable:
				return '(var ${this.name})';
			case EBinary:
				return '(binary (${this.l} (binop:${this.op.code}) ${this.r}))';
			case ELiteral:
				return '(${this.kind}:literal:${this.type} (${this.value}))';
			case EIterator:
				return '(${this.name} in ${this.e})';
			case EForCondition:
				return '(${this.l};${this.e};${this.r})';
			default:
				return Std.string(this);
		}
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
	public static final ops:Array<TokenCode> = [TPlusPlus, TMinusMinus];
	public static final supportedOperations:Map<XingTemplateType, Array<TokenCode>> = [
		XBoolean => [],
		XInt => [TPlusPlus, TMinusMinus],
		XFloat => [TPlusPlus, TMinusMinus],
		XString => [],
		XArray => []
	];

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
	public static final intervalOps:Array<TokenCode> = [TInterval];
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

abstract GroupExpression(ExpressionType) to Expression {
	public function new(expression:Expression) {
		this = {
			kind: EGroup,
			e: expression,
		}
	}
}

abstract AssignmentExpression(ExpressionType) to Expression {
	public static final assignmentOps:Array<TokenCode> = [
		TEqual,
		TColonEqual,
		TPlusEqual,
		TMinusEqual,
		TAsteriskEqual,
		TSlashEqual,
		TPrcentEqual,
		TAmpEqual,
		TPipeEqual
	];

	public function new(name:Token, value:Expression, op:Token) {
		this = {
			kind: switch (op.code) {
				case TEqual: EAssignment;
				case TColonEqual: EPassAssignment;
				case TPlusEqual, TMinusEqual, TAsteriskEqual, TSlashEqual, TPrcentEqual, TAmpEqual, TPipeEqual: ECompAssignment;
				default: throw new ParserException("Invalid assignment operator.");
			},
			name: name,
			e: value,
			op: op,
		}
	}
}

abstract IteratorExpression(ExpressionType) to Expression {
	public function new(name:Token, expression:Expression) {
		this = {
			kind: EIterator,
			name: name,
			e: expression,
		}
	}
}

abstract ForConditionExpression(ExpressionType) to Expression {
	public function new(init:Expression, condition:Expression, step:Expression) {
		this = {
			kind: EForCondition,
			l: init,
			e: condition,
			r: step
		}
	}
}
