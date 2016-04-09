package uhx.multi.haxe;

import haxe.Http;
import haxe.Json;
import tjson.TJSON;
import thx.semver.Version;
import uhx.multi.structs.Download;
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
	public var download(default, never):String = "http://haxe.org/website-content/downloads/";
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
			var downloaded = request( versions, localVersions );
			if (downloaded != null) config.downloads.push( downloaded );
			
		}
		
		localVersionsData = TJSON.parse(localVersions.getContent());
	}
	
	public function available():Array<String> {
		var results = [];
		
		for (info in localVersionsData.versions) {
			results.push( '"${info.version}" released ${info.date}' );
		}
		
		return results;
	}
	
	@:access(thx.semver.Version)
	public function exists(values:Array<String>):Bool {
		var result = false;
		
		switch (values) {
			case ['stable']:
				result = localVersionsData != null && localVersionsData.current != null;
				
			case ['stable', Version.VERSION.match(_) => true]:
				var version = (values[1]:Version);
				result = 
					localVersionsData != null && 
					localVersionsData.current != null && 
					[for (info in localVersionsData.versions) if ((info.version:Version) == version) true].length > 0;
					
			case [Version.VERSION.match(_) => true]:
				result = localVersionsData != null && (values[0]:Version) <= (localVersionsData.current:Version);
				
			case _:
				
		}
		
		return result;
	}
	
	@:access(thx.semver.Version)
	public function get(values:Array<String>):Null<Download> {
		var result = null;
		
		switch (values) {
			case ['stable']:
				var latest = localVersionsData.versions.filter( function(v) return v.version == localVersionsData.current )[0];
				var url = constructUrl( latest );
				var saveTo = '$directory/stable/haxe/' + latest.version + '/' + url.withoutDirectory();
				
				if (!saveTo.exists()) {
					result = request( url, saveTo );
					
				} else {
					Sys.println( 'You already have Haxe ' + latest.version.toString() + ', located at $saveTo' );
					
				}
				
			case ['stable', Version.VERSION.match(_) => true]:
				var match = localVersionsData.versions.filter( function(v) return (v.version:Version) == (values[1]:Version) )[0];
				var url = constructUrl( match );
				var saveTo = '$directory/stable/haxe/' + match.version + '/' + url.withoutDirectory();
				
				if (!saveTo.exists()) {
					result = request( url, saveTo );
					
				} else {
					Sys.println( 'You already have Haxe ' + match.version.toString() + ', located at $saveTo' );
					
				}
				
			case [Version.VERSION.match(_) => true]:
				var semver:Version = values[0];
				
				if (semver > (localVersionsData.current:Version)) {
					// prompt the user if they want to fetch latest nightly build?
					// or see a list of haxe releases?
					
				} else {
					var match = localVersionsData.versions.filter( function(v) return (v.version:Version) == semver)[0];
					var url = constructUrl( match );
					var saveTo = '$directory/stable/haxe/' + match.version + '/' + url.withoutDirectory();
					
					if (!saveTo.exists()) {
						result = request( url, saveTo );
						
					} else {
						Sys.println( 'You already have Haxe ' + match.version.toString() + ', located at $saveTo' );
						
					}
					
				}
				
			case _:
				throw 'Unmatched version: ' + values;
				
		}
		
		return result;
	}
	
	@:access(thx.semver.Version)
	public function describe(values:Array<String>):Download {
		var result = new Download();
		result.path = '<unknown>';
		result.type = Type.Resource;
		result.installed = result.fetched = -1.0;
		
		switch (values) {
			case ['stable']:
				var latest = localVersionsData.versions.filter( function(v) return v.version == localVersionsData.current )[0];
				result.path = '$directory/stable/haxe/' + latest.version + '/' +  constructUrl( latest ).withoutDirectory();
				
			case ['stable', Version.VERSION.match(_) => true]:
				var match = localVersionsData.versions.filter( function(v) return (v.version:Version) == (values[1]:Version) )[0];
				result.path = '$directory/stable/' + match.version + '/haxe/' + constructUrl( match ).withoutDirectory();
				
			case _:
				
		}
		
		return result;
	}
	
	private function constructUrl(version:StableVersion):String {
		var result = '$download/' + version.version + '/downloads/haxe-' + version.version + '-';
		
		switch (Sys.systemName().toLowerCase()) {
			case 'windows': result += 'win.exe';
			case 'osx': result += 'osx-installer.pkg';
			case 'linux': result += 'linux64.tar.gz';
			case _: throw 'Your system ${Sys.systemName()} is currently not supported :(';
		}
		
		return result.normalize();
	}
	
	private function request(url:String, saveTo:String):Null<Download> {
		var downloaded:Download = null;
		var request = new Request( url, saveTo );
		
		if (!saveTo.directory().exists()) buildDirectory( saveTo.directory().addTrailingSlash() );
		
		// `Request::fetch` is a macro built generator, 
		// returning an iterator, using returns to yield.
		for (download in request.fetch()) if (download != null) {
			downloaded = download;
			
		}
		
		saveTo.saveBytes( request.buffer.getBytes() );
		request.dispose();
		
		return downloaded;
	}
	
	public static function buildDirectory(path:String) {
		var path = path.split( '/' );
		var complete = path.shift();
		
		for (i in 0...path.length - 1) {
			trace( '$complete/${path[i]}' );
			if (!'$complete/${path[i]}'.exists()) {
				complete = '$complete/${path[i]}';
				complete.createDirectory();
				
			} else {
				complete = '$complete/${path[i]}';
				
			}
			
		}
	}
	
}
