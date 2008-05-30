package com.troyworks.apps.semantica.moby {
	import com.troyworks.core.cogs.CogSignal;	
	import com.troyworks.core.cogs.Hsm;
	import com.troyworks.core.cogs.CogEvent;

	import flash.net.URLLoader;
	import flash.net.URLRequest;

	import com.troyworks.core.cogs.proxies.URLLoaderProxy;	

	/**
	 * @author Troy Gardner
	 */
	public class MobyParser extends Hsm {
		public static  const SIG_NEW_WORDPRONOUNCIATION_PAIR : CogSignal = CogSignal.getNextSignal("NEW_WORD");
		public static  const NEW_WORD : CogSignal = CogSignal.getNextSignal("NEW_WORD");
		public static  const NEW_PRONOUCIATION : CogSignal = CogSignal.getNextSignal("NEW_WORD");

		
		
		public static const SIG_URLLOADER_IO_ERROR : CogSignal = URLLoaderProxy.SIG_URLLOADER_IO_ERROR;
		public static const SIG_URLLOADER_HTTP_STATUS : CogSignal = URLLoaderProxy.SIG_URLLOADER_HTTP_STATUS;
		public static const SIG_URLLOADER_SECURITY_ERROR : CogSignal = URLLoaderProxy.SIG_URLLOADER_SECURITY_ERROR;
		public static const SIG_URLLOADER_COMPLETE : CogSignal = URLLoaderProxy.SIG_URLLOADER_COMPLETE;

		public static var trace : Function;	
		public var urlP : URLLoaderProxy;

		public var loader : URLLoader;

		public var curEntry : Number = 0;
		public var entries : Array;
		public var curSyllable : Syllable;
		public var curWord : String;
		public var curPron : String;
		public var curPhones:Array;
		public var curPhonI:Number;
		public var curPronI:Number;
		public var foundEnd:Boolean;


		public function MobyParser(initState : String = "s_initial") {
			super(initState, "MobyParser");
		}

		
		
		///////////////////// STATES ///////////////////////////////

		/*.................................................................*/
		public function s_initial(e : CogEvent) : Function {
			switch (e.sig) {
				case SIG_INIT :
					return s_loading;
			}
			return  s_root;
		}

		public function s_loading(e : CogEvent) : Function {
			
			switch (e.sig) {
				case SIG_ENTRY :
				
					loader = new URLLoader();
					urlP = new URLLoaderProxy(loader, this);

					var request : URLRequest = new URLRequest("C:\\DATA_SYNC\\My Documents\\My Projects\\Kids.Intrio\\dev\\Rhyming\\mpron.txt");
					try {
						loader.load(request);
					} catch (error : Error) {
						trace("Unable to load requested document.");
					}
				
					return null;
					
				case SIG_URLLOADER_COMPLETE:
					requestTran(s_loaded);
					return null;	
				case SIG_EXIT :
					return null;
	//			case SIG_INIT :
//					return s_1;
			}
			
			
			return  s_root;
		}

		public function s_loaded(e : CogEvent) : Function {

			switch (e.sig) {
				case SIG_ENTRY :
				
					entries = loader.data.split("\r");
					trace("loaded!" + entries.length);
					startPulse();
					return null;
				case SIG_PULSE:
					trace("HIGHLIGHTG  Parsing " + entries[curEntry]);
					requestTran(s_parsingWordAndPronouciationPair);
					stopPulse();
		
					return null;
				case SIG_EXIT :
					return null;
	//			case SIG_INIT :
//					return s_1;
			}

			return  s_root;
		}

		/*.................................................................*/
		public function s_parsingWordAndPronouciationPair(e : CogEvent) : Function {

			switch (e.sig) {
				case SIG_ENTRY :
					var wp : String = entries[curEntry];
					var wpA : Array = wp.split(" ");
					curWord = wpA[0];
					curPron = wpA[1];
					trace("HIGHLIGHTY word:" + curWord + " pron:" + curPron);
					requestTran(s_parsingPhonemes);
					curEntry++;
					return null;
				case SIG_EXIT :
					return null;
	//			case SIG_INIT :
//					return s_1;
			}
			return  s_loaded;
		}

		/*.................................................................*/
		public function s_parsingPhonemes(e : CogEvent) : Function {

			switch (e.sig) {
				case SIG_ENTRY :
					curSyllable = new Syllable();
					curPhones = curPron.split("/");
					curPhonI = 0;
					foundEnd = false;
					startPulse();			
					return null;
				case SIG_PULSE:
				var phon:String = curPhones[curPhonI];
					trace("HIGHLIGHTY curChar:" + phon);
					switch(phon){
						case "'":
							curSyllable.stress = Syllable.PRIMARY_STRESS;
							break;
						case ",":
							curSyllable.stress = Syllable.SECONDARY_STRESS;
							break;
						//case "
						case "/":
						break;
						default:
						trace("unrecognized");
						break;
					}
					if(curPhonI < curPhones.length){
						curPhonI++;
					}else{
						trace("HIGHLIGHTP finished syllabus");
						stopPulse();
					}
					return null;
				case SIG_EXIT :
					stopPulse();
					return null;
	//			case SIG_INIT :
//					return s_1;
			}
			return  s_loaded;
		}
		/*.................................................................*/
		public function s_parsingSyllable(e : CogEvent) : Function {

			switch (e.sig) {
				case SIG_ENTRY :
					curSyllable = new Syllable();
					curPronI = 0;
					foundEnd = false;
					startPulse();			
					return null;
				case SIG_PULSE:
					trace("HIGHLIGHTY curChar:" + curPron.charAt(curPronI));
					switch(curPron.charAt(curPronI)){
						case "'":
							curSyllable.stress = Syllable.PRIMARY_STRESS;
							break;
						case ",":
							curSyllable.stress = Syllable.SECONDARY_STRESS;
							break;
			
						case "/":
						break;
					}
					if(curPronI < curPron.length){
						curPronI++;
					}else{
						trace("HIGHLIGHTP finished syllabus");
						stopPulse();
					}
					return null;
				case SIG_EXIT :
					stopPulse();
					return null;
	//			case SIG_INIT :
//					return s_1;
			}
			return  s_loaded;
		}
	}
}
