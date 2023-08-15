package xing.template;

import xing.exception.template.ParserException;
import xing.template.ExpressionType;

abstract Expression(ExpressionType) from ExpressionType to ExpressionType {
	public function new(exp:ExpressionType) {
		this = exp;
	}

	public var kind(get, never):ExpressionKind;
	public var name(get, never):Null<Token>;
	public var expr(get, never):Null<Expression>;
	public var oper(get, never):Null<Token>;
	public var type(get, never):Null<XingTemplateType>;
	public var value(get, never):Dynamic;

	private var evalue(never, set):Dynamic;

	function get_kind():ExpressionKind {
		return this.kind;
	}

	function get_name():Null<Token> {
		return this.name;
	}

	function get_expr():Null<Expression> {
		return this.e;
	}

	function get_oper():Null<Token> {
		return this.op;
	}

	function get_type():Null<XingTemplateType> {
		return this.type;
	}

	function get_value():Dynamic {
		return this.value;
	}

	function set_evalue(val:Dynamic):Dynamic {
		return this.value = val;
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
	public var value(get, never):Dynamic;

	function get_value():Dynamic {
		return this.value;
	}

	public function new(value:Dynamic, type:XingTemplateType) {
		this = {
			kind: ELiteral,
			value: value,
			type: type,
		};
	}
}

abstract VariableExpression(ExpressionType) to Expression {
	public var name(get, never):Token;

	function get_name():Token {
		return this.name;
	}

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

	public var oper(get, never):Token;
	public var left(get, never):Expression;
	public var right(get, never):Expression;

	function get_oper():Token {
		return this.op;
	}

	function get_left():Expression {
		return this.l;
	}

	function get_right():Expression {
		return this.r;
	}

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
	public var inside(get, never):Null<Expression>;

	function get_inside():Null<Expression> {
		return this.e;
	}

	public function new(expression:Expression) {
		this = {
			kind: EGroup,
			e: expression,
		}
	}
}

abstract AssignmentExpression(ExpressionType) to Expression {
	public var name(get, never):Null<Token>;
	public var expr(get, never):Null<Expression>;
	public var oper(get, never):Null<Token>;

	function get_name():Null<Token> {
		return this.name;
	}

	function get_expr():Null<Expression> {
		return this.e;
	}

	function get_oper():Null<Token> {
		return this.op;
	}

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
	public var init(get, never):Null<Expression>;
	public var cond(get, never):Null<Expression>;
	public var step(get, never):Null<Expression>;

	function get_init():Null<Expression> {
		return this.l;
	}

	function get_cond():Null<Expression> {
		return this.e;
	}

	function get_step():Null<Expression> {
		return this.r;
	}

	public function new(init:Expression, condition:Expression, step:Expression) {
		this = {
			kind: EForCondition,
			l: init,
			e: condition,
			r: step
		}
	}
}
