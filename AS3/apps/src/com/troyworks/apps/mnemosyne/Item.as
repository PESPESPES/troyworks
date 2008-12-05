package com.troyworks.apps.mnemosyne {

	public class Item {
		public static var lastId : uint = 0;
		public var id : uint = 0;
		public var q : String = null;
		public var a : String = null;
		public var cat : Category = null;
		public var grade : uint;
		public var easiness : Number;
		public var acqReps : Number;
		public var retReps : Number;
		public var lapses : Number;
		public var acqRepsSinceLapse : Number;
		public var retRepsSinceLapse : Number;
		public var lastRep : Number;
		public var nextRep : Number;

		//-------------------------------------------------------------------------------
		public function Item() {
			this.resetLearningData();
		}

		//-------------------------------------------------------------------------------
		/**
		 * Init
		 */
		public function resetLearningData() : void {
			this.grade = 0;
			this.easiness = 2.5;
			
			this.acqReps = 0;
			this.retReps = 0;
			this.lapses = 0;
			this.acqRepsSinceLapse = 0;
			this.retRepsSinceLapse = 0;
			
			this.lastRep = 0; 
			// In days since beginning.
			this.nextRep = 0;
		}

		//-------------------------------------------------------------------------------
		public function newId() : uint {
			Item.lastId++;
			this.id = Item.lastId;
  		
			return Item.lastId;
		}

		//-------------------------------------------------------------------------------
		public function isDueForRetentionRep(days : int = 0) : Boolean {
			var i : uint = Mnemosyne.daysSinceStart;
			return (this.grade >= 2) && (this.cat.active) && (i >= this.nextRep - days);
		}

		//-------------------------------------------------------------------------------
		public function isDueForAcquisitionRep() : Boolean {
			return (this.grade < 2) && (this.cat.active == true);
		}

		//-------------------------------------------------------------------------------
		public function qualifiesForLearnAhead() : Boolean {
			return (this.grade >= 2) && (this.cat.active) && (Mnemosyne.daysSinceStart < this.nextRep);
		}

		//-------------------------------------------------------------------------------
		public function isNew() : Boolean {
			return (this.acqReps == 0) && (this.retReps == 0);
		}
	}
}