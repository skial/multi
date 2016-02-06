package uhx.multi.haxe;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class LibRunner {
	
	public static function main() {
		var librunner = new LibRunner( Sys.args() );
	}
	
	@alias('i')
	public var install:Null<String>;
	
	@alias('u')
	public var update:Null<String>;
	
	@alias('x')
	public var uninstall:Null<String>;
	
	@alias('r')
	public var reset:Bool = false;

	public function new(args:Array<String>) {
		@:cmd _;
		
		process();
	}
	
	private function setup():Void {
		
	}
	
	private function process():Void {
		if (install != null) {
			switch (install) {
				case 'stable':
					
					
				case 'nightly':
					
					
				case x if (x.length == 7 || x.length == 40):// git sha number
					
					
				case x if (x.indexOf('-') > -1):// date YYYY-MM-DD
					
					
				case _:
					
					
			}
			
		}
		
	}
	
}