/**
* ...
* @author Default
* @version 0.1
*/

package  {
	import flash.display.Sprite;
	import flash.filesystem.*;
	import com.troyworks.data.ArrayY;
	import flash.utils.ByteArray;
	import flash.events.*;
	import flash.display.*;
	
	import com.troyworks.framework.CollectionManager;

	public class TroyWorks_SerializationTest extends Sprite{
		
		public function TroyWorks_SerializationTest() {
		//	loadImage();
			var oo:Object = createObj();
			var bA:ByteArray = saveObjToByteArray(oo);
			var o2:Object = reloadFromByteArray(bA);
			trace("restored " + o2 + " " + (o2 is Array) + " ArrayY " + (o2 is ArrayY));
			trace("sliceX " + o2.sliceX);
			
			
		
		}
		function createObj():Object{
			var aX:ArrayY = new ArrayY();
			aX.push("A");
			aX.push("B");
			aX.push("C");
			trace("created " + aX + " sliceX " + aX.sliceX);
			
			var aY:ArrayY = aX.clone();
			trace("cloned: " + aY + " sliceX " + aY.sliceX);
			return aX;
			
		}
		function saveObjToByteArray(obj:Object):ByteArray{
			trace("saving to byteArray " + obj  +  " sliceX " + obj.sliceX);
			var bA:ByteArray = new ByteArray();
			bA.writeObject(obj as ArrayY);
			return bA;
		}
		function reloadFromByteArray(bA:ByteArray):Object{
			bA.position = 0;
			var obj:Object = bA.readObject() as Array;
			trace("reloadFrom byteArray " + obj + " sliceX " + obj.sliceX);
			return obj;

		}

		/*function saveToDisk():void{

			trace("url " + this.loaderInfo.url);
			trace("appDir " + File.applicationDirectory.nativePath );
			//trace("appRDir " + File.applicationResourceDirectory.nativePath );
			var file:File = File.applicationDirectory.resolvePath( "example.jpg" );
			trace("file " + file.url + " " +file.nativePath );
			var wr:File = new File(file.nativePath);
			// Create a stream and open the file for asynchronous reading
			var stream:FileStream = new FileStream();
			stream.open( wr, FileMode.WRITE );

			// Write some raw data to the file
			stream.writeBytes(jpgByteArray);

			// Clean up
			stream.close();

			var _loader:Loader;

		}
		function loadImage() {

			/////////////////////////////////////
			_loader = new Loader();
			var xml:String = "example.jpg";//"TroyWorks-80x80.jpg"; //
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeImageLoadHandler);
			var request:URLRequest = new URLRequest(jpg);
			_loader.load(request);

			// addChild(_loader);
		}*/


		function completeImageLoadHandler(event:Event):void {
			trace("completeHandler: " + event);
			//var clip:Bitmap = Bitmap(Loader(event.target.loader).content);
			//addChild(clip);
		}

	}
	
}
