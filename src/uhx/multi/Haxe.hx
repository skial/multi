package uhx.multi;

import haxe.ds.StringMap;
import uhx.multi.haxe.Stable;
import uhx.multi.haxe.Nightly;
import uhx.multi.structs.Data;
import uhx.multi.structs.Download;

using sys.FileSystem;

/**
 * ...
 * @author Skial Bainn
 */
@:cmd
class Haxe extends Program {
	
	private var stable:Stable;
	private var nightly:Nightly;

	public function new(args:StringMap<Array<Dynamic>>, directory:String) {
		super( args, directory, 'haxe' );
		@:cmd _;
		setup();
		initialize();
		process();
	}
	
	private function initialize() {
		stable = new Stable( this.directory, this.configData );
		nightly = new Nightly( this.directory, this.configData );
	}
	
	override private function doInstall(info:Array<String>):Bool {
		var result = false;
		var resource:IResource = switch (info[0]) {
			case 'stable': stable;
			case 'nightly': nightly;
			case _: stable;
		}
		
		trace( info, stable.exists( info ) );
		
		if (resource.exists( info )) {
			var download = resource.get( info );
			configData.current = download;
			configData.downloads.push( download );
			
		}
		
		return result;
	}
	
	override private function doUnInstall(info:Array<String>):Bool {
		var result = false;
		var resource:IResource = switch (info[0]) {
			case 'stable': stable;
			case 'nightly': nightly;
			case _: stable;
		}
		
		trace( info );
		
		if (resource.exists( info )) {
			var index = -1;
			var description:Download = resource.describe( info );
			trace( configData.downloads );
			for (i in 0...configData.downloads.length) if (configData.downloads[i].path == description.path) {
				index = i;
				break;
				
			}
			trace( index );
			if (index > -1) {
				var download:Download = configData.downloads[index];
				trace( download );
				if (download.path.exists()) try {
					download.path.deleteFile();
					trace( 'deleted file' );
				} catch (e:Dynamic) {
					// Failed...
					trace( e );
					
				}
				
				configData.downloads = configData.downloads.filter( function(dl) return dl.path != download.path );
				
			}
			
		}
		
		return result;
	}
	
}
