package uhx.multi.download;

import haxe.CallStack;
import haxe.Http;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesOutput;
import sys.io.FileOutput;
import uhx.multi.Download;
import uhx.multi.download.Type;

using Thx;
using sys.io.File;
using haxe.io.Path;
using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
class Request {
	
	public var http:Http;
	public var output:Output;
	public var savedTo:String;
	public var buffer:BytesOutput;
	public var download:Null<Download> = new Download();
	public var completed:Bool = false;

	public function new(url:String, saveTo:String) {
		this.savedTo = saveTo;
		this.buffer = new BytesOutput();
		this.output = new Output( buffer );
		//this.output = new Output( savedTo.write( true ) );
		
		http = new Http( url );
		http.onError = onError;
		http.onStatus = onStatus;
		
		download.fetched = Timer.time();
		http.customRequest(false, output);
	}
	
	@:generator public function fetch():Null<Download> {
		if (!completed) {
			return null;
			
		} else {
			return download;
			
		}
	}
	
	public function dispose():Void {
		buffer.close();
		output.close();
	}
	
	private function onError(e:String):Void {
		trace( e );
		trace( CallStack.exceptionStack() );
		download = null;
		output.close();
	}
	
	private function onStatus(s:Int):Void {
		download.installed = Timer.time();
		download.path = this.savedTo;
		download.type = Type.Resource;
		completed = true;
	}
	
}