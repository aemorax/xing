package xing.template;

interface Statement {
	public function toString():String;
}

class ExpressionStatement implements Statement {
	private final expression : Expression;
	public function new(expression:Expression) {
		this.expression = expression;
	}

	public function toString():String {
		return "Expression: " + this.expression.toString();
	}
}

class VariableStatement implements Statement {
	public function new(name:Token, initializer:Expression) {
		
	}

	public function toString():String {
		return "Variable";
	}
}

class BlockStatement implements Statement {
	private final statements:Array<Statement>;
	public function new(statements:Array<Statement>) {
		this.statements = statements;
	}

	public function push(statement:Statement) {
		this.statements.push(statement);
	}

	public function toString():String {
		var s : String = "{\n";
		for(statement in statements) {
			s += "\t" + statement.toString() + "\n";
		}
		s+="}";
		return s;
	}
}

class IfStatement implements Statement {
	public function new(condition:Expression, thenBlock:Statement, elseBlock:Statement) {
		
	}

	public function toString():String {
		return "If";
	}
}

class WhileStatement implements Statement {
	public function new(condition:Expression, body:Statement) {
		
	}

	public function toString():String {
		return "While";
	}
}

class ForStatement implements Statement {
	public function new(condition:Expression, body:Statement) {
		
	}

	public function toString():String {
		return "For";
	}
}

class DocStatement implements Statement {
	public final token:Token;

	public function new(token:Token) {
		this.token = token;
	}

	public function toString():String {
		return "Doc: " + token.literal;
	}
}