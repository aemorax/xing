package xing.template;

enum abstract TokenCode(Int) from Int to Int {
	// SingleTokens
	var StartSingle; // Single Tokens
	var TLBrak; // [
	var TRBrak; // ]
	var TLPran; // (
	var TRPran; // )
	var TLBrac; // {
	var TRBrac; // }
	var TMinus; // -
	var TPlus; // +
	var TAsterisk; // *
	var TSlash; // /
	var TPrcent; // %
	var TPipe; // |
	var TAmp; // &
	var TEqual; // =
	var TALBrak; // <
	var TARBrak; // >
	var TTilde; // ~
	var TComma; // ,
	var TSemiColon; // ;
	var TStop; // .
	var TQuote; // '
	var TDQuote; // "
	var TCaret; // ^
	var TExclam; // !
	var EndSingle; // End of single character tokens
	// Double Tokens
	var StartDouble; // Double Tokens
	var TDEqual; // ==
	var TNEqual; // !=
	var TPlusPlus; // ++
	var TPlusEqual; // +=
	var TMinusMinus; // --
	var TMinusEqual; // -=
	var TAsteriskEqual; // *=
	var TSlashEqual; // /=
	var TPrcentEqual; // %=
	var TALBrakEqual; // <=
	var TARBrakEqual; // >=
	var TALBrakBrak; // <<
	var TARBrakBrak; // >>
	var TDAmp; // &&
	var TDPipe; // ||
	var TAmpEqual; // &=
	var TPipeEqual; // |=
	var TDLBrace; // "{{"
	var TDRBrace; // "}}"
	var TCommentStart; // "#{"
	var TCommentEnd; // "}#"
	var TColonEqual; // :=
	var TInterval; // ..
	var TDDollar; // $$
	var EndDouble; // End of double character Tokens
	var StartLiteral; // StartLiteral
	var TDoc; // Anything in document context
	var TInt; // 10; 00; 0x10; 0b00;
	var TFloat; // 1.02; 1f; .12;
	var TString; // "[any!\n]*", '[any!\n]'
	var TID; // [A-Za-z_].*
	var EndLiteral; // End of literals
	// Keywords
	var StartKeyword; // Keyword Tokens: Dont forget to add to Token list
	var Tif; // if
	var Telif; // elif
	var Telse; // else
	var Twhile; // while
	var Tfor; // for
	var Tin; // in
	var Ttrue; // true
	var Tfalse; // false
	var EndKeyword; // End of keywords
	var TEOF;

	@:op(A < B)
	inline function lt(other:TokenCode) {
		return this < cast(other, Int);
	}

	@:op(A > B)
	inline function gt(other:TokenCode) {
		return this > cast(other, Int);
	}

	@:op(A == B)
	inline function eq(other:TokenCode) {
		return this == cast(other, Int);
	}
}
