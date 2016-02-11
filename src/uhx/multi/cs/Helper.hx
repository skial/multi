package uhx.multi.cs;

import haxe.Json;

import cs.Out;
import cs.types.Int16;
import cs.system.IntPtr;
import cs.system.Console;
import cs.system.Environment;
import uhx.multi.structs.WindowsJson;

/**
 * ...
 * @author Skial Bainn
 */
@:classCode(
'[global::System.Runtime.InteropServices.DllImportAttribute("kernel32.dll")]
	static extern bool GetConsoleScreenBufferInfo(global::System.IntPtr hConsoleOutput,  out CONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo);

	
	[global::System.Runtime.InteropServices.DllImportAttribute("kernel32.dll", SetLastError = true)]
	static extern global::System.IntPtr GetStdHandle(int nStdHandle);
	
	
'
)
class Helper {
	
	public static function main() {
		var is64bit = try Environment.Is64BitOperatingSystem catch(e:Dynamic) false;
		var appdata = try Environment.GetFolderPath( Environment_SpecialFolder.ApplicationData ) catch(e:Dynamic) '';
		var common_appdata = try Environment.GetFolderPath( Environment_SpecialFolder.CommonApplicationData ) catch(e:Dynamic) '';
		var local_appdata = try Environment.GetFolderPath( Environment_SpecialFolder.LocalApplicationData ) catch(e:Dynamic) '';
		var userprofile = try Environment.GetFolderPath( Environment_SpecialFolder.UserProfile ) catch(e:Dynamic) '';
		
		var width = 80;
		var height = 25;
		
		try {
			var buffer:CONSOLE_SCREEN_BUFFER_INFO = null;
			if (NativeHelper.GetConsoleScreenBufferInfo( NativeHelper.GetStdHandle( -11 ), buffer )) {
				width = buffer.dwSize.X;
				height = buffer.dwSize.Y;
				
			}
			
		} catch (e:Dynamic) {
			trace(e);
		}
		
		Sys.println( Json.stringify( ( { 
			width: width, height: height,
			is64Bit: is64bit, applicationData: appdata, commonApplicationData: common_appdata,
			localApplicationData: local_appdata, userProfile: userprofile
		}:WindowsJson) ) );
	}
	
}

@:native('uhx.multi.cs.Helper')
extern class NativeHelper {
	
	@:strict(DllImportAttribute("kernel32.dll"))
	public static function GetConsoleScreenBufferInfo(hConsoleOutput:IntPtr, lpConsoleScreenBufferInfo:Out<CONSOLE_SCREEN_BUFFER_INFO>):Bool;
	
	@:strict(DllImportAttribute("kernel32.dll", SetLastError = true))
	public static function GetStdHandle(nStdHandle:Int):IntPtr;
	
}

@:struct @:nativeGen class COORD {
	public var X:Int16;
	public var Y:Int16;
	
	public function new(x:Int16, y:Int16) {
		X = x;
		Y = y;
	}
}

@:struct @:nativeGen class SMALL_RECT {
	public var Left:Int16;
	public var Top:Int16;
	public var Right:Int16;
	public var Bottom:Int16;
	
	public function new(left:Int16, top:Int16, right:Int16, bottom:Int16) {
		Left = left;
		Top = top;
		Right = right;
		Bottom = bottom;
	}
}

@:struct @:nativeGen class CONSOLE_SCREEN_BUFFER_INFO {
	public var dwSize:COORD;
	public var dwCursorPosition:COORD;
	public var wAttributes:Int16;
	public var srWindow:SMALL_RECT;
	public var dwMaximumWindowSize:COORD;
	
	public function new(dwSize:COORD, dwCursorPosition:COORD, wAttributes:Int16, srWindow:SMALL_RECT, dwMaximumWindowSize:COORD) {
		this.dwSize = dwSize;
		this.dwCursorPosition = dwCursorPosition;
		this.wAttributes = wAttributes;
		this.srWindow = srWindow;
		this.dwMaximumWindowSize = dwMaximumWindowSize;
	}
}