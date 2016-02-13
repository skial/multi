package uhx.multi;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import uhx.multi.download.Type;
import uhx.multi.haxe.Stable;
import uhx.multi.haxe.Nightly;
import uhx.multi.structs.Data;
import haxe.Constraints.Constructible;
import haxe.io.Output;
import haxe.Serializer;
import haxe.Unserializer;
import thx.semver.Version;
import uhx.multi.Util.*;
import uhx.multi.structs.Installation;
import thx.DateTimeUtc;

using StringTools;
using sys.io.File;
using haxe.io.Path;
using sys.FileSystem;
using thx.semver.Version;

//import uhx.multi.haxe.Resource.TResource;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class LibRunner {
	
	public static function main() {
		var librunner = new LibRunner( Sys.args() );
		librunner.exit();
	}
	
	@alias('b')
	public var backup:Bool = false;
	
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
		
		initialize();
		setup();
		if (backup) startBackup();
		if (install != null) process();
	}
	
	private function initialize():Void {
		Util.initialize();
	}
	
	private function setup():Void {
		config = '$userProfile/$config'.normalize();
		if (directory == null) directory = '$userProfile/multihaxe/'.normalize();
		trace( width, config, config.exists() );
		
		if (!config.exists()) {
			configData = new Data();
			config.saveContent( Serializer.run( configData ) );
			
		} else {
			try {
				configData = Unserializer.run( config.getContent() );
				
			} catch (e:Dynamic) {
				// TODO prompt user if its ok to wipe old data & start from stratch?
				throw e;
				
			}
			
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
					var handler = new Stable( this.directory, configData );
					trace( handler.exists( versions ) );
					trace( handler.get( versions ) );
					
				case ['nightly']:
					var handler = new Nightly( this.directory, configData );
					
					
				case ['stable', Version.VERSION.match(_) => true]: 
					var version = (versions[1]:Version);
					var handler = new Stable( this.directory, configData );
					trace( handler.exists( versions ) );
					trace( handler.get( versions ) );
					
				case ['nightly', _.length >= 7 => true]:
					
					
				case _:
					Sys.println( 'The version you provided, `' + versions.join('-') + '`, does not appear to exist.' );
					
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
	
	private function startBackup():Void {
		var envars = Sys.environment();
		var currentInstall = new Installation();
		var interested = ['HAXE_STD_PATH', 'HAXELIB_PATH', 'HAXEPATH'];
		
		for (interest in interested) if (envars.exists( interest )) {
			currentInstall.environment.set( interest, envars.get( interest ) );
			
		}
		
		// TODO sort default installation path based on platform.
		currentInstall.path = currentInstall.environment.exists( 'HAXEPATH' ) 
			? currentInstall.environment.get( 'HAXEPATH' )
			: '/HaxeToolkit/';
		currentInstall.fetched = currentInstall.installed = DateTimeUtc.now().toTime();
		currentInstall.type = Type.Local;
		
		configData.original = currentInstall;
	}
	
	public function ask(question:String, options:StringMap<Bool>):Bool {
		var stdin = Sys.stdin();
		var stdout = Sys.stdout();
		
		stdout.writeString( '$question\n' );
		var response = stdin.readLine();
		
		if (options.exists( response )) {
			return options.get( response );
			
		} else {
			return false;
			
		}
		
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