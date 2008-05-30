package com.troyworks.data.validators { 
	import com.troyworks.util.StringUtil;

	/**
	 * @author Troy Gardner
	 * A Utility to Validate email addresses, does validate top level domains
	 * 
	 * 
	 *
	 * TESTS
	 * 
	import com.troyworks.data.validators.*;

	var ev:EmailValidator = new EmailValidator();

	//From http://en.wikipedia.org/wiki/E-mail_address
	//BAD EMAILS
	trace(ev.doValidation("Abc.example.com")==false); //missing @ symbol
	trace(ev.doValidation("Abc.@example.com")==false); //missing word after .
	trace(ev.doValidation("Abc..123@example.com")==false); //double ..
	trace(ev.doValidation("troy@troyworks.zz")==false); //invalid TLD
	trace(ev.doValidation("troy@@troyworks.com")==false); //double @
	//GOOD EMAILS
	trace(ev.doValidation("troy@troyworks.com")==true);
	trace(ev.doValidation("Abc@example.com")==true);
	trace(ev.doValidation("Abc.123@example.com")==true);
	trace(ev.doValidation("1234567890@domain.com")==true);
	trace(ev.doValidation("abcd@example-one.com")==true);
	trace(ev.doValidation("_______@domain.com")==true);//    ( all underscores {few domains only} )
	trace(ev.doValidation("user+mailbox/department=shipping@example.com")==true);//    ( reserved )
	trace(ev.doValidation('"Abc@def"@example.com')==false);

	//Valid but unsupported / no longer used (return false)
	trace("----valid but unsupported/no longer used");
	trace(ev.doValidation("!#$%&'*+-/=?^_`.{|}~@example.com")==true);//    ( no longer used ) 
	trace(ev.doValidation('"Fred Bloggs"@example.com')==false);
	trace(ev.doValidation('"Joe.\\Blow"@example.com')==false);



	 * CODE GEN: run the following code the TLD's and replace the TLDS:String if things change from ICANN
	 
	var request:URLRequest = new URLRequest("http://data.iana.org/TLD/tlds-alpha-by-domain.txt");
	request.contentType = "text";
	request.method = URLRequestMethod.POST;
	var loader:URLLoader = new URLLoader();

	loader.addEventListener(Event.COMPLETE, completeHandler);
	try {
	//loader.load(request);
	} catch (error:ArgumentError) {
	trace("An ArgumentError has occurred.");
	} catch (error:SecurityError) {
	trace("A SecurityError has occurred.");
	}



	function completeHandler(event:Event):void {
	var loader2:URLLoader = URLLoader(event.target);
	var res:String = String(loader2.data);
	trace("res " + res);

	var ary:Array =res.split("\n");
	//	trace(i + " res len " + res.length);
	var i:int = 1;
	var n:int =ary.length;

	for (; i < n; ++i)
	{
	trace(i + " " + ary[i]);
	}
	ary.shift();
	ary.pop();
	trace("public static const TLDS : String =\""+ary.join(",") + "\";");
	}
	 */
	public class EmailValidator extends Validator {

		public var passedSimpleEmail : Boolean;
		//See		http://www.remote.org/jochen/mail/info/chars.html
		public static const VALID_EMAIL_CHARACTERS : String = StringUtil.ALPHA_NUM + "+-._@";
		public static const TLDS : String = "AC,AD,AE,AERO,AF,AG,AI,AL,AM,AN,AO,AQ,AR,ARPA,AS,ASIA,AT,AU,AW,AX,AZ,BA,BB,BD,BE,BF,BG,BH,BI,BIZ,BJ,BM,BN,BO,BR,BS,BT,BV,BW,BY,BZ,CA,CAT,CC,CD,CF,CG,CH,CI,CK,CL,CM,CN,CO,COM,COOP,CR,CU,CV,CX,CY,CZ,DE,DJ,DK,DM,DO,DZ,EC,EDU,EE,EG,ER,ES,ET,EU,FI,FJ,FK,FM,FO,FR,GA,GB,GD,GE,GF,GG,GH,GI,GL,GM,GN,GOV,GP,GQ,GR,GS,GT,GU,GW,GY,HK,HM,HN,HR,HT,HU,ID,IE,IL,IM,IN,INFO,INT,IO,IQ,IR,IS,IT,JE,JM,JO,JOBS,JP,KE,KG,KH,KI,KM,KN,KP,KR,KW,KY,KZ,LA,LB,LC,LI,LK,LR,LS,LT,LU,LV,LY,MA,MC,MD,ME,MG,MH,MIL,MK,ML,MM,MN,MO,MOBI,MP,MQ,MR,MS,MT,MU,MUSEUM,MV,MW,MX,MY,MZ,NA,NAME,NC,NE,NET,NF,NG,NI,NL,NO,NP,NR,NU,NZ,OM,ORG,PA,PE,PF,PG,PH,PK,PL,PM,PN,PR,PRO,PS,PT,PW,PY,QA,RE,RO,RS,RU,RW,SA,SB,SC,SD,SE,SG,SH,SI,SJ,SK,SL,SM,SN,SO,SR,ST,SU,SV,SY,SZ,TC,TD,TEL,TF,TG,TH,TJ,TK,TL,TM,TN,TO,TP,TR,TRAVEL,TT,TV,TW,TZ,UA,UG,UK,UM,US,UY,UZ,VA,VC,VE,VG,VI,VN,VU,WF,WS,XN--0ZWM56D,XN--11B5BS3A9AJ6G,XN--80AKHBYKNJ4F,XN--9T4B11YI5A,XN--DEBA0AD,XN--G6W251D,XN--HGBK6AJ7F53BBA,XN--HLCJ6AYA9ESC7A,XN--JXALPDLP,XN--KGBECHTV,XN--ZCKZAH,YE,YT,YU,ZA,ZM,ZW";
		public static var TLD_idx : Object;
		public var errors:Array = new Array();
		
		public static const ERROR_MISSING_AT_SYMBOL:String = "Missing @";
		public static const ERROR_MULTIPLE_AT_SYMBOL:String = "Multiple @";
		public static const ERROR_INVALID_TLD:String = "Invalid Domain";

		public function EmailValidator() {
			super();
			if(TLD_idx == null) {
				TLD_idx = new Object();
				var ary : Array = TLDS.split(",");
				var i : int = 1;
				var n : int = ary.length;

				for (;i < n; ++i) {
				//	trace("adding " + i + " " + ary[i]);
					TLD_idx[ary[i]] = true;
				}
			}
		}

		
		public function parseTLD() : void {
		}

		override public function reset() : void {
			errors = new Array();
			passedSimpleEmail = true;
		}

		override public function doValidation(emailstr : Object) : Boolean {
			reset();
			var passed : Boolean = true;
			//remove whitespace;
			emailstr = StringUtil.filter(emailstr, StringUtil.WHITE_SPACE, false);
			
			var str : String = StringUtil.filter(emailstr, VALID_EMAIL_CHARACTERS);
			var abc : Array = str.split("@");
			if(abc.length < 2){
				errors.push(ERROR_MISSING_AT_SYMBOL);				
				passed = false;
				passedSimpleEmail = false;
				return passed;
			}else if (abc.length > 2) {
				errors.push(ERROR_MULTIPLE_AT_SYMBOL);
				passed = false;
				passedSimpleEmail = false;
				return passed;

			}else {
				for(var i : Number = 0;i < abc.length; i++) {
				
					var wrds : Array = abc[i].split(".");
					if(i == 1 && wrds.length < 2) {
						passed = false;
						passedSimpleEmail = false;
						return passed;
					}
					var w : String;
					var lastWord : Boolean;
					var size : Number;
					for(var j : Number = 0;j < wrds.length; j++) {
						w = wrds[j];
						//	trace("validating word " + w);
						lastWord = (i == abc.length - 1) && (j == wrds.length - 1);
						size = (lastWord) ? 2 : 1;
						if(w == null || w.length < size ) {
							//	trace(w + " ERROR didn't pass");
							//generally incomplete
							passed = false;
							passedSimpleEmail = false;
							return passed;
						}else if(lastWord) {
							//	trace("checking lastWord");
							if(TLD_idx[w.toUpperCase()]) {
						//		trace("passed TLD check");
							}else {
								//		trace("failed TLD check");
								errors.push(ERROR_INVALID_TLD);
								passed = false;
								passedSimpleEmail = false;
								return passed;
							}
						}
					}
				}
			}
			return passed;
		}
	}
}