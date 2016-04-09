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
import uhx.multi.win.WindowsHelper;
import uhx.multi.win.WindowsHelper.*;
import uhx.multi.Util.*;
import uhx.multi.structs.Installation;
import thx.DateTimeUtc;
import uhx.sys.Ioe;

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
class LibRunner extends Ioe {
	
	public static function main() {
		if (Sys.systemName() == 'Windows') WindowsHelper.initialize();
		var librunner = new LibRunner( Sys.args() );
		librunner.exit();
	}
	
	@:native('haxe')
	public var _haxe:Haxe = Haxe.new.bind(_, directory);
	public var neko:Neko = Neko.new.bind(_, directory);
	
	@alias('u')
	public var update:Null<String>;
	
	@alias('r')
	public var reset:Bool = false;
	
	@alias('d')
	public var directory:Null<String>;
	
	@alias('l')
	public var local:Bool = false;

	public function new(args:Array<String>) {
		super();
		initialize();
		@:cmd _;
	}
	
	private function initialize():Void {
		
	}
	
	//@:access(thx.semver.Version)
	//private function process():Void {
		/*if (install != null) {
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
			
		}*/
		
	//}
	
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
		// TODO replace serializer, its too fragile.
		// TODO if data is corrupt, rebuild based on contents of /multi/ directory.
		Serializer.USE_CACHE = true;
		for (program in [_haxe, neko]) if (program != null) {
			program.save();
			
		} else {
			trace( 'program is null' );
		}
	}
	
	@:skip(cmd) override public function exit():Void {
		save();
		super.exit();
	}
	
}
