package xing.request;

enum abstract RequestMethod(String) from String to String {
	var GET = "GET";
	var PUT = "PUT";
	var HEAD = "HEAD";
	var POST = "POST";
	var PATCH = "PATCH";
	var TRACE = "TRACE";
	var DELETE = "DELETE";
	var CONNECT = "CONNECT";
	var OPTIONS = "OPTIONS";
}