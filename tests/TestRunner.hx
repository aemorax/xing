package;

import tink.unit.Assert;
import tink.unit.TestBatch;
import tink.testrunner.Runner;

class TestRunner {
	public static function main() {
		var starter = TestBatch.make([
			new BasicTest(),
			// new template.LexTest(),
			new template.ParseTest(),
		]);

		// Run Testing Batch And Exit
		Runner.run(starter).handle(Runner.exit);
	}
}

class BasicTest {
	public function new() {}

	public function testSystemRunning() {
		return Assert.assert(true, "Test System Working.");
	}
}

