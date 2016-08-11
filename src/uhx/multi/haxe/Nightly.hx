package uhx.multi.haxe;

import haxe.Http;
import haxe.Json;
import tjson.TJSON;
import thx.DateTimeUtc;
import thx.semver.Version;
import uhx.multi.IResource;
import uhx.multi.structs.Data;
import uhx.multi.download.Type;
import uhx.multi.download.Output;
import uhx.multi.download.Request;
import uhx.multi.structs.Download;
import uhx.multi.structs.NightlyVersions;

using thx.Arrays;
using StringTools;
using sys.io.File;
using haxe.io.Path;
using uhx.multi.Util;
using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
class Nightly implements IResource {

	public var name(default, never):String = 'nightly';
	public var download(default, never):String = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
	public var versions(default, never):String = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
	
	private var config:Data;
	private var directory:String;
	private var localVersionsParsed:String;
	private var localVersionsOriginal:String;
	private var localVersionsData:NightlyVersions = null;
	
	public function new(directory:String, config:Data) {
		this.config = config;
		this.directory = directory;
		
		initialize();
	}
	
	private function initialize():Void {
		localVersionsParsed = '$directory/nightly/versions.json';
		localVersionsOriginal = '$directory/nightly/versions.html';
		
		if (!localVersionsParsed.exists()) {
			if (!localVersionsOriginal.exists()) {
				var downloaded = request( '$versions${Sys.systemName().toLowerCase()}/', localVersionsOriginal );
				if (downloaded != null) config.downloads.push( downloaded );
				
			}
			
			localVersionsData = parse(localVersionsOriginal.getContent());
			localVersionsParsed.saveContent( TJSON.encode(localVersionsData) );
			
		} else {
			localVersionsData = TJSON.parse(localVersionsParsed.getContent());
			
		}
		
	}
	
	public function available():Array<String> {
		var results:Array<String> = [];
		
		for (info in localVersionsData.versions) {
			results.push( '${info.version} => ' + DateTimeUtc.fromString(info.date).toDateTime().format() + ' (${info.date.split(' ')[0]})' );
			
		}
		
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
	
	private function parse(html:String):NightlyVersions {
		var result = { current: '', versions: [] };
		
		// I predict a riot.
		var open = html.indexOf('<pre>');
		var close = html.lastIndexOf('</pre>');
		if (open == -1 || close == -1) throw 'build.haxe.org source html has changed, please open an issue at https://github.com/skial/multi/issues/.';
		
		var versions:Array<NightlyVersion> = [];
		var nightlies = html.substring(open+5, close).trim();
		// ((\d+-\d+)+ \d+:\d{0,2})\s*(\d+)\s*\S*\s*href="(.*)"
		// ------------------------   -----               ----
		// Group 1                    Group 3             Group 4
		// ((\d+-\d+)+ \d+:\d{0,2})\s*(\d+)\s*\S*\s*href="(.*)"
		//  ---------
		//  Skip group 2
		var ereg = ~/((\d+-\d+)+ \d+:\d{0,2})\s*(\d+)\s*\S*\s*href="(.*)"/gi;
		
		if (ereg.match(nightlies)) {
			ereg.map(nightlies, function(r) {
				var version = {
					date: r.matched(1) + ':00', 
					size: Std.parseInt(r.matched(3)), 
					version: r.matched(4).withoutDirectory().substr(0, -7).split('_').last(), 
					path: r.matched(4).normalize()
				};
				
				if (version.path.indexOf('latest') == -1) {
					if (version.size != 0) versions.push(version);
					
				}	else {
					versions.unshift(version);
					
				}
				
				if (version.path.indexOf('latest') > -1) result.current = version.path;
				
				return r.matched(0);
				
			});
			
			result.versions = versions;
			
		}
		
		return result;
	}
	
	private function constructUrl(version:NightlyVersion):String {
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
		
		if (!saveTo.directory().exists()) saveTo.directory().addTrailingSlash().buildDirectory();
		
		// `Request::fetch` is a macro built generator, 
		// returning an iterator, using returns to yield.
		for (download in request.fetch()) if (download != null) {
			downloaded = download;
			
		}
		
		saveTo.saveBytes( request.buffer.getBytes() );
		request.dispose();
		
		return downloaded;
	}
	
}
