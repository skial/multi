package uhx.multi;

import uhx.multi.structs.Download;

//import haxe.Constraints.Constructible;

/**
 * @author Skial Bainn
 */
interface IResource {
  
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
	
	public function exists(values:Array<String>):Bool;
	public function get(values:Array<String>):Null<Download>;
	public function describe(values:Array<String>):Null<Download>;
	
}

/*typedef TResource<T:Constructible<String>> = {
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
}*/
