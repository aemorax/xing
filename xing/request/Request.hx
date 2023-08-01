package xing.request;

import picohttp.PicoHttpParser.ParsedRequest;

class Request {
	public var method : RequestMethod;
	public var body : String;
	public var path : String;
	@:isVar
	public var cookies(get, null) : Map<String, String>;
	public var headers(default, null) : Map<String, String>;
	public var raw : String;

	function new(method:RequestMethod, body:String, path:String, headers:Map<String, String>, raw:String) {
		this.method = method;
		this.body = body;
		this.path = path;
		this.headers = headers;
	}

	function get_cookies():Map<String, String> {
		if(this.cookies == null) {
			this.cookies = new Map<String, String>();
			var cs = this.headers.get("Cookie");
			var cookies = cs.split(";");
			var temp : Array<String>;
			for(cookie in cookies) {
				temp = cookie.split("=");
				this.cookies.set(StringTools.trim(temp[0]), StringTools.trim(temp[1]));
			}
		}

		return this.cookies;
	}

	public static function fromParsedRequest(parsedRequest:ParsedRequest, rawString:String):Request {
		return new Request(parsedRequest.method, "", parsedRequest.path, parsedRequest.headers, rawString);
	}
}