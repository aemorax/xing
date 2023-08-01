package xing.core;

import haxe.io.Eof;
import haxe.io.BytesOutput;
import sys.io.Process;
import haxe.io.Path;
import sys.FileSystem;

enum HostPlatform {
	Windows;
	Linux;
	Mac;
}

class System {
	private static var _hostPlatform:HostPlatform;

	private static function get_hostPlatform():HostPlatform {
		if (_hostPlatform == null) {
			if (new EReg("window", "i").match(Sys.systemName())) {
				_hostPlatform = Windows;
			} else if (new EReg("linux", "i").match(Sys.systemName())) {
				_hostPlatform = Linux;
			} else if (new EReg("mac", "i").match(Sys.systemName())) {
				_hostPlatform = Mac;
			}
		}

		return _hostPlatform;
	}

	public static function runProcess(path:String, command:String, args:Array<String>, waitForOutput:Bool = true, safeExecute:Bool = true,
			ignoreErrors:Bool = false, print:Bool = false, returnErrorValue:Bool = false):String {
		if (print) {
			var message = command;

			for (arg in args) {
				if (arg.indexOf(" ") > -1) {
					message += " \"" + arg + "\"";
				} else {
					message += " " + arg;
				}
			}

			Sys.println(message);
		}

		#if (haxe_ver < "3.3.0")
		command = Path.escape(command);
		#end

		if (safeExecute) {
			try {
				if (path != null
					&& path != ""
					&& !FileSystem.exists(FileSystem.fullPath(path))
					&& !FileSystem.exists(FileSystem.fullPath(new Path(path).dir))) {
					trace("The specified target path \"" + path + "\" does not exist");
				}

				return _runProcess(path, command, args, waitForOutput, safeExecute, ignoreErrors, returnErrorValue);
			} catch (e:Dynamic) {
				if (!ignoreErrors) {}

				return null;
			}
		} else {
			return _runProcess(path, command, args, waitForOutput, safeExecute, ignoreErrors, returnErrorValue);
		}
	}

	private static function _runProcess(path:String, command:String, args:Array<String>, waitForOutput:Bool, safeExecute:Bool, ignoreErrors:Bool,
			returnErrorValue:Bool):String {
		var oldPath:String = "";

		if (path != null && path != "") {
			// trace("", " - \x1b[1mChanging directory:\x1b[0m " + path + "");
			oldPath = Sys.getCwd();
			Sys.setCwd(path);
		}

		var argString = "";

		for (arg in args) {
			if (arg.indexOf(" ") > -1) {
				argString += " \"" + arg + "\"";
			} else {
				argString += " " + arg;
			}
		}

		// trace("", " - \x1b[1mRunning process:\x1b[0m " + command + argString);

		var output = "";
		var result = 0;

		var process = new Process(command, args);
		var buffer = new BytesOutput();

		if (waitForOutput) {
			var waiting = true;

			while (waiting) {
				try {
					var current = process.stdout.readAll(1024);
					buffer.write(current);

					if (current.length == 0) {
						waiting = false;
					}
				} catch (e:Eof) {
					waiting = false;
				}
			}

			result = process.exitCode();

			output = buffer.getBytes().toString();

			if (output == "") {
				var error = process.stderr.readAll().toString();
				process.close();

				if (result != 0 || error != "") {
					if (ignoreErrors) {
						output = error;
					} else if (!safeExecute) {
						throw error;
					} else {
						trace(error);
					}

					if (returnErrorValue) {
						return output;
					} else {
						return null;
					}
				}
			} else {
				process.close();
			}
		}

		if (oldPath != "") {
			Sys.setCwd(oldPath);
		}

		return output;
	}

	public static function getProcessorCores():Null<Int> {
		var hostPlatform = get_hostPlatform();
		var result = null;

		if (hostPlatform == Windows) {
			var env = Sys.getEnv("NUMBER_OF_PROCESSORS");

			if (env != null) {
				result = env;
			}
		} else if (hostPlatform == Linux) {
			result = runProcess("", "nproc", [], true, true, true);

			if (result == null) {
				var cpuinfo = runProcess("", "cat", ["/proc/cpuinfo"], true, true, true);

				if (cpuinfo != null) {
					var split = cpuinfo.split("processor");
					result = Std.string(split.length - 1);
				}
			}
		} else if (hostPlatform == Mac) {
			var cores = ~/Total Number of Cores: (\d+)/;
			var output = runProcess("", "/usr/sbin/system_profiler", ["-detailLevel", "full", "SPHardwareDataType"]);

			if (cores.match(output)) {
				result = cores.matched(1);
			}
		}
		
		return Std.parseInt(result);
	}
}
