package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.troyworks.util.ExternalLibrary;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.system.Capabilities;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import com.adobe.images.JPGEncoder;
	import flash.display.BitmapData;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class SaveWebcamImage extends Sprite
	{		
	
		// Image data
		public var curFileName:String;
		public var status_txt:TextField;
		public var image_ph:MovieClip;
		public var nav_txt:TextField;
		public var vid:Video;
		public var imgData:ByteArray;
		public var bitmapData:BitmapData = new BitmapData(160, 120, true, 0);  
		var _loader:Loader;
		
		public function SaveWebcamImage():void
		{
			if (Capabilities.playerType == 'Desktop') {
				ExternalLibrary.loadAirLib(init);
			} else {
				ExternalLibrary.loadPlayerLib(init);
			}
		}

		protected function init(ev:Event):void
		{
		//	parent.addEventListener(MouseEvent.CLICK, onMOUSE_CLICK);

			var cam:Camera = Camera.getCamera();
			vid = new Video();
			vid.attachCamera(cam);
			addChild(vid);
			trace("Status: loading remote image ");
			nav_txt.addEventListener(TextEvent.LINK, onTextLink);
			updateNav();
			
		}

		public function getHyperLink(action, lbl) : String {
			var lnkr:Array = new Array();
			var hasDeeplink:Boolean = true;// deeplink != null && deeplink != "";
			if(hasDeeplink){
			lnkr.push("<a name='");
			lnkr.push(action);
			lnkr.push("' href='event:");
			lnkr.push(action);
			lnkr.push("' target='mainFrame'>");
			}
			lnkr.push(lbl);
			if(hasDeeplink){
				lnkr.push("</a>");
			}
			var res:String = lnkr.join('');
			return res;
		}
		protected function onTextLink(ev:TextEvent):void
		{
			trace(ev.text + " onTextLink");
			switch(ev.text)
			{
				case "create":
				   createSnapshot(true);
				break;
				case "read":
				   readSnapshot();
				break;
				case "update":
				   createSnapshot();
				break;
				case "delete":
				   deleteSnapshot();
				break;

			}
			
		}
		protected function createSnapshot(newname:Boolean = false):void{
			// dest is a movieclip on stage
			bitmapData.draw(vid);
		
			//trace(ev.target.content.bitmapData);
			var jpgEncoder:JPGEncoder = new JPGEncoder(85);
			this.imgData = jpgEncoder.encode(bitmapData);
			
			// iFile is the definition of file.flash.filesystem.File (static)
			var iFile = ExternalLibrary.static('IFile');
			if(newname){
				var timesmp:Number = new Date().getTime() ;
				curFileName = 'webcam_' + timesmp + '.jpg';
			}
			var aFile = iFile.desktopDirectory.resolvePath(curFileName);
			aFile.addEventListener(iFile.STATUS, onCreateSnapshotStatus);
			trace("Status: image captured ");
			updateNav();
		
		}	
		protected function onCreateSnapshotStatus(ev:Event):void
		{
			var aFile = ev.target;
			trace("onCreateSnapshotStatus: writing snapshot ");
			
			var aStream = ExternalLibrary.create('IFileStream');
			var iFileMode = ExternalLibrary.static('IFileMode');
	
			aStream.addEventListener(Event.CLOSE, onClose);			
			aStream.openAsync(aFile, iFileMode.WRITE);
			aStream.writeBytes(this.imgData);
			aStream.close();
		}
		protected function updateNav():void
		{
			var res:Array = new Array();
			res.push("Snapshot: ");
			res.push(getHyperLink("create", "create"));
			if(curFileName != null){
				res.push( getHyperLink("read", "read"));
				res.push(getHyperLink("update", "update"));
				res.push(getHyperLink("delete", "delete"));
			}
			nav_txt.htmlText =   res.join("      ");
				
		}
		protected function readSnapshot(evt:Event = null):void
		{
			/////////////////////////////////////
			_loader = new Loader();
			var iFile = ExternalLibrary.static('IFile');
			var aFile = iFile.desktopDirectory.resolvePath(curFileName);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImageLoadHandler);
			var request:URLRequest = new URLRequest(aFile.url);
			_loader.load(request);

			// addChild(_loader);
		}

		function completeImageLoadHandler(event:Event):void {
			trace("completed loading image ");
			var clip:Bitmap = Bitmap(Loader(event.target.loader).content);
			clip.x = clip.y = image_ph.numChildren * 10;
			
			while (image_ph.numChildren > 1)
			{
				trace("removing previous snapshot");
				image_ph.removeChildAt(1);
			}
			//clip.width = image_ph.width;
		//	clip.height = image_ph.height;
			image_ph.addChild(clip);
		}

		protected function deleteSnapshot(evt:Event = null):void
		{
			// iFile is the definition of file.flash.filesystem.File (static)
			var iFile = ExternalLibrary.static('IFile');
			var aFile = iFile.desktopDirectory.resolvePath(curFileName);
			aFile.addEventListener("fileStatus", onRecievedStatus);
			aFile.getFileStatus();
		}
		protected function onRecievedStatus(ev:Event):void
		{
			ev.target.deleteFileAsync();
		}
		

		
		protected function trace(msg:String):void
		{
				status_txt.appendText("\r" + msg);
		}
		
		protected function onClose(ev:Event):void
		{
			trace("Status: remote File written locally successfully ");

		}
	}
}