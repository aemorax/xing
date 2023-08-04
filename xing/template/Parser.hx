package xing.template;

import xing.template.Expression.LiteralExpression;
import xing.template.Statement.DocStatement;
import xing.template.Statement.ForStatement;
import xing.template.Statement.WhileStatement;
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
			advance();
			return ifStatement();
		}
		if(match(Twhile)) {
			advance();
			return whileStatement();
		}
		if(match(Tfor)) {
			advance();
			return forStatement();
		}
		if(match(TDoc)) {
			return docStatement();
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

	private function ifStatement() : IfStatement {
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

	private inline function whileStatement() : WhileStatement {
		consume(TLPran, "Expected '(' after while.");
		var condition = expression();
		consume(TRPran, "Expected ')' after while condition.");

		var body : Statement = statement();
		return new WhileStatement(condition, body);
	}

	private inline function forStatement():ForStatement {
		consume(TLPran, "Expected '(' after for.");
		var condition = forExpression();
		consume(TRPran, "Expected ')' after for condition.");

		var body : Statement = statement();
		return new ForStatement(condition, body);
	}

	private inline function docStatement():DocStatement {
		advance();
		return new DocStatement(peek(-1));
	}

	private inline function expression():Expression {
		return prefix_unary_expression();
	}

	private inline function forExpression():Expression {
		return null;
	}

	private inline function assignment():Expression {
		return null;	
	}

	private inline function prefix_unary_expression():Expression {
		return primary();
	}

	private inline function primary():Expression {
		if(match(Tfalse)) {
			advance();
			return new LiteralExpression(false, XBoolean);
		}
		if(match(Ttrue)) {
			advance();
			return new LiteralExpression(true, XBoolean);
		}
		if(match(TString)) {
			advance();
			return new LiteralExpression(peek(-1).literal, XString);
		}
		if(match(TInt)) {
			advance();
			return new LiteralExpression(Std.parseInt(peek(-1).literal), XInt);
		}
		if(match(TFloat)) {
			advance();
			return new LiteralExpression(Std.parseFloat(peek(-1).literal), XFloat);
		}
		if(match(TLBrak)) {
			advance();
			return primary_array();
		}

		throw new ParserException("Unknown value as primary.");
	}

	private inline function primary_array():Expression {
		var array:Array<Expression> = [];

		if (!match(TRBrak)) {
			do {
				if(peek().code == TComma)
					advance();

				array.push(expression());
			} while (match(TComma));
		}
		
		consume(TRBrak, "Unterminated array.");
		return new LiteralExpression(array, XArray);
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