package com.troyworks.apps.semantica.moby {

	/**
	 * @author Troy Gardner
	 */
	public class Phonem {
		//http://www.ego4u.com/en/dictionary/ipa
		//http://www.learnersdictionary.com/faq_pron_ipa.htm
		public static const PRIMARY_STRESS:Number = 2;
		public static const SECONDARY_STRESS:Number = 1;
		public static const NO_STRESS:Number = 0;
		
		public var stress:Number = NO_STRESS;
		
		public static const CONSONANT:String = "CONSONANT";
		public static const VOWEL:String = "VOWEL";
		
		public var type:String = CONSONANT;

		public var mobyToken : String;
		public var soundsLike : String;

		public static const AMP_AHB : Phonem = new Phonem("&", '"a" in "dab"');
		public static const ATP_AIR : Phonem = new Phonem("(@)", '"a" in "air"');
		public static const A : Phonem = new Phonem("A", '"a" in "far"');
		public static const eIP : Phonem = new Phonem("eI", '"a" in "day"');
		public static const AT : Phonem = new Phonem("@", '"a" in "ado"');
		//or the glide "e" in "system" (dipthong schwa)');
		
		public static const DASH : Phonem = new Phonem("-", '"ir" glide in "tire"');
		//or the  "dl" glide in "handle"');
		//or the "den" glide in "sodden" (dipthong little schwa)');
		
		public static const b : Phonem = new Phonem("b", '"b" in "nab"');
		public static const tS : Phonem = new Phonem("tS", '"ch" in "ouch"');
		public static const d : Phonem = new Phonem("d", '"d" in "pod"');
		public static const E : Phonem = new Phonem("E", '"e" in "red"');
		public static const i : Phonem = new Phonem("i", '"e" in "see"');
		public static const f : Phonem = new Phonem("f", '"f" in "elf"');
		public static const g : Phonem = new Phonem("g", '"g" in "fig"');
		public static const h : Phonem = new Phonem("h", '"h" in "had"');
		public static const hw : Phonem = new Phonem("hw", '"w" in "white"');
		public static const I : Phonem = new Phonem("I", '"i" in "hid"');
		public static const aI : Phonem = new Phonem("aI", '"i" in "ice"');
		public static const dZ : Phonem = new Phonem("dZ", '"g" in "vegetably"');
		public static const k : Phonem = new Phonem("k", '"c" in "act"');
		public static const l : Phonem = new Phonem("l", '"l" in "ail"');
		public static const m : Phonem = new Phonem("m", '"m" in "aim"');
		public static const N : Phonem = new Phonem("N", '"ng" in "bang"');
		public static const n : Phonem = new Phonem("n", '"n" in "and"');
		public static const Oi : Phonem = new Phonem("Oi", '"oi" in "oil"');
		public static const AW : Phonem = new Phonem("A", '"o" in "bob"');
		public static const AU : Phonem = new Phonem("AU", '"ow" in "how"');
		public static const O : Phonem = new Phonem("O", '"o" in "dog"');
		public static const oU : Phonem = new Phonem("oU", '"o" in "boat"');
		public static const u : Phonem = new Phonem("u", '"oo" in "too"');
		public static const U : Phonem = new Phonem("U", '"oo" in "book"');
		public static const p : Phonem = new Phonem("p", '"p" in "imp"');
		public static const r : Phonem = new Phonem("r", '"r" in "ire"');
		public static const S : Phonem = new Phonem("S", '"sh" in "she"');
		public static const s : Phonem = new Phonem("s", '"s" in "sip"');
		public static const T : Phonem = new Phonem("T", '"th" in "bath"');
		public static const D : Phonem = new Phonem("D", '"th" in "the"');
		public static const t : Phonem = new Phonem("t", '"t" in "tap"');
		public static const up : Phonem = new Phonem("@", '"u" in "cup"');
		public static const upR : Phonem = new Phonem("@r", '"u" in "burn"');
		public static const v : Phonem = new Phonem("v", '"v" in "average"');
		public static const w : Phonem = new Phonem("w", '"w" in "win"');
		public static const j : Phonem = new Phonem("j", '"y" in "you"');

		public static const Z : Phonem = new Phonem("Z", '"s" in "vision"');
		public static const z : Phonem = new Phonem("z", '"z" in "zoo"');

		//Moby Pronunciator contains many common names and phrases borrowed from
		//other languages; special sounds include (case is significant):

		public static const A_AHM : Phonem = new Phonem("A", '"a" in "ami"');
		public static const N_AHN : Phonem = new Phonem("N", '"n" in "Francoise"');
		public static const R_AIR : Phonem = new Phonem("R", '"r" in "Der"');
		public static const X_CH : Phonem = new Phonem("x", '"ch" in "Bach"');
		public static const Y_EU : Phonem = new Phonem("y", '"eu" in "cordon bleu"');
		public static const U_DUE : Phonem = new Phonem("Y", '"u" in "Dubois"');
		
		public function Phonem(mobyToken:String, soundsLike:String) {
			this.mobyToken = mobyToken;
			this.soundsLike = soundsLike;
		}
	}
}
