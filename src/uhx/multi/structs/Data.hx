package uhx.multi.structs;

import uhx.multi.structs.Download;

/**
 * ...
 * @author Skial Bainn
 */
class Data {
	
	public var current:Download = null;
	public var configs:Array<String> = [];
	public var downloads:Array<Download> = [];
	public var original:Null<Installation> = null;
	
	public inline function new() {
		
	}
	
}