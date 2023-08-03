package xing.template;

interface Statement {
	
}

class ExpressionStatement implements Statement {
	public function new(expression:Expression) {
		
	}
}

class VariableStatement implements Statement {
	public function new(name:Token, initializer:Expression) {
		
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
}

class IfStatement implements Statement {
	public function new(condition:Expression, thenBlock:Statement, elseBlock:Statement) {
		
	}
}

class WhileStatement implements Statement {
	public function new(condition:Expression, body:Statement) {
		
	}
}

class ForStatement implements Statement {
	public function new(condition:Expression, body:Statement) {
		
	}
}

class DocStatement implements Statement {
	public function new(token:Token) {
		
	}
}