package uhx.multi.haxe;

using haxe.io.Path;

/**
 * ...
 * @author Skial Bainn
 */
class Stable implements Resource {
	
	public var name(default, never):String = 'stable';
	public var download(default, never):String = "http://haxe.org/download/file/";
	public var versions(default, never):String = "https://raw.githubusercontent.com/HaxeFoundation/haxe.org/master/www/website-content/downloads/versions.json";
	
	private var localVersions:String;
	
	public function new(directory:String) {
		initialize();
		trace( directory );
	}
	
	private function initialize():Void {
		
	}
	
	public function exists(values:Array<String>):Bool {
		return false;
	}
	
	public function get(values:Array<String>) {
		
	}
	
}