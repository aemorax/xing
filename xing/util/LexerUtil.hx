package xing.util;

class LexerUtil {
	public static inline function isAlpha(char:String):Bool {
		var cCode:Int = char.charCodeAt(0);
		if ((cCode >= 0x41 && cCode <= 0x5a) || (cCode >= 0x61 && cCode <= 0x7a))
			return true;
		return false;
	}

	public static inline function isDigit(char:String):Bool {
		var cCode:Int = char.charCodeAt(0);
		if (cCode >= 0x30 && cCode <= 0x39)
			return true;
		return false;
	}

	public static inline function isUnderline(char:String):Bool {
		return char == "_";
	}

	public static inline function isIdentifierChar(char:String):Bool {
		return isAlpha(char) || isDigit(char) || isUnderline(char);
	}
}