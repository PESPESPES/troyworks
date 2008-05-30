package com.troyworks.framework.internationalization { 
	/**
	 * ISO 639a
	 * http://www.oasis-open.org/cover/iso639a.html
	 * 
	 * @author Troy Gardner
	 */
	public class LanguageFamily {
		public static var AMERINDIAN : LanguageFamily = new LanguageFamily("AMERINDIAN");
		public static var ASIAN : LanguageFamily = new LanguageFamily("ASIAN");
		public static var BALTIC : LanguageFamily = new LanguageFamily("BALTIC");
		public static var CELTIC : LanguageFamily = new LanguageFamily("CELTIC");
		public static var DRAVIDIAN : LanguageFamily = new LanguageFamily("DRAVIDIAN");
		public static var ESKIMO : LanguageFamily = new LanguageFamily("ESKIMO");
		public static var FINNO_UGRIC : LanguageFamily = new LanguageFamily("FINNO-UGRIC");
		public static var GERMANIC : LanguageFamily = new LanguageFamily("GERMANIC");
		public static var BASQUE : LanguageFamily = new LanguageFamily("BASQUE");
		public static var HAMITIC : LanguageFamily = new LanguageFamily("HAMITIC");
		public static var IBERO_CAUCASIAN : LanguageFamily = new LanguageFamily("IBERO-CAUCASIAN");
		public static var INDO_EUROPEAN_OTHER : LanguageFamily = new LanguageFamily("INDO-EUROPEAN (OTHER)");
		public static var INTERNATIONAL_AUX : LanguageFamily = new LanguageFamily("INTERNATIONAL AUX.");
		public static var INDIAN : LanguageFamily = new LanguageFamily("INDIAN");
		public static var IRANIAN : LanguageFamily = new LanguageFamily("IRANIAN");
		public static var LATIN_GREEK : LanguageFamily = new LanguageFamily("LATIN/GREEK");
		public static var NEGRO_AFRICAN : LanguageFamily = new LanguageFamily("NEGRO-AFRICAN");
		public static var OCEANIC_INDONESIAN : LanguageFamily = new LanguageFamily("OCEANIC/INDONESIAN");
		public static var ROMANCE : LanguageFamily = new LanguageFamily("ROMANCE");
		public static var SEMITIC : LanguageFamily = new LanguageFamily("SEMITIC");
		public static var SLAVIC : LanguageFamily = new LanguageFamily("SLAVIC");
		public static var TURKIC_ALTAIC : LanguageFamily = new LanguageFamily("TURKIC/ALTAIC");
		public static var NOT_GIVEN : LanguageFamily = new LanguageFamily("NOT GIVEN");
		
		public static var _ANY : LanguageFamily = new LanguageFamily("*");
		public static var _NULL : LanguageFamily = new LanguageFamily("_NULL");
		
		public var name : String;
		public function LanguageFamily(aname : String) {
			name =aname;
		}
			
	}
}