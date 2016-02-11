package uhx.multi.structs;

/**
 * @author Skial Bainn
 */
typedef StableVersions = {
	var current:String;
	var versions:Array<StableVersion>;
}

typedef StableVersion = {
	var version:String;
	var api:Bool;
	var tag:String;
	var date:String;
}