package uhx.multi.haxe;

import haxe.io.Output;
import haxe.Serializer;
import haxe.Unserializer;
import thx.semver.Version;
import uhx.multi.haxe.Util.*;

using StringTools;
using sys.io.File;
using haxe.io.Path;
using sys.FileSystem;
using thx.semver.Version;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class LibRunner {
	
	public static inline var stableDownload:String = "http://haxe.org/download/file/";
	public static inline var stableVersions:String = "https://raw.githubusercontent.com/HaxeFoundation/haxe.org/master/www/website-content/downloads/versions.json";
	public static inline var nightlyDownload:String = "http://hxbuilds.s3-website-us-east-1.amazonaws.com/builds/haxe/";
	
	public static function main() {
		var librunner = new LibRunner( Sys.args() );
		librunner.exit();
	}
	
	@alias('i')
	public var install:Null<String>;
	
	@alias('u')
	public var update:Null<String>;
	
	@alias('x')
	public var uninstall:Null<String>;
	
	@alias('r')
	public var reset:Bool = false;
	
	@alias('d')
	public var directory:Null<String>;
	
	@alias('l')
	public var local:Bool = false;
	
	@alias('c')
	public var config:String = '.multihaxe';
	private var configIO:Output = null;
	private var configData:Data = null;

	public function new(args:Array<String>) {
		@:cmd _;
		
		init();
		setup();
		process();
	}
	
	private function init():Void {
		Util.init();
	}
	
	private function setup():Void {
		config = '$userProfile/$config'.normalize();
		if (directory == null) directory = '$userProfile/multihaxe/'.normalize();
		trace( config, config.exists() );
		
		if (!config.exists()) {
			configData = new Data();
			config.saveContent( Serializer.run( configData ) );
			
		} else {
			configData = Unserializer.run( config.getContent() );
			
		}
		
		configIO = config.write();
		
		if (!directory.exists()) directory.createDirectory();
	}
	
	@:access(thx.semver.Version)
	private function process():Void {
		if (install != null) {
			var versions = findVersion( install );
			trace( versions );
			switch (versions) {
				case ['stable']:
					
					
				case ['nightly']:
					
					
				case ['stable', Version.VERSION.match(_) => true]: 
					var version = (versions[1]:Version);
					
				case ['nightly', _.length >= 7 => true]: 
					
					
				case _: 
					Sys.println( 'Version `' + versions.join('-') + '` does not appear to exist.' );
					
			}
			
		}
		
	}
	
	private function findVersion(value:String):Array<String> {
		var results = [];
		
		switch (value) {
			case _.startsWith('stable') => true:
				results.push( 'stable' );
				if (value.charCodeAt(6) == '-'.code) results = results.concat( findVersion( value.substring( 7 ) ) );
				
			case _.startsWith('nightly') => true:
				results.push( 'nightly' );
				if (value.charCodeAt(7) == '-'.code) results = results.concat( findVersion( value.substr( 8 ) ) );
				
			case x if (x.length == 7 || x.length == 40):// git sha number
				results.push( x.trim() );
				
			case x if (x.indexOf('-') > -1):// date YYYY-MM-DD
				results.push( x.trim() );
				
			case x if (x.indexOf('.') > -1):// 3.2.0
				results.push( x.trim() );
				
			case _:
				
				
		}
		
		return results;
	}
	
	private function save():Void {
		Serializer.USE_CACHE = true;
		configIO.writeString( Serializer.run( configData ) );
	}
	
	public function exit():Void {
		save();
		configIO.close();
	}
	
}