package com.troyworks.framework.loader { 
	import com.troyworks.framework.logging.SOSLogger;
	
	/**
	 * @author Troy Gardner
	 */
	import flash.display.MovieClip;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.xml.XMLDocument;
	public class TestLoader {
		public var container:MovieClip;
		public function TestLoader(aMC:MovieClip) {
			container = aMC;
		}
		public static function main(container : MovieClip) : void {
		 trace("===========Test Loader" + container._url + "====================");
			 var tests:TestLoader = new TestLoader(container);
			 ////////////IMAGES and SWFs//////////////////////
			 //tests.runSingleSwfLoadTest(); //SWF works
			// tests.runSingleSwfLoadTesta(); //JPG works
			 // tests.runSingleSwfLoadTestb();//GIF works
			  // tests.runSingleSwfLoadTestc(); //PNG works
			 
	//		 tests.runTest2();
	//		 tests.runTest3();
			/////////////////XMLDocument //////////////////////////////
			tests.runSingleXMLTest();
			/////////////////SOUND ///////////////////////////
			tests.runSingleSoundTest();
			//////////////// VIDEO ///////////////////////////
			
			/////////////////CSS //////////////////////////////
		}
		public function runSingleSwfLoadTest():Boolean{
			//Single Movie Clip Load
			var cnt =  container.createEmptyMovieClip("testLoad", container.getNextHighestDepth());
			var aL:MCLoader = new MCLoader("media/LoaderDemo.swf", cnt);
		  	aL.startLoading();
			return true;
		}
		public function runSingleJPGLoadTest():Boolean{
			//Single JPG Image Cli Load
			var cnt =  container.createEmptyMovieClip("testLoadImg", container.getNextHighestDepth());
			var aL:MCLoader = new MCLoader("media/set_up_box7_large.jpg", cnt);
		  	aL.startLoading();
			return true;
		}
		public function runSingleGIFLoadTest():Boolean{
			//Single GIF Image Cli Load
			var cnt =  container.createEmptyMovieClip("testLoadImg1", container.getNextHighestDepth());
			var aL:MCLoader = new MCLoader("media/tsign001b.gif", cnt);
		  	aL.startLoading();
			return true;
		}
		
		public function runSinglePNGLoadTest():Boolean{
			//Single PNG Image Cli Load
			var cnt =  container.createEmptyMovieClip("testLoadImg", container.getNextHighestDepth());
			var aL:MCLoader = new MCLoader("media/blue dot logo.png", cnt);
		  	aL.startLoading();
			return true;
		}
		public function runSingleXMLTest():Boolean{
			//Single XMLDocument Image Cli Load
			var cnt:MovieClip =  container.createEmptyMovieClip("testLoadXML1", container.getNextHighestDepth());
			= cnt.createTextField("text_text_txt = new TextField();
			= cnt.createTextField("text_addChildAt(= cnt.createTextField("text_text_txt, cnt.getNextHighestDepth());
			= cnt.createTextField("text_text_txt.x = 50;
			= cnt.createTextField("text_text_txt.y = 50;
			= cnt.createTextField("text_text_txt.width = 300;
			= cnt.createTextField("text_text_txt.height = 500;
			
			_txt.text = "starting loading";
			var aL:XMLLoader = new XMLLoader("media/ShadP-TimeTree.XMLDocument" , cnt);
		  	aL.startLoading();
			return true;
		}	
		protected function runSingleSoundTest() : Boolean {
			var cnt:MovieClip =  container.createEmptyMovieClip("testLoadSound1", container.getNextHighestDepth());
			= cnt.createTextField("text_text_txt = new TextField();
			= cnt.createTextField("text_addChildAt(= cnt.createTextField("text_text_txt, cnt.getNextHighestDepth());
			= cnt.createTextField("text_text_txt.x = 50;
			= cnt.createTextField("text_text_txt.y = 50;
			= cnt.createTextField("text_text_txt.width = 300;
			= cnt.createTextField("text_text_txt.height = 500;
			
			_txt.text = "starting loading Sound";
			var aL:SoundLoader = new SoundLoader("media/lothlor.mp3" , cnt);
		  	aL.startLoading();
			return true;
		}
		
		public function runTest2():Boolean{
			//Sequential Multiple Movie Clip Load
			var cnt1 =  container.createEmptyMovieClip("testLoad1", container.getNextHighestDepth());
			var cnt2 =  container.createEmptyMovieClip("testLoad2", container.getNextHighestDepth());
			var cnt3 =  container.createEmptyMovieClip("testLoad3", container.getNextHighestDepth());
			cnt2.x = 50;
			cnt2.y = 50;
			cnt3.x = 100;
			cnt3.y = 100;
			var aL:Loader = new Loader( Loader.SEQUENTIAL_MODE);
			aL.addChild( new MCLoader("media/LoaderDemo.swf", cnt1));
			aL.addChild( new MCLoader("media/LoaderDemo.swf", cnt2));
			aL.addChild( new MCLoader("media/LoaderDemo.swf", cnt3));	
		  	aL.startLoading();
			return true;
		}
		public function runTest3():Boolean{
			//Parallel Multiple Movie Clip Load
			var cnt1 =  container.createEmptyMovieClip("testLoad1", container.getNextHighestDepth());
			var cnt2 =  container.createEmptyMovieClip("testLoad2", container.getNextHighestDepth());
			var cnt3 =  container.createEmptyMovieClip("testLoad3", container.getNextHighestDepth());
			cnt2.x = 50;
			cnt2.y = 50;
			cnt3.x = 100;
			cnt3.y = 100;
			var aL:Loader = new Loader(Loader.PARALLEL_MODE);
			aL.addChild( new MCLoader("media/LoaderDemo.swf", cnt1));
			aL.addChild( new MCLoader("media/LoaderDemo.swf", cnt2));
			aL.addChild( new MCLoader("media/*LoaderDemo.swf", cnt3));	
		  	aL.startLoading();
			return true;
		}
	
	}
}