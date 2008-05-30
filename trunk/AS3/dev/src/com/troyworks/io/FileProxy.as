/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.io {
	import flash.utils.flash_proxy;
	import flash.filesystem.*;
	import flash.utils.Proxy;
	
	dynamic public class FileProxy extends Proxy implements IFile{
		public var _file:File;
		
		public function FileProxy(path:String = null) {
			_file = new File(path);
		}
		public 	function get userDirectory() : IFile{
			var fp:FileProxy = new FileProxy();
			fp._file = File.userDirectory;
			
			return fp;
		}
		public function get name():String{
			return _file.name;
		}
		// override flash_proxy function getProperty(name:Object):Object {
		//	return null;
		//} 
		
	}
	
}
