package uhx.multi.download;

/**
 * ...
 * @author Skial Bainn
 */
@:enum abstract Type(Int) from Int to Int {
	var Unknown = 0;
	var Nightly = 1;
	var Stable = 2;
	var Config = 3;
	var Resource = 4;
}