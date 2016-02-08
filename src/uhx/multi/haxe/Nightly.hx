package uhx.multi.haxe;

/**
 * ...
 * @author Skial Bainn
 */
class Nightly implements IResource {

	public var name(default, never):String = 'nightly';
	public var download(default, never):String = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
	public var versions(default, never):String = '';
	
	public function new(directory:String) {
		
	}
	
}