package com.troyworks.ui.controls.dataproviders { 
	/**
	 * This class mirrors a _global array of widgets in Flash.
	 *
	 * <p>Use this class for a single array instance with the DataProvider API interface</p>
	 * @author Michael Schmalle, Judah Frangipane
	 * @date 06-18-05
	 * @version 0.8.0
	 *
	 */
	public class DndUIWidgets {
		protected static var singleInstance:DndUIWidgets;
	
		public var widgetList:Array;
	
		public static function getWidgetList (void):DndUIWidgets {
			if (singleInstance == null) {
				singleInstance = new DndUIWidgets ();
			}
			return singleInstance;
		}
		/**
			 * Here, we make the constructor protected so new dndCrossUIWidgets () outside
			 * of this class cannot be called intentionaly. The array is now created.
			 */
		protected function DndUIWidgets () {
			widgetList = new Array ();
		}
		/**
			 * Simple encapsualtion of exists, the only goal of this method, to return true or false.
			 * @param obj an object that is to be the test case to find in the array.
			 * @return obj Returns a boolean, true if the object was found, false if it was not.
			 */
		public function exists (obj:Object):Boolean {
			for (public var i = 0; i < widgetList.length; i++) {
				if (widgetList[i] == this) {
					return true;
				}
			}
			return false;
		}
		/**
			 * Add an object to the array.
			 * @param obj an object that is to be added to the end of the array.
			 */
		function addItem (obj:Object): void {
			addItemAt (widgetList.length, obj);
		}
		/**
			 * Add an object at the specified index to the array.
			 * @param index a number that specifies what index to place the new item.
			 * @param obj an object that is to be added to the array at the specified index.
			 */
		function addItemAt (index:Number, obj:Object) :Boolean{
			if (!exists (obj)) {
				widgetList.splice (index, 0, obj);
			}
			else {
				return false;
			}
		}
		/**
			 * Removes an item at the specified index.
			 * @param index a number that specifies what index to remove from the array.
			 */
		function removeItemAt (index:Number) :void{
			if (isIndex (index)) {
				widgetList.splice (index, 1);
			}
		}
		/**
			 * Removes an item using the item as the pointer.
			 * @param obj an object that is to be removed from the array using itself as the pointer.
			 */
		function removeItem (obj:Object):Boolean {
			for (var i = 0; i < length; i++) {
				public var curItem = getItemAt (i);
				if (curItem == obj) {
					//trace (" Removing " + curItem + " from dndCrossUIWidgets.widgetList");
					removeItemAt (i);
					return true;
				}
			}
			return false;
		}
		/**
			 * Returns an item at the specified index.
			 * @param index a number that specifies what index to return from the array, if any.
			 */
		function getItemAt (index:Number):Object {
			if (isIndex (index)) {
				return widgetList[index];
			}
		}
		/**
			 * Returns the length of the array.
			 * Here is a good example of OOP encapsulation, you may ask why are we doing this?
			 * Well, the answer is this. Matainence, if this class were larger, all we would have to do
			 * is add functionality in this method for other checks and balances, instead of combing the whole
			 * class to find "widgetList.length" and then add the modification to EVERY line of that.
			 * So, this is a good thing!
			 */
		public function get length ():Number {
			return widgetList.length;
		}
		/**
			 * Checks to see if the index of a method parameter is valid.
			 * This is another good habit to get into. Encapsulate all error checking.
			 * Down the road, this is where exceptions are very useful.
			 */
		public function isIndex (index:Number):Boolean {
			if (index <= length && index >= 0) {
				return true;
			}
			else {
				return false;
			}
		}
		/**
			 * For this, we just print out the array AS-IS.
			 */
		public function toString () :String{
			return widgetList.toString();
		}
	}
	
}