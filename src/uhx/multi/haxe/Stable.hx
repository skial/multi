package uhx.multi.haxe;

import haxe.Http;
import haxe.Json;
import tjson.TJSON;
import uhx.multi.Download;
import uhx.multi.IResource;
import uhx.multi.structs.Data;
import uhx.multi.download.Type;
import uhx.multi.download.Output;
import uhx.multi.download.Request;
import uhx.multi.structs.StableVersions;

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
	private var localVersionsData:StableVersions = null;
	
	public function new(directory:String, config:Data) {
		this.config = config;
		this.directory = directory;
		
		initialize();
	}
	
	private function initialize():Void {
		localVersions = '$directory/versions.json';
		
		if (!localVersions.exists()) {
			
			var downloaded:Download = null;
			var request = new Request( versions, localVersions );
			
			// `Request::fetch` is a macro built generator, 
			// returning an iterator, using returns to yield.
			for (download in request.fetch()) if (download != null) {
				downloaded = download;
				
			}
			
			localVersions.saveBytes( request.buffer.getBytes() );
			config.downloads.push( downloaded );
			request.dispose();
			
		}
		
		
		trace( localVersionsData = TJSON.parse(localVersions.getContent()) );
	}
	
	public function exists(values:Array<String>):Bool {
		return false;
	}
	
	public function get(values:Array<String>) {
		
	}
	
}