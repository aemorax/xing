package xing.template;

import xing.template.Statement.ExpressionStatement;
import xing.exception.template.ParserException;
import xing.template.Statement.IfStatement;
import xing.template.Statement.BlockStatement;

class Parser {
	private final tokens:Array<Token>;
	private var current:Int = 0;


	public function new(tokens:Array<Token>) {
		this.tokens = tokens;	
	}

	public inline function parse():Statement {
		var root : BlockStatement = new BlockStatement([]);

		while(!eof()) {
			root.push(statement());
		}

		return root;
	}

	private function statement():Statement {
		if(match(Tif)) {
			return ifStatement();
		}
		if(match(Twhile)) {

		}
		if(match(TLBrac)) {
			advance();
			return block();
		}

		return expressionStatement();
	}

	private inline function block():BlockStatement {
		var statements:Array<Statement> = new Array<Statement>();
		var statementTop = 0;

		while(!match(TRBrac) && !eof()) {
			statements[statementTop++] = statement();
		}
		consume(TRBrac, "Expected '}' after a block.");

		return new BlockStatement(statements);
	}

	private inline function expressionStatement():Statement {
		var value = expression();
		consume(TSemiColon, "Expected ';' after expression");
		return new ExpressionStatement(value);
	}

	private inline function ifStatement() : IfStatement {
		consume(TLPran, "Expected '(' after if.");
		var condition = expression();
		consume(TRPran, "Expected ')' after if.");
		
		var thenBranch:Statement = statement();
		var elseBranch:Statement = null;
		if(match(Telif)) {
			advance();
			elseBranch = ifStatement();
		}
		else if(match(Telse)) {
			advance();
			elseBranch = statement();
		}

		return new IfStatement(condition, thenBranch, elseBranch);
	}

	private inline function expression():Expression {
		return null;
	}

	private inline function consume(code:TokenCode, exception:String) {
		if(match(code)) {
			advance();
			return peek(-1);
		}
		else 
			throw new ParserException(exception);
	}

	private inline function advance():Token {
		if(!eof())
			current++;
		return peek(-1);
	}

	private inline function match(expect:TokenCode) {
		return peek().code == expect;
	}
	
	private inline function matchOneOf(expect:Array<TokenCode>) {
		return expect.contains(peek().code);
	}


	private inline function peek(?next:Int=0):Token {
		return tokens[current+next];
	}

	private inline function eof():Bool {
		return peek().code == TEOF;
	}
}