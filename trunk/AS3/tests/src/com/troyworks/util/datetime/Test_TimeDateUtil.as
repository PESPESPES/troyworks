package com.troyworks.util.datetime {
	import com.troyworks.apps.tester.SynchronousTestSuite;

	/**
	 * Test_TimeDateUtil
	 * @author Troy Gardner
	 * AUTHOR :: Troy Gardner
	 * AUTHOR SITE :: http://www.troyworks.com/
	 * CREATED :: Oct 11, 2008
	 * DESCRIPTION ::
	 *
	 */
	public class Test_TimeDateUtil extends SynchronousTestSuite {
		public function Test_TimeDateUtil() {
			super();
		}

		public function test_setEmpty() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			res = ASSERT(tdu.getRelativeTimeMs() == 0, "Time Date Util must be equal to 0 " + tdu.getRelativeTimeMs()); 
			return res;
		}

		public function test_setYear() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			tdu.years++;
			res = ASSERT(tdu.years == 1, "Time Date Util must be equal to 0 " + tdu.years); 
			return res;
		}

		public function test_setMonth() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			tdu.months++;
			res = ASSERT(tdu.months == 1, "Time Date Util must be equal to 0 " + tdu.months); 
			return res;
		}

		public function test_setWeeks() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			tdu.weeks++;
			res = ASSERT(tdu.weeks == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setYearAndWeeks() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			
			tdu.years++;
			tdu.weeks++;
			res = ASSERT(tdu.years == 1 && tdu.weeks == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setDays() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			
			tdu.days++;
			res = ASSERT(tdu.days == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}

		
		public function test_setHours() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			
			tdu.hours++;
			res = ASSERT(tdu.hours == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setMinutes() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			
			tdu.minutes++;
			res = ASSERT(tdu.minutes == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}

		public function test_setSeconds() : Boolean {
			var res : Boolean = true;
			var tdu : TimeDateUtil = new TimeDateUtil();
			
			tdu.seconds++;
			res = ASSERT(tdu.seconds == 1, "Time Date Util must be equal to 0 " + tdu.weeks); 
			return res;
		}
	}
}
