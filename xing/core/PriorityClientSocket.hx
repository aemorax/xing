package xing.core;

import sys.net.Socket;

typedef PriorityClientSocket = {
	var priority : Int;
	var socket : Socket;
	var pending : Bool;
	var done : Bool;
}