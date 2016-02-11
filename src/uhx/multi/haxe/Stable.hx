package uhx.multi.haxe;

import haxe.Http;
import haxe.Json;
import uhx.multi.Download;
import uhx.multi.download.Request;
import uhx.multi.download.Type;
import uhx.multi.IResource;
import uhx.multi.download.Output;
import uhx.multi.structs.Data;

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
	
	private var config:Data;
	private var directory:String;
	private var localVersions:String;
	private var localVersionsData:Dynamic;
	
	public function new(directory:String, config:Data) {
		this.config = config;
		this.directory = directory;
		
		initialize();
	}
	
	@:keep
	private function initialize():Void {
		localVersions = '$directory/versions.json';
		trace( localVersions );
		if (!localVersions.exists()) {
			trace( 'downloading $localVersions' );
			var downloaded:Download = null;
			var request = new Request( versions, localVersions );
			
			for (download in request.fetch()) if (download != null) {
				downloaded = download;
				break;
				
			}
			
			trace( downloaded );
			
		} else {
			trace( '$localVersions exists' );
			localVersionsData = Json.parse( localVersions.getContent() );
			
		}
	}
	
	public function exists(values:Array<String>):Bool {
		return false;
	}
	
	public function get(values:Array<String>) {
		
	}
	
}