package template;

import sys.io.File;
import tink.unit.Assert;
import xing.template.Lexer;

class LexTest {
	public function new() {}

	public function testKeywords() {
		var template = File.read("res/base.html", false).readAll().toString();
		var lexer = new Lexer(template, "base.html");
		for(tok in lexer.scanTokens()) {
			Sys.println(tok.toString());
		}
		return Assert.assert(true);
	}
}