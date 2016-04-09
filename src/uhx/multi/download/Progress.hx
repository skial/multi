package uhx.multi.download;

import thx.unit.digital.Byte;
import uhx.multi.win.WindowsHelper.*;

using Thx;

/**
 * ...
 * @author Skial Bainn
 */
class Progress {

	public var current:Int = 0;
	public var maximum:Int = 100;
	
	public function new() {
		
	}
	
	public function hasNext():Bool {
		return current < maximum;
	}
	
	public function next():Void {
		var currentMeg = (current:Byte).toMegabyte().toString();
		var maximunMeg = (maximum:Byte).toMegabyte().toString();
		var columns = (width - 6) - currentMeg.length - maximunMeg.length;
		var loaded = (Std.int((current / maximum) * columns));
		var remainder = (columns - (Std.int((current / maximum) * columns)));
		
		Sys.stdout().writeString( 
			'[' + [for (i in 0...loaded) '='].join('') + [for (i in 0...remainder) ' '].join('') + '][' + currentMeg + '/' + maximunMeg + ']' + '\r'
		);
		
	}
	
	public function iterator():Iterator<Void> {
		return this;
	}
	
}
