package com.troyworks.apps.mnemosyne
{
	import com.troyworks.data.ArrayX;
	
	public class Mnemosyne
	{
		public var items:ArrayX = new ArrayX();
		/**
		 * Holds the elements of the current session
		 * 
		 * When answering questions, work with this one but not items
		 */
		public var revisionQueue:ArrayX = new ArrayX();
		public var loadFailed:Boolean;
		public var categoryByName:Array = new Array();
		public var categories:Array = new Array();
		public static var daysSinceStart:uint = 0;
		public var timeOfStart:StartTime;
		
		//-------------------------------------------------------------------------------
		public function Mnemosyne()
		{
			this.timeOfStart = new StartTime();
			this.timeOfStart.updateDaysSince();
		}
		
		//-------------------------------------------------------------------------------
		public function addItem(grade:uint, question:String, answer:String, catName:String, id:uint = 0):Item
		{
			var item:Item = new Item();
			
			item.q = question;
			item.a = answer;
			item.cat = this.getCategoryByName(catName);
			item.grade = grade;
			
			item.acqReps = 1;
			item.acqRepsSinceLapse = 1;
			
			item.lastRep = Mnemosyne.daysSinceStart;
			
			item.easiness = this.averageEasiness();
			
			if (id == 0) {
				item.newId();
			} else {
				item.id = id;
			} 
			
			var newInterval:uint  = this.calculateInitialInterval(grade);
			
			newInterval += calculateIntervalNoise(newInterval);
			item.nextRep = Mnemosyne.daysSinceStart + newInterval;
			
			this.items.push(item);    
			
			this.loadFailed = false;
			
			return item;
		}
		
		//-------------------------------------------------------------------------------
		public function getCategoryByName(name:String):Category
		{
			this.ensureCategoryExists(name);
			return categoryByName[name];
		}
		
		//-------------------------------------------------------------------------------
		/**
		 * Make sure that category exists. If not, create it.
		 */
		public function ensureCategoryExists(name:String):void
		{
			if (this.categoryByName[name] == null) {
				var category:Category = new Category(name);
				categories.push(category);
				categoryByName[name] = category;
			}
		}
		
		//-------------------------------------------------------------------------------
		/**
		 * Estimate average easiness
		 */
		public function averageEasiness():Number
		{
			if (this.items.length == 0) {
				return 2.5;
			}
			
			if (this.items.length == 1) {
				return this.items[0].easiness;
			} else {
				// Sum easiness for all items
				var totalEasiness:Number = 0;
				for each (var i:int in this.items) {
					totalEasiness += i;
				}
				
				return totalEasiness / this.items.length;
			}
		}
		
		//-------------------------------------------------------------------------------
		/**
		 * 
		 */
		public function calculateInitialInterval(grade:uint):uint
		{
			// If this is the first time we grade this item, allow for slightly
			// longer scheduled intervals, as we might know this item from before.
			/*
			var interval:Array = new Array(0, 0, 1, 3, 4, 5);
			return interval[grade];
			*/
			
			if (grade == 0) {
				return 0;
			}
			
			return grade - 1;
		}
		
		//-------------------------------------------------------------------------------
		/**
		 * Adds some noise
		 */
		public function calculateIntervalNoise(interval:Number):Number
		{
			var noise:Number;
			if (interval == 0) {
				noise = 0;
			} else if (interval == 1) {
				noise = Math.random();
			} else if (interval <= 10) {
				if (Math.random() > 0.5) {
					noise = -Math.random();
				} else {
					noise = Math.random();
				}
			} else if (interval <= 60) {
				noise = 3*Math.random();
				if (Math.random() > 0.5) {
					noise = -noise;
				}
			} else {
				var a:Number = 0.05 * interval;
				noise = int(a*Math.random());
			}
			
			return noise;
		}
		
		
		//-------------------------------------------------------------------------------
		public function deleteItem(e:Item):void
		{
			var oldCat:Category = e.cat;
			
			for (var i:int = this.items.indexOf(e); i < this.items.length; i++) {
				this.items[i] = this.items[i + 1];
			}
			
			this.items.pop();
			
			this.rebuildRevisionQueue();
			this.removeCategoryIfUnused(oldCat);
		}
		
		//-------------------------------------------------------------------------------
		public function getNewQuestion(learnAhead:Boolean = false):Item
		{
			// Populate list if it is empty.
			if (this.revisionQueue.length == 0) {
				this.rebuildRevisionQueue(learnAhead);
			}
			
			if (this.revisionQueue.length == 0) {
				return null;
			}
			
			// Pick the first question and remove it from the queue.
			if (this.revisionQueue != null && this.revisionQueue.length > 0 && this.revisionQueue[0] != null) {
				var item:Item = this.revisionQueue[0];
				revisionQueue.shift();
				
				return item;
			} else {
				return null;
			}
		}
		
		//-------------------------------------------------------------------------------
		public function rebuildRevisionQueue(learnAhead:Boolean = false):void
		{
			this.revisionQueue = new ArrayX();
	
			if (this.items.length == 0) {
				return;
			}
	
			this.timeOfStart.updateDaysSince();

			// Always add items that are due for revision.
			for each (var item0:Item in this.items) {
				if (item0.isDueForRetentionRep()) {
					this.revisionQueue.push(item0);
				}
			}
			/*
			// Shuffle the array
			var buffer:Item;
			var replaceElementId:uint;
			
			for (var k:uint = 0; k < this.revisionQueue.length; k++) {
				buffer = this.revisionQueue[k];
				// Replace with some element randomly
				replaceElementId = int(this.revisionQueue.length*Math.random());
				this.revisionQueue[k] = this.revisionQueue[replaceElementId];
				
				this.revisionQueue[replaceElementId] = buffer;
			}
			*/
			
			this.revisionQueue.shuffle();
			
			// If the queue is empty, then add items which are not yet memorised.
			// Take only a limited number of grade 0 items from the unlearned items,
			// to avoid too long intervals between repetitions.
			if (this.revisionQueue.length == 0) {
				var notMemorised:Array = new Array();
				
				for each (var item:Item in this.items) {
					if (item.isDueForAcquisitionRep()) {
						notMemorised.push(item);
					}
				}
				
				var grade_0:ArrayX = new ArrayX();
				var grade_1:ArrayX = new ArrayX();
				for each (var item1:Item in notMemorised) {
					if (item1.grade == 0) {
						grade_0.push(item1);
					}
					
					if (item1.grade == 1) {
						grade_1.push(item1);
					}
				}
				
				// No limit
				var limit:int = -1;
				
				var flagInverses:Boolean;
				var grade_0_selected:ArrayX = new ArrayX();
				
				if (limit != 0) {
					for each (var i:Item in grade_0) {
						flagInverses = false;
						for each (var j:Item in grade_0_selected) {
							if (itemsAreInverses(i, j)) {
								flagInverses = true;
								break;
							}
						}
						
						if (!flagInverses) {
							grade_0_selected.push(i);
						}
						
						if (grade_0_selected.length == limit) {
							break;
						}
					}
				}
				/*
				// Shuffle
				for (k = 0; k < grade_0_selected.length; k++) {
					buffer = grade_0_selected[k];
					// Replace with some element randomly
					replaceElementId = int(grade_0_selected.length*Math.random());
					grade_0_selected[k] = grade_0_selected[replaceElementId];
					
					grade_0_selected[replaceElementId] = buffer;
				}
				*/
				grade_0_selected.shuffle();
				this.revisionQueue.appendArray(grade_0_selected);
//				if (grade_0_selected.length > 0) {
//					for each (var grade_o_selectedItem:Item in grade_0_selected) {
//						this.revisionQueue.push(grade_o_selectedItem);
//					}
//				}
				/*
				// Shuffle
				for (k = 0; k < grade_1.length; k++) {
					buffer = grade_1[k];
					// Replace with some element randomly
					replaceElementId = int(grade_1.length*Math.random());
					grade_1[k] = grade_1[replaceElementId];
					
					grade_1[replaceElementId] = buffer;
				}
				*/
				grade_1.shuffle();
				this.revisionQueue.appendArray(grade_1);
//				if (grade_1.length > 0) {
//					for each (var grade_1Item:Item in grade_1) {
//						this.revisionQueue.push(grade_1Item);
//					}
//				}
			}
			
			// If the queue is still empty, then simply return. The user can signal
			// that he wants to learn ahead by calling rebuild_revision_queue with
			// 'learn_ahead' set to True. Don't shuffle this queue, as it's more
			// useful to review the earliest scheduled items first.

			if (this.revisionQueue.length == 0) {
			
				if (!learnAhead) {
					return;
				} else {
					for each (var item2:Item in this.items) {
						if (item2.qualifiesForLearnAhead()) {
							this.revisionQueue.push(item2);
						}
					}
					
					this.revisionQueue.sort();
				}
			}
		}
		
		//-------------------------------------------------------------------------------
		public function removeCategoryIfUnused(cat:Category):void
		{
			for each (var item:Item in this.items) {
				if (cat.name == item.cat.name) {
					break;
				} else {
					delete categoryByName[cat.name];
					
					var flagShift:Boolean = false;
					for (var i:uint = 0; i < this.categories.length; i++) {
						if (cat.name == this.categories[i].name) {
							flagShift = true;
						}
						
						if (flagShift) {
							this.categories[i] = this.categories[i+1];
						}
						this.categories.pop();
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------
		public function itemsAreInverses(item1:Item, item2:Item):Boolean
		{
			if (item1.q == item2.a && item2.q == item1.a) {
				return true;
			} else {
				return false;
			}
		}
		
		//-------------------------------------------------------------------------------
		public function processAnswer(item:Item, newGrade:uint):Number
		{
			var scheduledInterval:Number = item.nextRep - item.lastRep;
			var actualInterval:Number = Mnemosyne.daysSinceStart - item.lastRep;
			var newInterval:Number = 0;

			if (actualInterval == 0) {
				actualInterval = 1; // Otherwise new interval can become zero.
			}

			if (item.isNew()) {
				// The item is not graded yet, e.g. because it is imported.
				item.acqReps = 1;
				item.acqRepsSinceLapse = 1;
				
				newInterval = this.calculateInitialInterval(newGrade);
				
				// Make sure the second copy of a grade 0 item doesn't show up again.
				if (item.grade == 0 && newGrade > 1 && newGrade < 6) {
					for each (var item0:Item in this.revisionQueue) {
						if (item0.id == item.id) {
							this.revisionQueue.remove(item0);
							break;
						}
					}
				}
			} else if (item.grade < 2 && newGrade < 2) {
				// In the acquisition phase and staying there.
				item.acqReps += 1;
				item.acqRepsSinceLapse += 1;
				
				newInterval = 0;
			} else if (item.grade < 2 && newGrade > 1 && newGrade < 6) {
				// In the acquisition phase and moving to the retention phase.
				item.acqReps += 1;
				item.acqRepsSinceLapse += 1;
				
				newInterval = 1;
				
				// Make sure the second copy of a grade 0 item doesn't show up again.
				if (item.grade == 0) {
					for each (var item1:Item in this.revisionQueue) {
						if (item1.id == item.id) {
							this.revisionQueue.remove(item1);
							break;
						}
					}
				}
			} else if (item.grade > 2 && item.grade < 6 && newGrade < 2) {
				// In the retention phase and dropping back to the acquisition phase.
				item.retReps += 1;
				item.lapses += 1;
				item.acqRepsSinceLapse = 0;
				item.retRepsSinceLapse = 0;
				
				newInterval = 0;
				
				// Move this item to the front of the list, to have precedence over
				// items which are still being learned for the first time.
				this.items.remove(item);
				//this.items.unshift(item);
			} else if (item.grade > 1 && item.grade < 6 && newGrade > 1 && newGrade < 6) {
				// In the retention phase and staying there.
				item.retReps += 1;
				item.retRepsSinceLapse += 1;
				
				if (actualInterval >= scheduledInterval) {
					if (newGrade == 2) {
						item.easiness -= 0.16;
					}
					if (newGrade == 3) {
						item.easiness -= 0.14;
					}
					if (newGrade == 5) {
						item.easiness += 0.10;
					}
					if (item.easiness < 1.3) {
						item.easiness = 1.3;
					}
				}
				newInterval = 0;
	
				if (item.retRepsSinceLapse == 1) {
					newInterval = 6;
				} else {
					if (newGrade == 2 || newGrade == 3) {
						if (actualInterval <= scheduledInterval) {
							newInterval = actualInterval * item.easiness;
						} else {
							newInterval = scheduledInterval;
						}
					}
					if (newGrade == 4) {
						newInterval = actualInterval * item.easiness;
					}
				
					if (newGrade == 5) {
						if (actualInterval < scheduledInterval) {
							newInterval = scheduledInterval // Avoid spacing.
						} else {
							newInterval = actualInterval * item.easiness;
						}
					}
				}
				// Shouldn't happen, but build in a safeguard.
				
				if (newInterval == 0) {
					newInterval = scheduledInterval;
				}
				
				newInterval = int(newInterval);
			}

			// Add some randomness to interval.
			var noise:Number = this.calculateIntervalNoise(newInterval);
			
			// Update grade and interval.
			item.grade = newGrade;
			item.lastRep = Mnemosyne.daysSinceStart;
			item.nextRep = Mnemosyne.daysSinceStart + newInterval + noise;
			
			// Don't schedule inverse or identical questions on the same day.
			for each (var j:Item in this.items) {
				if ((j.q == item.q && j.a == item.a) || this.itemsAreInverses(item, j)) {
					item.nextRep += 1;
					noise += 1;
				}
			}
			
			return newInterval + noise;
		}
		
		//-------------------------------------------------------------------------------
		public function isSessionFinished():Boolean
		{
			if (this.revisionQueue.length > 0) {
				return false;
			}
			
			return true;
		}


	}
}