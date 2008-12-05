package com.troyworks.io.fplib {
	import com.troyworks.io.fplib.IFileListEvent;
	import com.troyworks.io.fplib.IFileStream;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;	

	public class IFile extends EventDispatcher
	{
		// Flash.filesystem.File properties		
		public var creationDate:Date;
		public var creator:String;
		public var exists:Boolean = false;
		public var extension:String;
		public var icon;
		public var isDirectory:Boolean;
		public var isHidden:Boolean = false;
		public var isPackage:Boolean = false;
		public var isSymbolicLink:Boolean = false;
		public var lineEnding:String = "\n";
		public var modificationDate:Date;
		public var name:String;
		public var nativePath:String;
		public var parent:IFile;
		public static var separator:String = '/';
		public var size:Number;
		public static var systemCharset:String = 'UTF8';
		public var type:String;
		public var url:String;
		
		// The following are lazy loaded through getter methods
		//public static var applicationDirectory:IFile;
		//public static var applicationStorageDirectory:IFile;		
		//public static var desktopDirectory:IFile;
		//public static var documentsDirectory:IFile;
		//public static var userDirectory:IFile;
		
		// Internal properties for the getter methods
		protected static var _applicationDirectory:IFile;
		protected static var _applicationStorageDirectory:IFile;
		protected static var _desktopDirectory:IFile;
		protected static var _documentsDirectory:IFile;
		protected static var _userDirectory:IFile;
		
		// Custom properties		
		protected static var baseUrl:String;
		public var relUrl:String;
		protected static var synchronousError:String = "Synchronous operations are not available in this implementation. Please use [method]Async() version instead.";
		//protected var synchronousError:String = "Synchronous operations are not available in this implementation. Please use [method]Async() version instead."
		protected var fileStreams:Array = new Array;
		protected var fileStreamSeq:uint = 0;
		protected var fstatus:URLLoader;
		protected var fileActions:Array = new Array;
		protected static var tmpDir:String = 'tmp';
		
		// Event constants
		public static const STATUS = 'fileStatus';		
		
		/*
		 * The constructor creates a new instance based on the provided string path or array
		 * with a set of predefined properties that will be used instead of querying through 
		 * an external request. The latter is used in for example getDirectoryListing() because
		 * we don't want to end up sending tens of requests at once to query each file individually.
		 */
		public function IFile(pathOrArgs:* = '', fsCallback:Function = null)
		{
			// Determine "path" variable type
			if (typeof(pathOrArgs) == 'string') {			

				var path:String = pathOrArgs;
			
				// Determine if url is absolute or relative
				if (path.substr(0, 7) == 'http://') {
					this.relUrl = path.replace(IFile.baseUrl, '');
					this.url = path;
				} else {
					this.relUrl = path;
					this.url = IFile.baseUrl + path;
				}
				trace("IFile url " + this.url);
				// Attach event listener
				if (fsCallback != null) {
					this.addEventListener(IFile.STATUS, fsCallback);
				}

				// Fetch file status
				this.getFileStatus();
				
			} else {

				// "path" is an array
				var args:Array = pathOrArgs;
				
				this.relUrl = args['path'];
				this.url = IFile.baseUrl + args['path'];
				
				this.exists = true;
				this.size = int(args['size']);
				this.isSymbolicLink = (args['link'] == '1');
				this.isDirectory = (args['directory'] == '1');
				
				var aDate:Date = new Date;
				aDate.time = int(args['ctime']) * 1000;
				this.creationDate = aDate;
				aDate.time = int(args['mdate']) * 1000;
				this.modificationDate = aDate;
			}
			
			// Generate this.name & this.extension
			var sUrl:String = this.relUrl;
			var lastPartRgx:RegExp = new RegExp("([^/]+)/?$","g");			
			var parts:Object = lastPartRgx.exec(sUrl);
			
			// Regex match failed
			if (!parts) {
				return;
			}
			
			this.name = parts[1];
			
			if (this.isDirectory !== true) {
				var nameRgx:RegExp = new RegExp("(.+)\\.([^\\.]+)$","g");
				var nameParts:Object = nameRgx.exec(parts[1]);
				if (nameParts) {
					// nameParts[1]: name without extension
					this.extension = nameParts[2];
				}
			}
		}
		
		public function getFileStatus():void
		{
			fstatus = new URLLoader;
			fstatus.addEventListener(Event.COMPLETE, onFileStatusComplete);
			fstatus.load(new URLRequest(this.url + '?mode=stat'));			
		}
		
		public function onFileStatusComplete(ev:Event):void
		{
			// Parse data & set file properties			
			var lineRgx:RegExp = /([^:]+): ([^\n]+)\n/mg;
			var parts:Array = new Array;
			var result:Array;
			var a:String = '';
	
			while (result = lineRgx.exec(fstatus.data))
			{
				parts[result[1]] = result[2];
			}
			
			this.exists = Boolean(parts['exists']);
			this.size = int(parts['size']);
			this.isSymbolicLink = (parts['link'] == '1');
			this.isDirectory = (parts['directory'] == '1');
			
			var aDate:Date = new Date;
			aDate.time = int(parts['ctime']) * 1000;
			this.creationDate = aDate;
			aDate.time = int(parts['mdate']) * 1000;
			this.modificationDate = aDate;
			
			this.dispatchEvent(new Event(IFile.STATUS));
		}
		
		public static function get applicationDirectory():IFile
		{
			if (IFile._applicationDirectory == null) {
				IFile._applicationDirectory = new IFile('');
			}			
			return IFile._applicationDirectory;
		}
		
		public static function get applicationStorageDirectory():IFile
		{
			if (IFile._applicationStorageDirectory == null) {
				IFile._applicationStorageDirectory = new IFile('');
			}			
			return IFile._applicationStorageDirectory;
		}
		
		public static function get desktopDirectory():IFile
		{
			if (IFile._desktopDirectory == null) {
				IFile._desktopDirectory = new IFile('');
			}			
			return IFile._desktopDirectory;
		}
		
		public static function get documentsDirectory():IFile
		{
			if (IFile._documentsDirectory == null) {
				IFile._documentsDirectory = new IFile('');
			}			
			return IFile._documentsDirectory;
		}
		
		public static function get userDirectory():IFile
		{
			if (IFile._userDirectory == null) {
				IFile._userDirectory = new IFile('');
			}			
			return IFile._userDirectory;
		}
		
		public static function setBasePath(url:String):void
		{
			IFile.baseUrl = url;
		}
		
		public function cancel():void
		{
			for (var i in this.fileStreams) {
				this.fileStreams[i].cancel();
			}
		}
		
		/*
		 * This function would normally adjust the path so that it matches the case of the actual file
		 * and substitute the target path url if it was a symbolic link. However the url is alread case
		 * sensitive and links should not be resolved since they might not be inside the base url (thus
		 * not being accessible) so this function ends up not changing the path.
		 */
		public function canonicalize():void
		{}
		
		/*
		 * Clone should be able to return an IFile object, but I'm out of ideas how to accomplish that.
		 * It seems going through the ByteArray casts IFile to a generic Object and reversing that isn't
		 * possible.
		 *
		 * TODO: Need to investigate if any object members need to be reset here.
		 */
		public function clone():Object
		{
			var objCopy:ByteArray = new ByteArray();
		    objCopy.writeObject(this);
		    objCopy.position = 0;
			var aNewFile = objCopy.readObject();
		    return aNewFile;
		}
		
		public function copyToAsync(newLocation:IFile, overwrite:Boolean = false):void
		{
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'copy';
			params['overwrite'] = overwrite ? '1' : '0';
			
			// Remove base url from newLocation
			params['dst'] = newLocation.url;						
			params['dst'] = params['dst'].replace(IFile.baseUrl, '');
			
			this.sendRequest(params);
		}
		
		public function createDirectoryAsync():void
		{
			if (this.exists === true && this.isDirectory === true) {
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'mkdir';
			this.sendRequest(params);
		}
		
		/*
		 * Create a standard directory. You need to implement the logic yourself to
		 * make it a temporary one.
		 */
		public static function createTempDirectoryAsync():IFile
		{
			var dirLength:uint = 12;
			var dirName:String = IFile.generateRandomString(dirLength);
			var tmpDir = IFile.applicationDirectory.resolvePath(IFile.tmpDir + '/' + dirName);
			tmpDir.addEventListener(IFile.STATUS, IFile.onCreateTempDirectoryStatus);			
			return tmpDir;
		}
		
		protected static function onCreateTempDirectoryStatus(ev:Event):void
		{
			ev.target.createDirectoryAsync();
		}
		
		/*
		 * Create a standard file in the this.tmpDir directory
		 */
		public static function createTempFileAsync():IFile
		{
			var filenameLength:uint = 12;
			var fileName:String = IFile.generateRandomString(filenameLength);
			var tmpFile = IFile.applicationDirectory.resolvePath(IFile.tmpDir + '/' + fileName);
			tmpFile.addEventListener(IFile.STATUS, IFile.onCreateTempFileStatus);			
			return tmpFile;
		}
		
		public static function onCreateTempFileStatus(ev:Event):void
		{
			// Touch() will make the file dispatch an Event.COMPLETE event
			ev.target.touch();
		}
		
		/*
		 * Creates a random string for use with temporary files and directories
		 */
		protected static function generateRandomString(length:uint):String
		{
			var validChars:String = 'qwertyuiopasdfghjklzxcvbnm1234567890';
			var str:String = '';
			
			for (var i:int = 0; i < length; i++) {
				str = str + validChars.charAt(Math.random() * (validChars.length - 1));
			}
			
			return str;
		}
		
		/*
		 * Sends an unversal request
		 */
		private function sendRequest(params:Array = null, callback:Function = null):void
		{
			var ul:URLLoader = new URLLoader;
			
			// Revert to default listener when callback parameter not set
			if (callback == null) {
				callback = this.onResponse;
			}
			
			// Construct url from the params array, pop key 'url' for base url
			url = params['url'];
			delete params['url'];
			
			// Append a random part to disable caching
			params['rts'] = Math.floor(Math.random() * 1000000);
			
			var pairs:Array = new Array;
			for (var i:* in params) {
				pairs.push(i + '=' + escape(params[i]));
			}
			var ur:URLRequest = new URLRequest(url + '?' + pairs.join('&'));
			
			// URLRequest.data can't be empty for POST request (otherwise resets to GET)
			if (params['request'] == 'post' || params['request'] == null) {
				ur.data = new ByteArray;
				ur.method = 'post';
			}
			delete params['request'];
			
			ul.addEventListener(Event.COMPLETE, callback);
			ul.addEventListener(IOErrorEvent.IO_ERROR, onError);
			ul.load(ur);
		}
		
		/*
		 * Response event listener. Forwards the event to IFile listeners and the target
		 * property is set to this IFile instance.
		 */
		protected function onResponse(ev:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/*
		 * IOErrorEvent listener. Forwards the event to IFile listeners and the target
		 * property is set to this IFile instance.
		 */
		protected function onError(ev:Event):void
		{
			this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		/*
		 * Delete a directory, optionaly with contents
		 */
		public function deleteDirectoryAsync(deleteDirectoryContents:Boolean = false):void
		{
			if (this.exists !== true || this.isDirectory !== true) {
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				return;
			}
			
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'delete';
			params['rf'] = deleteDirectoryContents ? '1' : '0';
			this.sendRequest(params, onDelete);
		}
		
		/*
		 * Fetch list of directory contents
		 */
		public function getDirectoryListingAsync():void
		{
			if (this.exists !== true || this.isDirectory !== true) {
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				return;
			}
			
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'list';
			params['request'] = 'get';
			this.sendRequest(params, onDirectoryListing);
		}
		
		/*
		 * Parse directory contents and dispatch appropriate event
		 */
		protected function onDirectoryListing(ev:Event)
		{
			// Parse response file list
			var files:Array = new Array;
			
			var lineRgx:RegExp = /(.+)\n\n/mg;
			var result:Array;
			
			var parts:Array = ev.target.data.split("\n\n");
			var fileParts:Array;
			var fileParams:Array;
			
			for (var i:* in parts) {
				fileParts = parts[i].split("\n");
				
				// Relative path
				var rpath:String = this.url + '/' + fileParts[0];
				rpath = rpath.replace(IFile.baseUrl, '');
				
				fileParams = new Array();
				fileParams['path'] = rpath;
				fileParams['directory'] = fileParts[1];
				fileParams['link'] = fileParts[2];
				fileParams['size'] = fileParts[3];
				fileParams['atime'] = fileParts[4];
				fileParams['mtime'] = fileParts[5];
				fileParams['ctime'] = fileParts[6];
				files.push(new IFile(fileParams));
			}
			
			// Dispatch an DIRECTORY_LISTING FileListEvent
			var fle:IFileListEvent = new IFileListEvent(IFileListEvent.DIRECTORY_LISTING);
			fle.files = files;
			this.dispatchEvent(fle);
		}
		
		//public function getRootDirectories():Array {}
		
		public function moveToAsync(newLocation:IFile, overwrite:Boolean = false):void
		{
			if (this.exists !== true) {
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				return;
			}
			
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'move';
			params['overwrite'] = overwrite ? '1' : '0';

			// Remove base url from newLocation
			params['dst'] = newLocation.url;						
			params['dst'] = params['dst'].replace(IFile.baseUrl, '');
			
			// When moved, the original files are deleted hence the onDelete callback
			this.sendRequest(params, onDelete);
		}
		
		/*
		 * Trashing a file just deletes it for the time being. Ideally you should implement
		 * your own trash solution and probably add a emptyTrashAsync() method.
		 */
		public function moveToTrashAsync():void
		{
			if (this.exists !== true) {
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				return;
			}
			
			if (this.isDirectory === true) {
				this.deleteDirectoryAsync(true);
			} else {
				this.deleteFileAsync();
			}
		}

		public function deleteFileAsync():void
		{
			trace("deleteFileAsynch");
			if (this.exists !== true || this.isDirectory === true) {
				trace("sending IO ERROR " + this.exists);
				this.dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				return;
			}
			trace("deleteFileAsynch...sending");
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'delete';
			this.sendRequest(params, onDelete);
		}
		
		protected function onDelete(ev:Event):void
		{
			this.exists = false;
			this.isDirectory = false;
			this.modificationDate = null;
			this.creationDate = null;
			this.size = 0;
			
			// Proceed to redispatching the event
			this.onResponse(ev);
		}
		
		public function resolvePath(path:String):IFile
		{
			var rsUrl:String = this.relUrl.length ? this.relUrl + '/' + path : path;
			rsUrl = rsUrl.replace(/\/{2,}/, '/');
			var file:IFile = new IFile(rsUrl);
			return file;
		}
		
		public function attachStream(stream:IFileStream)
		{			
			var id:uint = ++this.fileStreamSeq;
			this.fileStreams[id] = stream;
			stream.id = id;
		}
		
		public function detachStream(stream:IFileStream)
		{
			this.fileStreams[stream.id] = null;
		}
		
		public function touch()
		{
			var params:Array = new Array;
			params['url'] = this.url;
			params['mode'] = 'touch';
			this.sendRequest(params);			
		}
		
		/*
		 * Synchornous file functions - block by throwing exception
		 */
		
		public function copyTo(newLocation:FileReference, overwrite:Boolean = false):void
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public function deleteDirectory(deleteDirectoryContents:Boolean = false):void
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public function deleteFile():void
		{
			throw new IllegalOperationError(synchronousError);
		}

		public function getDirectoryListing():Array
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public function moveTo(newLocation:FileReference, overwrite:Boolean = false):void
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public function moveToTrash():void
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public function createDirectory():void
		{
			throw new IllegalOperationError(synchronousError);
		}
		
		public static function createTempDirectory():IFile
		{
			throw new IllegalOperationError(IFile.synchronousError);
		}
		
		public static function createTempFile():IFile
		{
			throw new IllegalOperationError(IFile.synchronousError);
		}
		
		/*
		 * TODO: Implement in next phase
		 */
		
		//public function browseForDirectory(title:String):void {}		
		//public function browseForOpen(title:String, typeFilter:Array = null):void {}
		//public function browseForOpenMultiple(title:String, typeFilter:Array = null):void {}
		//public function browseForSave(title:String):void {}
		//public function getRelativePath(ref:IFile, useDotDot:Boolean = false):String {}
	}
}