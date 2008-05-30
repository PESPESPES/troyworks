package com.troyworks.framework.internationalization { 
	/**
	 * Based off of ISO 639
	 * http://www.oasis-open.org/cover/iso639a.html
	 * 
	 * @author Troy Gardner
	 */
	public class Language extends Object {
		public var code_2 : LanguageCode;
		public var code_3 : LanguageCode;
	
		public var name : LanguageName;
		public var family : LanguageFamily;
	
		public static var AFAR : Language = new Language(LanguageName.AFAR, LanguageCode.AA, null, LanguageFamily.HAMITIC);
		public static var ABKHAZIAN : Language = new Language(LanguageName.ABKHAZIAN, LanguageCode.AB, null, LanguageFamily.IBERO_CAUCASIAN);
		public static var AFRIKAANS : Language = new Language(LanguageName.AFRIKAANS, LanguageCode.AF, null, LanguageFamily.GERMANIC);
		public static var AMHARIC : Language = new Language(LanguageName.AMHARIC, LanguageCode.AM, null, LanguageFamily.SEMITIC);
		public static var ARABIC : Language = new Language(LanguageName.ARABIC, LanguageCode.AR, null, LanguageFamily.SEMITIC);
		public static var ASSAMESE : Language = new Language(LanguageName.ASSAMESE, LanguageCode.AS, null, LanguageFamily.INDIAN);
		public static var AYMARA : Language = new Language(LanguageName.AYMARA, LanguageCode.AY, null, LanguageFamily.AMERINDIAN);
		public static var AZERBAIJANI : Language = new Language(LanguageName.AZERBAIJANI, LanguageCode.AZ, null, LanguageFamily.TURKIC_ALTAIC);
		public static var BASHKIR : Language = new Language(LanguageName.BASHKIR, LanguageCode.BA, null, LanguageFamily.TURKIC_ALTAIC);
		public static var BYELORUSSIAN : Language = new Language(LanguageName.BYELORUSSIAN, LanguageCode.BE, null, LanguageFamily.SLAVIC);
		public static var BULGARIAN : Language = new Language(LanguageName.BULGARIAN, LanguageCode.BG, null, LanguageFamily.SLAVIC);
		public static var BIHARI : Language = new Language(LanguageName.BIHARI, LanguageCode.BH, null, LanguageFamily.INDIAN);
		public static var BISLAMA : Language = new Language(LanguageName.BISLAMA, LanguageCode.BI, null, LanguageFamily.NOT_GIVEN);
		public static var BENGALIBANGLA : Language = new Language(LanguageName.BENGALIBANGLA, LanguageCode.BN, null, LanguageFamily.INDIAN);
		public static var TIBETAN : Language = new Language(LanguageName.TIBETAN, LanguageCode.BO, null, LanguageFamily.ASIAN);
		public static var BRETON : Language = new Language(LanguageName.BRETON, LanguageCode.BR, null, LanguageFamily.CELTIC);
		public static var CATALAN : Language = new Language(LanguageName.CATALAN, LanguageCode.CA, null, LanguageFamily.ROMANCE);
		public static var CORSICAN : Language = new Language(LanguageName.CORSICAN, LanguageCode.CO, null, LanguageFamily.ROMANCE);
		public static var CZECH : Language = new Language(LanguageName.CZECH, LanguageCode.CS, null, LanguageFamily.SLAVIC);
		public static var WELSH : Language = new Language(LanguageName.WELSH, LanguageCode.CY, null, LanguageFamily.CELTIC);
		public static var DANISH : Language = new Language(LanguageName.DANISH, LanguageCode.DA, null, LanguageFamily.GERMANIC);
		public static var GERMAN : Language = new Language(LanguageName.GERMAN, LanguageCode.DE, null, LanguageFamily.GERMANIC);
		public static var BHUTANI : Language = new Language(LanguageName.BHUTANI, LanguageCode.DZ, null, LanguageFamily.ASIAN);
		public static var GREEK : Language = new Language(LanguageName.GREEK, LanguageCode.EL, null, LanguageFamily.LATIN_GREEK);
		public static var ENGLISH : Language = new Language(LanguageName.ENGLISH, LanguageCode.EN, null, LanguageFamily.GERMANIC);
		public static var ESPERANTO : Language = new Language(LanguageName.ESPERANTO, LanguageCode.EO, null, LanguageFamily.INTERNATIONAL_AUX);
		public static var SPANISH : Language = new Language(LanguageName.SPANISH, LanguageCode.ES, null, LanguageFamily.ROMANCE);
		public static var ESTONIAN : Language = new Language(LanguageName.ESTONIAN, LanguageCode.ET, null, LanguageFamily.FINNO_UGRIC);
		public static var BASQUE : Language = new Language(LanguageName.BASQUE, LanguageCode.EU, null, LanguageFamily.BASQUE);
		public static var PERSIAN : Language = new Language(LanguageName.PERSIAN, LanguageCode.FA, null, LanguageFamily.IRANIAN);
		public static var FINNISH : Language = new Language(LanguageName.FINNISH, LanguageCode.FI, null, LanguageFamily.FINNO_UGRIC);
		public static var FIJI : Language = new Language(LanguageName.FIJI, LanguageCode.FJ, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var FAROESE : Language = new Language(LanguageName.FAROESE, LanguageCode.FO, null, LanguageFamily.GERMANIC);
		public static var FRENCH : Language = new Language(LanguageName.FRENCH, LanguageCode.FR, null, LanguageFamily.ROMANCE);
		public static var FRISIAN : Language = new Language(LanguageName.FRISIAN, LanguageCode.FY, null, LanguageFamily.GERMANIC);
		public static var IRISH : Language = new Language(LanguageName.IRISH, LanguageCode.GA, null, LanguageFamily.CELTIC);
		public static var CROATIAN : Language = new Language(LanguageName.CROATIAN, LanguageCode.HR, null, LanguageFamily.SLAVIC);
		public static var HUNGARIAN : Language = new Language(LanguageName.HUNGARIAN, LanguageCode.HU, null, LanguageFamily.FINNO_UGRIC);
		public static var ARMENIAN : Language = new Language(LanguageName.ARMENIAN, LanguageCode.HY, null, LanguageFamily.INDO_EUROPEAN_OTHER);
		public static var INTERLINGUA : Language = new Language(LanguageName.INTERLINGUA, LanguageCode.IA, null, LanguageFamily.INTERNATIONAL_AUX);
		public static var INTERLINGUE : Language = new Language(LanguageName.INTERLINGUE, LanguageCode.IE, null, LanguageFamily.INTERNATIONAL_AUX);
		public static var INUPIAK : Language = new Language(LanguageName.INUPIAK, LanguageCode.IK, null, LanguageFamily.ESKIMO);
		public static var INDONESIAN : Language = new Language(LanguageName.INDONESIAN, LanguageCode.ID, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var ICELANDIC : Language = new Language(LanguageName.ICELANDIC, LanguageCode.IS, null, LanguageFamily.GERMANIC);
		public static var ITALIAN : Language = new Language(LanguageName.ITALIAN, LanguageCode.IT, null, LanguageFamily.ROMANCE);
		public static var INUKTITUT : Language = new Language(LanguageName.INUKTITUT, LanguageCode.IU, null, LanguageFamily.ROMANCE);
		public static var JAPANESE : Language = new Language(LanguageName.JAPANESE, LanguageCode.JA, null, LanguageFamily.ASIAN);
		public static var JAVANESE : Language = new Language(LanguageName.JAVANESE, LanguageCode.JV, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var GEORGIAN : Language = new Language(LanguageName.GEORGIAN, LanguageCode.KA, null, LanguageFamily.IBERO_CAUCASIAN);
		public static var KAZAKH : Language = new Language(LanguageName.KAZAKH, LanguageCode.KK, null, LanguageFamily.TURKIC_ALTAIC);
		public static var GREENLANDIC : Language = new Language(LanguageName.GREENLANDIC, LanguageCode.KL, null, LanguageFamily.ESKIMO);
		public static var CAMBODIAN : Language = new Language(LanguageName.CAMBODIAN, LanguageCode.KM, null, LanguageFamily.ASIAN);
		public static var KANNADA : Language = new Language(LanguageName.KANNADA, LanguageCode.KN, null, LanguageFamily.DRAVIDIAN);
		public static var KOREAN : Language = new Language(LanguageName.KOREAN, LanguageCode.KO, null, LanguageFamily.ASIAN);
		public static var KASHMIRI : Language = new Language(LanguageName.KASHMIRI, LanguageCode.KS, null, LanguageFamily.INDIAN);
		public static var KURDISH : Language = new Language(LanguageName.KURDISH, LanguageCode.KU, null, LanguageFamily.IRANIAN);
		public static var KIRGHIZ : Language = new Language(LanguageName.KIRGHIZ, LanguageCode.KY, null, LanguageFamily.TURKIC_ALTAIC);
		public static var LATIN : Language = new Language(LanguageName.LATIN, LanguageCode.LA, null, LanguageFamily.LATIN_GREEK);
		public static var LINGALA : Language = new Language(LanguageName.LINGALA, LanguageCode.LN, null, LanguageFamily.NEGRO_AFRICAN);
		public static var LAOTHIAN : Language = new Language(LanguageName.LAOTHIAN, LanguageCode.LO, null, LanguageFamily.ASIAN);
		public static var LITHUANIAN : Language = new Language(LanguageName.LITHUANIAN, LanguageCode.LT, null, LanguageFamily.BALTIC);
		public static var LATVIANLETTISH : Language = new Language(LanguageName.LATVIANLETTISH, LanguageCode.LV, null, LanguageFamily.BALTIC);
		public static var MALAGASY : Language = new Language(LanguageName.MALAGASY, LanguageCode.MG, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var MAORI : Language = new Language(LanguageName.MAORI, LanguageCode.MI, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var MACEDONIAN : Language = new Language(LanguageName.MACEDONIAN, LanguageCode.MK, null, LanguageFamily.SLAVIC);
		public static var MALAYALAM : Language = new Language(LanguageName.MALAYALAM, LanguageCode.ML, null, LanguageFamily.DRAVIDIAN);
		public static var MONGOLIAN : Language = new Language(LanguageName.MONGOLIAN, LanguageCode.MN, null, LanguageFamily.NOT_GIVEN);
		public static var MOLDAVIAN : Language = new Language(LanguageName.MOLDAVIAN, LanguageCode.MO, null, LanguageFamily.ROMANCE);
		public static var MARATHI : Language = new Language(LanguageName.MARATHI, LanguageCode.MR, null, LanguageFamily.INDIAN);
		public static var MALAY : Language = new Language(LanguageName.MALAY, LanguageCode.MS, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var MALTESE : Language = new Language(LanguageName.MALTESE, LanguageCode.MT, null, LanguageFamily.SEMITIC);
		public static var BURMESE : Language = new Language(LanguageName.BURMESE, LanguageCode.MY, null, LanguageFamily.ASIAN);
		public static var NAURU : Language = new Language(LanguageName.NAURU, LanguageCode.NA, null, LanguageFamily.NOT_GIVEN);
		public static var NEPALI : Language = new Language(LanguageName.NEPALI, LanguageCode.NE, null, LanguageFamily.INDIAN);
		public static var DUTCH : Language = new Language(LanguageName.DUTCH, LanguageCode.NL, null, LanguageFamily.GERMANIC);
		public static var NORWEGIAN : Language = new Language(LanguageName.NORWEGIAN, LanguageCode.NO, null, LanguageFamily.GERMANIC);
		public static var OCCITAN : Language = new Language(LanguageName.OCCITAN, LanguageCode.OC, null, LanguageFamily.ROMANCE);
		public static var AFAN : Language = new Language(LanguageName.AFAN, LanguageCode.OM, null, LanguageFamily.HAMITIC);
		public static var ORIYA : Language = new Language(LanguageName.ORIYA, LanguageCode.OR, null, LanguageFamily.INDIAN);
		public static var PUNJABI : Language = new Language(LanguageName.PUNJABI, LanguageCode.PA, null, LanguageFamily.INDIAN);
		public static var POLISH : Language = new Language(LanguageName.POLISH, LanguageCode.PL, null, LanguageFamily.SLAVIC);
		public static var PASHTOPUSHTO : Language = new Language(LanguageName.PASHTOPUSHTO, LanguageCode.PS, null, LanguageFamily.IRANIAN);
		public static var PORTUGUESE : Language = new Language(LanguageName.PORTUGUESE, LanguageCode.PT, null, LanguageFamily.ROMANCE);
		public static var QUECHUA : Language = new Language(LanguageName.QUECHUA, LanguageCode.QU, null, LanguageFamily.AMERINDIAN);
		public static var RHAETOROMANCE : Language = new Language(LanguageName.RHAETOROMANCE, LanguageCode.RM, null, LanguageFamily.ROMANCE);
		public static var KURUNDI : Language = new Language(LanguageName.KURUNDI, LanguageCode.RN, null, LanguageFamily.NEGRO_AFRICAN);
		public static var ROMANIAN : Language = new Language(LanguageName.ROMANIAN, LanguageCode.RO, null, LanguageFamily.ROMANCE);
		public static var RUSSIAN : Language = new Language(LanguageName.RUSSIAN, LanguageCode.RU, null, LanguageFamily.SLAVIC);
		public static var KINYARWANDA : Language = new Language(LanguageName.KINYARWANDA, LanguageCode.RW, null, LanguageFamily.NEGRO_AFRICAN);
		public static var SANSKRIT : Language = new Language(LanguageName.SANSKRIT, LanguageCode.SA, null, LanguageFamily.INDIAN);
		public static var SINDHI : Language = new Language(LanguageName.SINDHI, LanguageCode.SD, null, LanguageFamily.INDIAN);
		public static var SANGHO : Language = new Language(LanguageName.SANGHO, LanguageCode.SG, null, LanguageFamily.NEGRO_AFRICAN);
		public static var SERBOCROATIAN : Language = new Language(LanguageName.SERBOCROATIAN, LanguageCode.SH, null, LanguageFamily.SLAVIC);
		public static var SINGHALESE : Language = new Language(LanguageName.SINGHALESE, LanguageCode.SI, null, LanguageFamily.INDIAN);
		public static var SLOVAK : Language = new Language(LanguageName.SLOVAK, LanguageCode.SK, null, LanguageFamily.SLAVIC);
		public static var SLOVENIAN : Language = new Language(LanguageName.SLOVENIAN, LanguageCode.SL, null, LanguageFamily.SLAVIC);
		public static var SAMOAN : Language = new Language(LanguageName.SAMOAN, LanguageCode.SM, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var SHONA : Language = new Language(LanguageName.SHONA, LanguageCode.SN, null, LanguageFamily.NEGRO_AFRICAN);
		public static var SOMALI : Language = new Language(LanguageName.SOMALI, LanguageCode.SO, null, LanguageFamily.HAMITIC);
		public static var ALBANIAN : Language = new Language(LanguageName.ALBANIAN, LanguageCode.SQ, null, LanguageFamily.INDO_EUROPEAN_OTHER);
		public static var SERBIAN : Language = new Language(LanguageName.SERBIAN, LanguageCode.SR, null, LanguageFamily.SLAVIC);
		public static var SISWATI : Language = new Language(LanguageName.SISWATI, LanguageCode.SS, null, LanguageFamily.NEGRO_AFRICAN);
		public static var SESOTHO : Language = new Language(LanguageName.SESOTHO, LanguageCode.ST, null, LanguageFamily.NEGRO_AFRICAN);
		public static var SUNDANESE : Language = new Language(LanguageName.SUNDANESE, LanguageCode.SU, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var SWEDISH : Language = new Language(LanguageName.SWEDISH, LanguageCode.SV, null, LanguageFamily.GERMANIC);
		public static var SWAHILI : Language = new Language(LanguageName.SWAHILI, LanguageCode.SW, null, LanguageFamily.NEGRO_AFRICAN);
		public static var TAMIL : Language = new Language(LanguageName.TAMIL, LanguageCode.TA, null, LanguageFamily.DRAVIDIAN);
		public static var TELUGU : Language = new Language(LanguageName.TELUGU, LanguageCode.TE, null, LanguageFamily.DRAVIDIAN);
		public static var TAJIK : Language = new Language(LanguageName.TAJIK, LanguageCode.TG, null, LanguageFamily.IRANIAN);
		public static var THAI : Language = new Language(LanguageName.THAI, LanguageCode.TH, null, LanguageFamily.ASIAN);
		public static var TIGRINYA : Language = new Language(LanguageName.TIGRINYA, LanguageCode.TI, null, LanguageFamily.SEMITIC);
		public static var TURKMEN : Language = new Language(LanguageName.TURKMEN, LanguageCode.TK, null, LanguageFamily.TURKIC_ALTAIC);
		public static var TAGALOG : Language = new Language(LanguageName.TAGALOG, LanguageCode.TL, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var SETSWANA : Language = new Language(LanguageName.SETSWANA, LanguageCode.TN, null, LanguageFamily.NEGRO_AFRICAN);
		public static var TONGA : Language = new Language(LanguageName.TONGA, LanguageCode.TO, null, LanguageFamily.OCEANIC_INDONESIAN);
		public static var TURKISH : Language = new Language(LanguageName.TURKISH, LanguageCode.TR, null, LanguageFamily.TURKIC_ALTAIC);
		public static var TSONGA : Language = new Language(LanguageName.TSONGA, LanguageCode.TS, null, LanguageFamily.NEGRO_AFRICAN);
		public static var TATAR : Language = new Language(LanguageName.TATAR, LanguageCode.TT, null, LanguageFamily.TURKIC_ALTAIC);
		public static var TWI : Language = new Language(LanguageName.TWI, LanguageCode.TW, null, LanguageFamily.NEGRO_AFRICAN);
		public static var UIGUR : Language = new Language(LanguageName.UIGUR, LanguageCode.UG, null, LanguageFamily.NEGRO_AFRICAN);
		public static var UKRAINIAN : Language = new Language(LanguageName.UKRAINIAN, LanguageCode.UK, null, LanguageFamily.SLAVIC);
		public static var URDU : Language = new Language(LanguageName.URDU, LanguageCode.UR, null, LanguageFamily.INDIAN);
		public static var UZBEK : Language = new Language(LanguageName.UZBEK, LanguageCode.UZ, null, LanguageFamily.TURKIC_ALTAIC);
		public static var VIETNAMESE : Language = new Language(LanguageName.VIETNAMESE, LanguageCode.VI, null, LanguageFamily.ASIAN);
		public static var VOLAPUK : Language = new Language(LanguageName.VOLAPUK, LanguageCode.VO, null, LanguageFamily.INTERNATIONAL_AUX);
		public static var WOLOF : Language = new Language(LanguageName.WOLOF, LanguageCode.WO, null, LanguageFamily.NEGRO_AFRICAN);
		public static var XHOSA : Language = new Language(LanguageName.XHOSA, LanguageCode.XH, null, LanguageFamily.NEGRO_AFRICAN);
		public static var YIDDISH : Language = new Language(LanguageName.YIDDISH, LanguageCode.YI, null, LanguageFamily.GERMANIC);
		public static var YORUBA : Language = new Language(LanguageName.YORUBA, LanguageCode.YO, null, LanguageFamily.NEGRO_AFRICAN);
		public static var ZHUANG : Language = new Language(LanguageName.ZHUANG, LanguageCode.ZA, null, LanguageFamily.NEGRO_AFRICAN);
		public static var CHINESE : Language = new Language(LanguageName.CHINESE, LanguageCode.ZH, null, LanguageFamily.ASIAN);
		public static var SCOTS_GAELIC : Language = new Language(LanguageName.SCOTS_GAELIC, LanguageCode.GD, null, LanguageFamily.CELTIC);
		public static var ZULU : Language = new Language(LanguageName.ZULU, LanguageCode.ZU, null, LanguageFamily.NEGRO_AFRICAN);
	
		public static var _ANY : Language = new Language(LanguageName._ANY, LanguageCode._ANY, null, LanguageFamily._ANY);
	
		public function Language(langName : LanguageName, lang2Code : LanguageCode, lang3Code : LanguageCode, languageFamily : LanguageFamily) {
			name = langName;
			code_2 = lang2Code;
			code_3 = lang3Code;
			family = languageFamily;
			
		}
		public static function getLanguageByCode(code:String):Language{
			var cd:String = code.toUpperCase();
			var res:Language;
			for(var i:String in Language){
				var lan:Language =Language(Language[i]);
				if(lan.code_2.code_2D == cd){
					res = lan;
					break;
				}
			}
			return res;
		}
	}
}