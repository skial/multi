package uhx.multi.structs;

import haxe.ds.StringMap;

/**
 * ...
 * @author Skial Bainn
 */
class Installation extends Download {
	
	public var environment:StringMap<String> = new StringMap();
	
	public inline function new() {
		super();
	}
	
}