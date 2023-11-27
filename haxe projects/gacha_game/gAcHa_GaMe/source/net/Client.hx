package net;

import haxe.io.Bytes;
import sys.net.*;

class Client {

	var _s:Socket;
	var _incoming:Array<Dynamic>;

	public function new()
	{
		_incoming = [];
	}

	public function connect(host:String, port:Int)
	{
		_s = new Socket();
		_s.connect(new Host(host), port);
		_s.setFastSend(true);
	}

	public function disconnect()
	{
		_s.close();
	}

	public function send(m:String)
	{
		try {
			_s.output.write(Bytes.ofString(m));
			//_s.output.flush();
			trace('message sent.');
		} catch (e) {
			trace('Uncaught: ${e}');
		}
	}

	public function loop() 
	{
		trace('client:connection_started');
		while(true) {
			var m = _s.input.readLine();
			trace('received ${m}');
			_incoming.insert(0, m);
		}
		trace('client:connection_terminated');		
	}
	
}
	