package uhx.multi;

import haxe.ds.StringMap;
import uhx.multi.structs.Data;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class Neko extends Program {

	public function new(args:StringMap<Array<Dynamic>>, directory:String) {
		super( args, directory, 'neko' );
		@:cmd _;
	}
	
	
}