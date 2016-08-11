package uhx.multi;

import thx.DateTime;
import uhx.multi.Builds;
import thx.semver.Version;
import thx.format.DateFormat;

using StringTools;
using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
class Util {
	
	public static var builds:Array<String> = [Stable, Nightly];
	
	@:access(thx.semver.Version)
	public static function resolveVersion(value:String, ?recursive:Bool = false):Array<String> {
		var results = [];
		
		switch (value) {
			case _.startsWith( Stable ) => true:
				results.push( Stable );
				if (value.charCodeAt(6) == '-'.code) results = results.concat( resolveVersion( value.substring( 7 ), true ) );
				
			case _.startsWith( Nightly ) => true:
				results.push( Nightly );
				if (value.charCodeAt(7) == '-'.code) results = results.concat( resolveVersion( value.substr( 8 ), true ) );
				
			case x if (x.length == 7 || x.length == 40):// git sha number
				if (!recursive) results.push( Nightly );
				results.push( x.trim() );
				
			case x if (x.indexOf('-') > -1):// date YYYY-MM-DD
				if (!recursive) results.push( Stable );
				results.push( x.trim() );
				
			case x if (x.indexOf('.') > -1):// 3.2.0
				if (!recursive) results.push( Stable );
				results.push( x.trim() );
				
			case _:
				
				
		}
		
		return results;
	}
	
	public static function buildDirectory(path:String):Void {
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
	
	public static inline function format(date:DateTime):String {
		return DateFormat.format(date, 'ddd dd MMM');
	}
	
}
