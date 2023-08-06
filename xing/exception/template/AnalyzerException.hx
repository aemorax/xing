package xing.exception.template;

import xing.template.Expression;

class AnalyzerException extends haxe.Exception {
	public var expr:Expression;
	public function new(message:String, ?expr:Expression) {
		super('[Xing]: AnalyzerException: ${message} in expression ${expr}');
		this.expr = expr;
	}
}