package uhx.multi;

/**
 * ...
 * @author Skial Bainn
 */
@:enum abstract Builds(String) from String to String {
	public var Stable = 'stable';
	public var Nightly = 'nightly';
}