package com.troyworks.util.datetime {
	import com.troyworks.apps.tester.SynchronousTestSuite;
	
	/**
	 * Test_TimeQuantity
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 11, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_TimeQuantity extends SynchronousTestSuite {
		public function Test_TimeQuantity() {
			super();
		}
		
		public function test_setEmpty() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			res = ASSERT(tdu.time == 0, "TimeQuantitymust be equal to 0 " + tdu.time); 
			return res;
		}

		public function test_setYear() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			tdu.years++;
			res = ASSERT(tdu.years == 1, "TimeQuantitymust be equal to 0 " + tdu.years); 
			return res;
		}

		public function test_setMonth() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			tdu.months++;
			res = ASSERT(tdu.months == 1, "TimeQuantitymust be equal to 0 " + tdu.months); 
			return res;
		}

		public function test_setWeeks() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			tdu.weeks++;
			res = ASSERT(tdu.weeks == 1, "TimeQuantitymust be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setYearAndWeeks() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			
			tdu.years++;
			tdu.weeks++;
			res = ASSERT(tdu.years == 1 && tdu.weeks == 1, "TimeQuantitymust be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setDays() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			
			tdu.days++;
			res = ASSERT(tdu.days == 1, "TimeQuantitymust be equal to 0 " + tdu.weeks); 
			return res;
		}

		
		public function test_setHours() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			
			tdu.hours++;
			res = ASSERT(tdu.hours == 1, "TimeQuantitymust be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setMinutes() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			
			tdu.minutes++;
			res = ASSERT(tdu.minutes == 1, "TimeQuantitymust be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setSeconds() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			
			tdu.seconds++;
			res = ASSERT(tdu.seconds == 1, "TimeQuantitymust be equal to 0 " + tdu.seconds); 
			return res;
		}
		
		public function test_setSeconds2() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			tdu.milliseconds++;
			tdu.seconds++;
			res = ASSERT(tdu.seconds == 1, "TimeQuantitymust be equal to 0 " + tdu.seconds); 
			return res;
		}
		
		public function test_setSeconds3() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity();
			tdu.milliseconds++;
			tdu.seconds++;
			ASSERT(tdu.seconds == 1  && tdu.milliseconds== 1 , "TimeQuantitymust be equal to 1 " + tdu.seconds); 
			tdu.seconds = 0;
			res = ASSERT(tdu.seconds == 0  && tdu.milliseconds== 1 , "TimeQuantitymust be equal to 0 " + tdu.seconds); 
			return res;
		}
		public function test_setQuantity() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity(1500);

			res = ASSERT(tdu.seconds == 1  && tdu.milliseconds== 500 , "TimeQuantitymust be equal to 1,500 " + tdu.seconds + " , " +  tdu.milliseconds); 
			return res;
		}
		
		public function test_setQuantity2() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity(-1500);

			res = ASSERT(tdu.seconds == -1  && tdu.milliseconds== -500 , "TimeQuantitymust be equal to 1,500 " + tdu.seconds + " , " +  tdu.milliseconds); 
			return res;
		}
		public function test_setSeconds4() : Boolean {
			var res : Boolean = true;
			var tdu : TimeQuantity = new TimeQuantity(1500);
		
			ASSERT(tdu.seconds == 1  && tdu.milliseconds== 500 , "TimeQuantitymust be equal to 1,500 " + tdu.seconds + " , " +  tdu.milliseconds); 
			
				tdu.seconds -= 5;
			tdu.seconds = 0;
			res = ASSERT(tdu.seconds == 0  && tdu.milliseconds== -500 , "TimeQuantitymust be equal to 1 " + tdu.seconds + " , " +  tdu.milliseconds);
			return res;
		}
	}
}
