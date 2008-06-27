package com.troyworks.data {

	/**
	 * SequenceMaker
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Jun 15, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class SequenceMaker {
		public var sources:Array;
		public var curSourceIdx:int = 0;
		public function SequenceMaker() {
			
		}
		///////////////////////
		// 1) ABCDEFGHIJKLM
		// 2) abcdefghijklm
		// == AbCdEfGgHiJkLmNoPqRsT
		public function getSequence_takeOneFromEachAtAPlace(len:int = 0):Array{
			var res:Array = new Array();
			for(var i:int = 0; i< len; i++){
				 res.push(sources[curSourceIdx][i]);
				 curSourceIdx++;
				 if(curSourceIdx > (sources.length -1)){
					curSourceIdx = 0;
				}
			}
			return res;
		}
		//TODO 
		// 1)ABCDEFGHIJKLM
		// 2) abcdefghijklm
		// == AaBbCcDdEeFfGgHhIiJjKkLlMm
		public function mix(len:int = 0):Array{
			var res:Array = new Array();
			for(var i:int = 0; i< len; i++){
			 res.push(sources[curSourceIdx]);
			 curSourceIdx++;
			}
			return res;
		}
		
	}
}
