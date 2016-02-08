package uhx.multi.haxe;
import uhx.multi.IResource;

using sys.io.File;
using haxe.io.Path;
using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
class Stable implements IResource {
	
	public var name(default, never):String = 'stable';
	public var download(default, never):String = "http://haxe.org/download/file/";
	public var versions(default, never):String = "https://raw.githubusercontent.com/HaxeFoundation/haxe.org/master/www/website-content/downloads/versions.json";
	
	private var directory:String;
	private var localVersions:String;
	
	public function new(directory:String) {
		this.directory = directory;
		initialize();
	}
	
	private function initialize():Void {
		if (!'$directory/versions.json'.exists()) {
			
			
		}
	}
	
	public function exists(values:Array<String>):Bool {
		return false;
	}
	
	public function get(values:Array<String>) {
		
	}
	
}