package
{
	import flash.display.Sprite;
	import com.troyworks.util.ExternalLibrary;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import com.adobe.images.JPGEncoder;
	
	public class SaveImage extends Sprite
	{		
		// Change this to your own domain
		protected var imgUrl:String = 'http://blaze.dnc.pl/~tw/flash_cs3_logo.jpg';
	
		// Image data
		protected var imgData:ByteArray;

		public function SaveImage():void
		{
			if (Capabilities.playerType == 'Desktop') {
				ExternalLibrary.loadAirLib(init);
			} else {
				ExternalLibrary.loadPlayerLib(init);
			}
		}

		protected function init(ev:Event):void
		{
			var request:URLRequest = new URLRequest(this.imgUrl);
			var loader:Loader = new Loader;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImgLoad);
			loader.load(request);
			this.addChild(loader);
		}

		protected function onImgLoad(ev:Event):void
		{
			//trace(ev.target.content.bitmapData);
			var jpgEncoder:JPGEncoder = new JPGEncoder(85);
			this.imgData = jpgEncoder.encode(ev.target.content.bitmapData);
			
			// iFile is the definition of file.flash.filesystem.File (static)
			var iFile = ExternalLibrary.static('IFile');
			var aFile = iFile.desktopDirectory.resolvePath('flash-logo.jpg');
			aFile.addEventListener(iFile.STATUS, onStatus);
		}
		
		protected function onStatus(ev:Event):void
		{
			var aFile = ev.target;
			
			var aStream = ExternalLibrary.create('IFileStream');
			var iFileMode = ExternalLibrary.static('IFileMode');
	
			aStream.addEventListener(Event.CLOSE, onClose);			
			aStream.openAsync(aFile, iFileMode.WRITE);
			aStream.writeBytes(this.imgData);
			aStream.close();
		}
		
		protected function onClose(ev:Event):void
		{
			trace('file written to disk');
		}
	}
}