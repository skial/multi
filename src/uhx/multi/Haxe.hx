package uhx.multi;

import haxe.ds.StringMap;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class Haxe {
	
	@alias('i')
	public var install:Null<String>;
	
	@alias('u')
	public var uninstall:Null<String>;
	
	@alias('r')
	public var reinstall:Null<String>;

	public function new(args:StringMap<Array<Dynamic>>) {
		
	}
	
}