package uhx.multi;

import uhx.multi.Builds;
import thx.semver.Version;

using StringTools;

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
	
}
