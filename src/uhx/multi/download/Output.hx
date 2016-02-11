package uhx.multi.download;

import haxe.io.Bytes;
import haxe.io.Output as HO;

/**
 * ...
 * @author Skial Bainn
 */
class Output extends haxe.io.Output {

	private var original:HO;
	private var progress:Progress;
	
	public function new(output:HO) {
		original = output;
		progress = new Progress();
		
	}
	
	private function update(value:Int):Void {
		progress.current += value;
		if (progress.hasNext()) progress.next();
	}
	
	override public function writeByte(c:Int):Void {
		original.writeByte(c);
		update(1);
	}
	
	override public function writeBytes(s:Bytes, pos:Int, len:Int):Int {
		var result = original.writeBytes(s, pos, len);
		update( result );
		return result;
	}
	
	override public function prepare(nbytes:Int) {
		progress.maximum = nbytes;
		//original.prepare(nbytes);
	}
	
	override public function close() {
		super.close();
		//original.close();
		progress.next();
	}
	
}