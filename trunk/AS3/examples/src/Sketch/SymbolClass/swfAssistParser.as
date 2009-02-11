
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.libspark.swfassist.io.DataInput;
	import org.libspark.swfassist.io.ByteArrayInputStream;
	import org.libspark.swfassist.swf.io.ReadingContext;
	import org.libspark.swfassist.swf.io.SWFReader;
	import org.libspark.swfassist.swf.structures.SWF;
	import org.libspark.swfassist.inprogress.swf.SWFPrinter;

	public class swfAssistParser extends Sprite
	{
		public function swfAssistParser()
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest('Asset.swf'));
		}
		
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var input:DataInput = new ByteArrayInputStream(loader.data);
			var context:ReadingContext = new ReadingContext();
			var reader:SWFReader = new SWFReader();
			
			var swf:SWF = reader.readSWF(input, context);
			
			swf.visit(new SWFPrinter());
		}
	}
}