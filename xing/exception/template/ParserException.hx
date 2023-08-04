package xing.exception.template;

import haxe.Exception;

class ParserException extends Exception {
	public function new(message:String) {
		super("[Xing]: ParserException " + message);
	}
}