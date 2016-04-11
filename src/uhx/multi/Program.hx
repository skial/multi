package uhx.multi;

import haxe.io.Output;
import haxe.Serializer;
import thx.DateTimeUtc;
import haxe.ds.StringMap;
import haxe.Unserializer;
import sys.io.FileOutput;
import uhx.multi.structs.Data;
import uhx.multi.download.Type;
import uhx.multi.win.WindowsHelper.*;
import uhx.multi.structs.Installation;

using sys.io.File;
using StringTools;
using haxe.io.Path;
using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class Program {
	
	@alias('i')
	public var install:Null<String>;
	
	@alias('u')
	public var uninstall:Null<String>;
	
	@alias('r')
	public var reinstall:Null<String>;
	
	@alias('c')
	public var config:String;
	
	private var name:String = '';
	private var configData:Data;
	private var configIO:Output;
	private var directory:String;

	public function new(args:Array<String>, directory:String, name:String) {
		this.name = name;
		this.config = '.multi$name';
		this.directory = directory;
		@:cmd !_;	// Hint to `Ede` that I don't want the auto generated method `::edeProcessArgs` inserted and called.
	}
	
	@alias('a')
	public function available():Void {
		throw 'Not implemented';
	}
	
	private function setup():Void {
		config = '$userProfile/$config'.normalize();
		if (directory == null) directory = '$userProfile/multi$name/'.normalize();
		trace( config, directory, config.exists() );
		if (!config.exists()) {
			configData = new Data();
			trace( configData, Serializer.run( configData ) );
			config.saveContent( Serializer.run( configData ) );
			
		} else {
			try {
				configData = Unserializer.run( config.getContent() );
				
			} catch (e:Dynamic) {
				// TODO prompt user if its ok to wipe old data & start from stratch?
				trace( e );
				configData = new Data();
				trace( configData, Serializer.run( configData ) );
				config.saveContent( Serializer.run( configData ) );
				
			}
			
		}
		
		if (configData.original == null) backup();
		
		configIO = config.write();
		
		if (!directory.exists()) directory.createDirectory();
	}
	
	private function process():Void {
		trace( install, uninstall, reinstall );
		var info = [];
		
		if (install != null) {
			info = findVersion( install );
			doInstall( info );
			
		} else if (reinstall != null) {
			info = findVersion( reinstall );
			doUnInstall( info );
			doInstall( info );
			
		} else if (uninstall != null) {
			info = findVersion( uninstall );
			doUnInstall( info );
			
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
	
	private function backup():Void {
		var env = Sys.environment();
		var currentInstall = new Installation();
		var interested = ['HAXE_STD_PATH', 'HAXELIB_PATH', 'HAXEPATH', 'LD_LIBRARY_PATH', 'NEKOPATH'];
		
		for (interest in interested) if (env.exists( interest )) {
			currentInstall.environment.set( interest, env.get( interest ) );
			
		}
		
		// TODO sort default installation path based on platform.
		currentInstall.path = currentInstall.environment.exists( 'HAXEPATH' ) 
			? currentInstall.environment.get( 'HAXEPATH' )
			: '/HaxeToolkit/haxe/';
		currentInstall.fetched = currentInstall.installed = DateTimeUtc.now().toTime();
		currentInstall.type = Type.Local;
		
		configData.original = currentInstall;
	}
	
	private function doInstall(info:Array<String>):Bool {
		throw 'Not implemented';
		return false;
	}
	
	private function doUnInstall(info:Array<String>):Bool {
		throw 'Not implemented';
		return false;
	}
	
	@:skip(cmd) public function save():Void {
		trace( Serializer.run( configData ) );
		configIO.writeString( Serializer.run( configData ) );
		
	}
	
}
