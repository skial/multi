package uhx.multi.cs;

import haxe.Json;
import cs.system.Environment;
import uhx.multi.structs.WindowsJson;

/**
 * ...
 * @author Skial Bainn
 */
class Helper {
	
	public static function main() {
		var is64bit = try Environment.Is64BitOperatingSystem catch(e:Dynamic) false;
		var appdata = try Environment.GetFolderPath( Environment_SpecialFolder.ApplicationData ) catch(e:Dynamic) '';
		var common_appdata = try Environment.GetFolderPath( Environment_SpecialFolder.CommonApplicationData ) catch(e:Dynamic) '';
		var local_appdata = try Environment.GetFolderPath( Environment_SpecialFolder.LocalApplicationData ) catch(e:Dynamic) '';
		var userprofile = try Environment.GetFolderPath( Environment_SpecialFolder.UserProfile ) catch(e:Dynamic) '';
		
		Sys.println( Json.stringify( ({ 
			is64Bit: is64bit, applicationData: appdata, commonApplicationData: common_appdata,
			localApplicationData: local_appdata, userProfile: userprofile
		}:WindowsJson) ) );
	}
	
}
