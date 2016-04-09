package uhx.multi;

import uhx.multi.structs.Download;

/**
 * @author Skial Bainn
 */
interface IResource {
  
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
	
	public function available():Array<String>;
	public function exists(values:Array<String>):Bool;
	public function get(values:Array<String>):Null<Download>;
	public function describe(values:Array<String>):Null<Download>;
	
}
