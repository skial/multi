package uhx.multi.haxe;

import haxe.Json;
import sys.io.Process;
import uhx.multi.structs.WindowsJson;

/**
 * ...
 * @author Skial Bainn
 */
class Util {
	
	public static var raw:WindowsJson = null;
	public static var is64BitOS(get, null):Bool;
	public static var userProfile(get, null):String;
	
	public static function init():Void {
		var process = new Process( 'Helper.exe', [] );
		raw = Json.parse( process.stdout.readAll().toString() );
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
	
}
