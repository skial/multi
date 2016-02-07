package uhx.multi.haxe;

//import haxe.Constraints.Constructible;

/**
 * @author Skial Bainn
 */
interface Resource {
  
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
	
}

/*typedef TResource<T:Constructible<String>> = {
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
}*/