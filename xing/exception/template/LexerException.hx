package xing.exception.template;

class LexerException extends haxe.Exception {
	private var fileName:String;

	public function new(message:String, position:Int, ?fileName:String="") {
		super("[Xing]: LexerException: " + message);
	}
}