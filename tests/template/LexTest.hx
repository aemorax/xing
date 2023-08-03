package template;

import tink.unit.Assert;
import xing.template.Lexer;
import haxe.Resource;

class LexTest {
	public function new() {}

	public function testKeywords() {
		var template = Resource.getString("baseHtml");
		var lexer = new Lexer(template, "base.html");
		for(tok in lexer.scanTokens()) {
			Sys.println(tok.toString());
		}
		return Assert.assert(true);
	}
}