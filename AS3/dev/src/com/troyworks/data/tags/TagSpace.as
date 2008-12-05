package com.troyworks.data.tags {
	import com.troyworks.util.Trace; 
	import com.troyworks.data.bit.BitFlag;
	import com.troyworks.data.bit.MaskedBitFlag;
	/**
	 * A Tag space is the sky of tag context clouds, which themsevles are composed
	 * of TagIndexes droplets.  refracting or absorbing light
	 * 
	 * The funciton of this class is to take contextualized words (shapes, colors)
	 * and then 'flatten' them down to individual bitflags with a holepunch on the bitmask 
	 * to validate their use.
	 * 
	 * @author Troy Gardner
	 */
	public class TagSpace extends Object {
		public var matchSpace : Object;
		public var totMatchContext : Number;
		public var whiteList : Object;
		public var whiteListAll : Boolean;
	
		public var bitF : MaskedBitFlag;
	
		public var ati : TagIndex;
	
		protected var ctxMasks : Array;
		public function TagSpace() {
			super();
			init();
		}
	
		public function init() : void{
			matchSpace = new Object();
			whiteList = new Object();
			totMatchContext = 0;
			whiteListAll = true;
		}
	
		public function addTagContext(contextName : String, contextVals : Object) : TagContext{
			var tc : TagContext = new TagContext(contextName, contextVals);
			matchSpace[contextName] 	= tc;
			return tc;
		}
		public function addToWhiteListContextsIn(contextContainer : Object, startsWith:String) : void {
			trace("addToWhiteListContextsIn");
			var foundContext : Boolean = false;
			for(var ctx:String in contextContainer){
				if((startsWith == null) || (startsWith != null) && (ctx.indexOf(startsWith)>-1)){
					
				var tc : TagContext = new TagContext(ctx, contextContainer[ctx]);
				whiteList[ctx] = tc;
				foundContext = true;
				whiteListAll = false;
				}else{
				}
			}
			// no params
			if(!foundContext){
				whiteListAll = false;
			}
		}
	
		public function addToMatchingSpace(matchTarget : Object) : void {
			for(var ctx:String in matchTarget){
				if(whiteListAll || whiteList[ctx] != null){
					trace(ctx + " PASSED matching space filter");
					if(matchSpace[ctx] == null){
						//NEW CONTEXT
						var tc : TagContext = new TagContext(ctx);
						tc.parseParams(matchTarget[ctx], TagContext(whiteList[ctx]).ti);
						matchSpace[ctx] = tc;
						totMatchContext++;
					}else{
						//EXISTING
						TagContext(matchSpace[ctx]).parseParams(matchTarget[ctx], TagContext(whiteList[ctx]).ti);
					}
				}else{
					trace(ctx + " FAILED matching space filter");
				}
			}
		}
		public function flatten() : void{
			ati = new TagIndex();
			ctxMasks = new Array();
			for(var i in matchSpace){
				var tc : TagContext = TagContext(matchSpace[i]);
				trace("flattening tag context " + tc.name);
				var msk : Number = ati.addTerms(tc.ti.getTerms());
				ctxMasks.push(msk);
			}
			bitF = ati.createBitFlag(ati.getTerms());
		}
		public function buildCollisionShadow(matchClip : Object) : void {
			var numCtx:Number = 0;
			for(var ctx:String in matchClip){
				trace("testing match context " + ctx + " against " + Trace.me(whiteList,"whiteList", true));
				if(whiteListAll ){
					var bf : MaskedBitFlag = new MaskedBitFlag();
					bf.b = BitFlag.ALLBITSON;
					bf.m = BitFlag.ALLBITSON;
					BitFlag.toBinary(bf.b, bf.m);
					matchClip.bitF = bf;
					numCtx++;
					
				}else if(whiteList[ctx] != null){
					trace("'"+ ctx +"' PASSED matching space filter");
					var tc : TagContext = matchSpace[ctx];
	
					if(tc != null){
						trace("found valid matching tag context");
						numCtx++;
						var bf : MaskedBitFlag = ati.createBitFlag(matchClip[ctx]);
						if(matchClip.bitF == null){
	
							matchClip.bitF = bf;
							trace(" creating BF " + BitFlag.toBinary(matchClip.bitF.b, matchClip.bitF.m));
							
						}else{
							trace("  adding " + BitFlag.toBinary(matchClip.bitF.b, matchClip.bitF.m));
	
							MaskedBitFlag(matchClip.bf).add(bf);
						}
							
					}
	//				var tc:TagContext = new TagContext(ctx, matchClip[ctx]);
					//matchSpace[ctx] = tc;
				//	totMatchContext++;
				}else{
					trace("'"+ctx + "' FAILED matching space filter");
				}
			}
			if(numCtx>0){
				
			}else{
				trace("ERROR no tags");
			}
		}
		/**********************************
		 * This is the function that is designed to be called
		 * at particle animation speed
		 * bfA is the masked particle flag for particleA
		 * bfB is the masked bitflag for particleB 
		 * 
		 * if there is a whitelist 'policy' then the collision check is bypassed
		 * else it will look through the entire possible list for 
		 * giving it a point score e.g.
		 * 
		 * ABCDEF
		 * XXXXXX
		 * _B_D_F
		 */
		public function checkMatch(bfA : MaskedBitFlag, bfB:MaskedBitFlag) : Boolean{
				if(whiteListAll){
					trace("PASSED - all whitelisted");
					return true;
				}else if(totMatchContext > 0){
					trace("has possbile matching space filter -------------------------");
					var passedAll:Boolean = true;
					var ref:MaskedBitFlag = (bfB == null)? this.bitF:bfB;
					for(var i:String in ctxMasks){
						var cMsk:Number = ctxMasks[i];
						trace("IN  " + BitFlag.toBinary(bfA.b, cMsk));
						trace("REF " + BitFlag.toBinary(ref.b, ref.m ));
						
						trace("REF2 " + BitFlag.toBinary(ref.b, cMsk & ref.m ));
						
						if(BitFlag.isPartialMatch(bfA.b, ref.b, cMsk & ref.m)){
							trace("PASSED check");
							//return true;
						}else{
							trace("ERROR failed check");
							return false;
						}
					//	var mCtx:TagContext = matchSpace[tCtx.name];
					//	if(mCtx != null){
					//		trace("found matching tag context " + tCtx.name + "attempting Match");	
					//	}
					}
					trace("HIGHLIGHTG PASSED ALL !!!!!!");
					return passedAll;
				}else{
					trace("FAILED matching space filter whiteListAll?: " + whiteListAll + " totMatchContexts: " +totMatchContext );
					return false;
				}
		}
	
	}
}