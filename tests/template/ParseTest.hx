package template;

import xing.template.Parser;
import tink.unit.Assert;
import xing.template.Lexer;

class ParseTest {
	public function new() {}

	public function testKeywords() {
		var template = "{{ a = 12 + 13; }}";
		var lexer = new Lexer(template, "base.html");
		var tokens = lexer.scanTokens();
		var parser = new Parser(tokens);
		trace(parser.parse().toString());
		return Assert.assert(true);
	}
}
