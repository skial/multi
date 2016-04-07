package uhx.multi.win;

import haxe.Json;
import sys.io.Process;
import uhx.multi.structs.WindowsJson;

/**
 * ...
 * @author Skial Bainn
 */
class WindowsHelper {

	public static var raw:WindowsJson = null;
	@:isVar public static var width(get, null):Int;
	public static var is64BitOS(get, null):Bool;
	public static var userProfile(get, null):String;
	
	public static function initialize():Void {
		var process = new Process( 'Helper.exe', [] );
		var string = process.stdout.readAll().toString();
		raw = Json.parse( string );
		process.exitCode();
		process.close();
	}
	
	private static function get_is64BitOS():Bool {
		return (raw != null) ? raw.is64Bit : false;
	}
	
	private static function get_userProfile():String {
		return (raw != null) ? 
			((raw.userProfile != '') ? raw.userProfile : Sys.environment().exists('USERPROFILE') ? Sys.getEnv('USERPROFILE') : raw.localApplicationData)
			: raw.localApplicationData;
	}
	
	private static function get_width():Int {
		if (width == null) width = raw.width != null ? raw.width : 80;
		return width;
	}
	
}