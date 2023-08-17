package xing;

import xing.request.Request;
import xing.response.Response;
import haxe.Exception;
import picohttp.PicoHttpParser;
import picohttp.PicoHttpParser.ParsedRequest;
import xing.core.System;
import sys.thread.FixedThreadPool;
import xing.core.PriorityClientSocket;
import sys.net.Host;
import sys.net.Socket;
import sys.thread.IThreadPool;

class Xing {
	private var cores : Int = 0;
	private var applicationThreads:IThreadPool;
	private var backlog:Array<PriorityClientSocket> = [];
	private var routes:Map<String, Request->Response->Void>;

	public function new() {
		this.cores = System.getProcessorCores();
		if (this.cores < 0)
			this.cores = 1;
		this.routes = new Map<String, Request->Response->Void>();
	}

	public function registerRoute(path:String, callback:Request->Response->Void) {
		routes.set(path, callback);
	}

	public function listen(?host:String="0.0.0.0", ?ports:Array<Int> = null) {
		if (ports == null)
			ports = [3000];

		var nativeHost:Host = new Host(host);

		if (ports.length == 1) {
			applicationThreadHandler(nativeHost, ports[0])();
		} else {
			this.applicationThreads = new FixedThreadPool(ports.length - 1);
			var lastPort = ports.pop();
			for (port in ports) {
				this.applicationThreads.run(applicationThreadHandler(nativeHost, port));
			}
			applicationThreadHandler(nativeHost, lastPort)();
		}
	}

	private function applicationThreadHandler(host:Host, port:Int) {
		return function() {
			var workerSocket = new Socket();
			workerSocket.bind(host, port);
			workerSocket.listen(1024);
			var workerClientHandlerThread:IThreadPool = new FixedThreadPool(this.cores*25);

			while (true) {
				var client = workerSocket.accept();
				if (client != null) {
					workerClientHandlerThread.run(clientThreadHandler({
						socket: client,
						priority: 0,
						pending: false,
						done: false
					}));
				}
			}
		}
	}

	private function clientThreadHandler(client:PriorityClientSocket) {
		return function() {
			client.pending = true;
			try {
				var req = parseRequest(client.socket.input);
				if(routes.exists(req.request.path)) {
					routes.get(req.request.path)(Request.fromParsedRequest(req.request, req.body, req.rawRequest), Response.fromOutput(client.socket.output));
				} else {
					Response.notFound(client.socket.output);
				}
				client.socket.shutdown(true, true);
				client.socket.close();
				client.pending = false;
				client.done = true;
			} catch(e:Exception) {
				client.pending = false;
				client.done = true;
			}
		}
	}

	private function parseRequest(input:haxe.io.Input):{body:haxe.io.Bytes, rawRequest:String, request:ParsedRequest} {
		var reqString:String = "";
		while (true) {
			try {
				var res = input.readLine();
				reqString += '${res}\r\n';
				if (res == "") {
					break;
				}
			} catch (e:Any) {
				break;
			}
		}
		var parsedReq = PicoHttpParser.parseRequest(reqString);
		var cLen = parsedReq.headers.get("Content-Length");
		var body : haxe.io.Bytes = null;
		if(cLen != null) {
			body = haxe.io.Bytes.alloc(Std.parseInt(cLen));
			input.readBytes(body, 0, Std.parseInt(cLen));
		}

		return {
			rawRequest: reqString,
			body: body,
			request: parsedReq
		};
	}
}