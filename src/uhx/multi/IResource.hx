package uhx.multi;

//import haxe.Constraints.Constructible;

/**
 * @author Skial Bainn
 */
interface IResource {
  
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
	
}

/*typedef TResource<T:Constructible<String>> = {
	public var name(default, never):String;
	public var download(default, never):String;
	public var versions(default, never):String;
}*/