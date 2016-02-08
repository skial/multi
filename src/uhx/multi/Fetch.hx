package uhx.multi;

import haxe.Http;

/**
 * ...
 * @author Skial Bainn
 */
class Fetch {

	private var http:Http;
	
	public function new(url:String) {
		http = new Http( url );
	}
	
}