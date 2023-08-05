package xing.template;

interface Statement {
	public var kind(get, never):StatementKind;
	public function toString():String;
}

class ExpressionStatement implements Statement {
	public final expression:Expression;
	public var kind(get, never):StatementKind;

	public function new(expression:Expression) {
		this.expression = expression;
	}

	public function toString():String {
		return "expression: " + this.expression.toString();
	}

	function get_kind():StatementKind {
		return SExpression;
	}
}

class BlockStatement implements Statement {
	public final statements:Array<Statement>;
	public var kind(get, never):StatementKind;

	public function new(statements:Array<Statement>) {
		this.statements = statements;
	}

	public function push(statement:Statement) {
		this.statements.push(statement);
	}

	public function toString():String {
		var s:String = "{\n";
		for (statement in statements) {
			s += "\t" + statement.toString() + "\n";
		}
		s += "}";
		return s;
	}

	function get_kind():StatementKind {
		return SBlock;
	}
}

class IfStatement implements Statement {
	public final condition:Expression;
	public final thenBlock:Statement;
	public final elseBlock:Statement;
	public var kind(get, never):StatementKind;

	public function new(condition:Expression, thenBlock:Statement, elseBlock:Statement) {
		this.condition = condition;
		this.thenBlock = thenBlock;
		this.elseBlock = elseBlock;
	}

	public function toString():String {
		return 'if cond: ${condition} then: ${thenBlock} else: ${elseBlock}';
	}

	function get_kind():StatementKind {
		return SIf;
	}
}

class WhileStatement implements Statement {
	public final condition:Expression;
	public final body:Statement;
	public var kind(get, never):StatementKind;

	public function new(condition:Expression, body:Statement) {
		this.condition = condition;
		this.body = body;
	}

	public function toString():String {
		return 'while: cond: ${condition} body: ${body}';
	}

	function get_kind():StatementKind {
		return SWhile;
	}
}

class ForStatement implements Statement {
	public final condition:Expression;
	public final body:Statement;
	public var kind(get, never):StatementKind;

	public function new(condition:Expression, body:Statement) {
		this.condition = condition;
		this.body = body;
	}

	public function toString():String {
		return 'for: cond: ${condition} body: ${body}';
	}

	function get_kind():StatementKind {
		return SFor;
	}
}

class DocStatement implements Statement {
	public final token:Token;
	public var kind(get, never):StatementKind;

	public function new(token:Token) {
		this.token = token;
	}

	public function toString():String {
		return "doc: " + token.literal;
	}

	function get_kind():StatementKind {
		return SDoc;
	}
}
