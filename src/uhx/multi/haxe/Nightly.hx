package uhx.multi.haxe;

import uhx.multi.structs.Data;
import uhx.multi.structs.Download;

/**
 * ...
 * @author Skial Bainn
 */
class Nightly implements IResource {

	public var name(default, never):String = 'nightly';
	public var download(default, never):String = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
	public var versions(default, never):String = '';
	
	public function new(directory:String, config:Data) {
		
	}
	
	public function available():Array<String> {
		var results:Array<String> = [];
		
		return results;
	}
	
	public function exists(values:Array<String>):Bool {
		return false;
	}
	
	public function get(values:Array<String>):Null<Download> {
		var result = null;
		
		return result;
	}
	
	@:access(thx.semver.Version)
	public function describe(values:Array<String>):Download {
		var result = new Download();
		
		
		return result;
	}
	
}
