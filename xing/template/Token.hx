package xing.template;

abstract Token(TokenType) from TokenType {
	public static final keywords : Map<Int, Map<String, TokenCode>> = [
		2 => [
			"if"=>Tif,
			"in"=>Tin
		],
		3 => [
			"for"=>Tfor,
			"end"=>Tend
		],
		4 => [
			"elif"=>Telif,
			"else"=>Telse,
			"true"=>Ttrue
		],
		5 => [
			"while"=>Twhile,
			"false"=>Tfalse
		]
	];

	static final keywordLength : Map<TokenCode,Int> = [
		Tif => 2,
		Tin => 2,
		Tfor => 3,
		Tend => 3,
		Telif => 4,
		Telse => 4,
		Ttrue => 4,
		Tfalse => 5,
		Twhile => 5,
	];

	public function new(code:TokenCode, ?start:Int=0, ?length:Int=0, ?literal:String) {
		length = findLength(code, length, literal);
		literal = code > StartKeyword ? null : literal;

		this = {
			code: code,
			start: start,
			length: length,
			literal: literal
		};
	}

	public var code(get,never):TokenCode;
	public var start(get,never):Int;
	public var length(get,never):Int;
	public var literal(get,never):String;

	inline function get_code():TokenCode {
		return this.code;
	}

	inline function get_start():Int {
		return this.start;
	}

	inline function get_length():Int {
		return this.length;
	}

	inline function get_literal():String {
		return this.literal;
	}

	inline function findLength(code:TokenCode, ?length:Int=0, ?literal:String) : Int {
		if(length == 0) {
			if(code < EndSingle) {
				length = 1;
			} else if(code < EndDouble) {
				length = 2;
			} else if(code < EndLiteral) {
				if(literal != null) {
					length = literal.length;
				}
			}
		}

		if(code > StartKeyword) {
			var kw = keywordLength.get(code);
			if(kw != null) {
				length = kw;
			}
		}

		return length;
	}

	@:keep
	public function toString():String {
		return Std.string(this.code)+":"+this.literal;
	}
}