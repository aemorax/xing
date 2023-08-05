package xing.template;

import haxe.exceptions.NotImplementedException;
import xing.util.LexerUtil;
import xing.exception.template.LexerException;

class Lexer {
	final source:String;
	final sourceLength:Int;
	final tokens:Array<Token> = [];

	private var token:Token;

	private var fileName:String;

	private var start = 0;
	@:isVar
	private var current(default, set) = 0;
	private var line = 1;
	private var length = 0;

	function set_current(value:Int):Int {
		this.length += value - this.current;
		return this.current = value;
	}

	private var context:LexerContext = Document;

	public function new(source:String, ?fileName:String = "") {
		this.source = source;
		this.sourceLength = source.length;
		this.fileName = fileName;
	}

	public function scanTokens():Array<Token> {
		while (!eof()) {
			this.start = this.current;
			this.token = scanToken();
			if (this.token != null) {
				this.tokens.push(token);
			}
		}
		tokens.push(new Token(TEOF, current, 0, "eof"));
		return tokens;
	}

	private function scanToken():Token {
		var c:String;
		switch (context) {
			case Document:
				c = advance();
				while (!eof()) {
					if (c == "{") {
						if (match("{")) {
							this.context = Control;
							return newToken(TDoc, this.length - 2);
						}
					}
					c = advance();
				}
				return newToken(TDoc, this.length);
			case Control:
				c = advance();
				switch (c) {
					case "{":
						return newToken(TLBrac);
					case "}":
						if (match("}")) {
							this.context = Document;
							this.length = 0;
							return null;
						} else {
							return newToken(TRBrac);
						}
					case "[":
						return newToken(TLBrak);
					case "]":
						return newToken(TRBrak);
					case "(":
						return newToken(TLPran);
					case ")":
						return newToken(TRPran);
					case ",":
						return newToken(TComma);
					case ";":
						return newToken(TSemiColon);
					case ".":
						if (match(".")) {
							return newToken(TInterval);
						}
						return newToken(TStop);
					case "+":
						if (match("+")) {
							return newToken(TPlusPlus);
						}
						if (match("=")) {
							return newToken(TPlusEqual);
						}
						return newToken(TPlus);
					case "-":
						if (match("-")) {
							return newToken(TMinusMinus);
						}
						if (match("=")) {
							return newToken(TMinusEqual);
						}
						return newToken(TMinus);
					case "*":
						if (match("=")) {
							return newToken(TAsteriskEqual);
						}
						return newToken(TAsterisk);
					case "/":
						if (match("=")) {
							return newToken(TSlashEqual);
						}
						return newToken(TSlash);
					case "%":
						if (match("=")) {
							return newToken(TPrcentEqual);
						}
						return newToken(TPrcent);
					case "|":
						if (match("=")) {
							return newToken(TDPipe);
						}
						return newToken(TPipe);
					case "&":
						if (match("=")) {
							return newToken(TDAmp);
						}
						return newToken(TAmp);
					case "=":
						if (match("=")) {
							return newToken(TDEqual);
						}
						return newToken(TEqual);
					case "<":
						if (match("=")) {
							return newToken(TALBrakEqual);
						}
						if (match("<")) {
							return newToken(TALBrakBrak);
						}
						return newToken(TALBrak);
					case ">":
						if (match("=")) {
							return newToken(TARBrakEqual);
						}
						if (match(">")) {
							return newToken(TARBrakBrak);
						}
						return newToken(TARBrak);
					case "~":
						return newToken(TTilde);
					case "^":
						return newToken(TCaret);
					case "!":
						if (match("=")) {
							return newToken(TNEqual);
						}
						return newToken(TExclam);
					case ":":
						if (match("=")) {
							return newToken(TColonEqual);
						}
						throw new LexerException(": must be followed with =", current, fileName);
					case "'":
						return string("'");
					case '"':
						return string('"');
					case "\t", "\r", " ":
						return null;
					case "\n":
						lineOperations();
					default:
						if (LexerUtil.isDigit(c)) {
							return number();
						} else if (LexerUtil.isAlpha(c)) {
							return identifier();
						}
						throw new LexerException('Invalid character $c', current, fileName);
				}
				return null;
		}
	}

	private inline function newToken(token:TokenCode, ?length:Int = 0, ?literal:String = ""):Token {
		literal = literal == "" ? this.source.substr(start, length) : literal;
		var tok = new Token(token, start, length, literal);
		this.length = 0;
		return tok;
	}

	private inline function eof():Bool {
		return current >= this.sourceLength;
	}

	private inline function eofAt(next:Int):Bool {
		return current + next >= this.sourceLength;
	}

	private inline function advance():String {
		return this.source.charAt(this.current++);
	}

	private inline function peek(?next:Int = 0):String {
		if (eofAt(next)) {
			return null;
		}
		return this.source.charAt(this.current + next);
	}

	private inline function match(pattern:String):Bool {
		// Single character checking can be faster with charAt
		if (pattern.length == 1) {
			if (eof()) {
				return false;
			}
			if (this.source.charAt(this.current) != pattern) {
				return false;
			}

			this.current++;
			return true;
		}

		if (eofAt(pattern.length)) {
			return false;
		}
		if (this.source.substr(this.current, pattern.length) != pattern) {
			return false;
		}

		this.current += pattern.length;
		return true;
	}

	private function number():Token {
		length = 1;
		if (peek(-1) == "0") {
			var next:String = peek();
			switch (next) {
				case "x":
					return hex();
				case "b":
					return bin();
				default:
			}
		}

		while (LexerUtil.isDigit(peek())) {
			advance();
		}

		if (peek(0) == "." && LexerUtil.isDigit(peek(1))) {
			advance();
			while (LexerUtil.isDigit(peek())) {
				advance();
			}
		} else {
			return newToken(TInt, length);
		}

		return newToken(TFloat, length);
	}

	private inline function string(term:String):Token {
		length = 1;
		while (peek(0) != term && !eof() && peek(-1) != "\\") {
			if (peek(0) == "\n")
				lineOperations();
			advance();
		}

		if (eof()) {
			throw new LexerException("Unterminated string.", current, "");
		}

		advance();

		return newToken(TString, length);
	}

	private function identifier():Token {
		while (LexerUtil.isIdentifierChar(peek())) {
			advance();
		}

		var value = source.substring(start, current);
		length = value.length;

		// Keyword check
		var t1 = Token.keywords.get(length);
		if (t1 != null) {
			var t2 = t1.get(value);
			if (t2 != null) {
				return newToken(t2, 0, value);
			}
		}
		return newToken(TID, length);
	}

	private inline function hex():Token {
		throw new NotImplementedException();
	}

	private inline function bin():Token {
		throw new NotImplementedException();
	}

	private inline function lineOperations():Void {
		line++;
	}
}
