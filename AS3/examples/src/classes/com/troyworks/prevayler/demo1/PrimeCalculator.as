/**

 * This is client code to the prevalent system. It does not need to be persisted.
* @author Default
* @version 0.1
*/

package com.troyworks.prevayler.demo1 {

	public class PrimeCalculator {
		
		private final var _prevayler:Prevayler;
		private final var  _numberKeeper:NumberKeeper;

		
		public function PrimeCalculator( prevayler:Prevayler) {
			_prevayler = prevayler;
			_numberKeeper = NumberKeeper(prevayler.prevalentSystem());
		}
		public function start():void{
			var largestPrime:int = 0;
			var primesFound :int = 0;
			var primeCandidate:int  = (_numberKeeper.lastNumber() == 0)?2:_numberKeeper.lastNumber() + 1;
			while (primeCandidate <= int.MAX_VALUE){
				if (isPrime(primeCandidate)) {

					_prevayler.execute(new NumberStorageTransaction(primeCandidate));

					largestPrime = primeCandidate;
					primesFound = _numberKeeper.numbers().length;
					trace("Primes found: " + primesFound + ". Largest: " + largestPrime);
				}

				primeCandidate++;
			}
		}
		private function isPrime(candidate:int):Boolean {
			/*int factor = 2;
			candidate = candidate / 2;
			while (factor < candidate) {
				if (candidate % factor == 0) return false;
				factor++;
			}
			return true;*/
			
			if (candidate < 2) { return false; }
			if (candidate == 2) { return true; }
			if (candidate % 2 == 0) { return false; }

			var factor:int = 3;
			var square:Number = Math.ceil(Math.sqrt(candidate));
			while (factor <= square) {
				if (candidate % factor == 0) return false;
				factor+=2;
			}
			return true;
		}
		
	}
	
}
