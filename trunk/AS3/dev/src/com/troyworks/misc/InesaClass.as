package  { 
	class com.troyworks.misc.InesaClass extends MovieClip
	import flash.display.MovieClip;
	{
		public var myNum : Number = 1;
		public var myString : String = "hi";
		public var isDragging:Boolean = false;
		//inherited from the MovieClip in the library
		public var selected_mc:MovieClip;
		public function InesaClass (name : String)
		{
			super();
			trace ("new com.troyworks.misc.InesaClass " + name);
			this.myString = name;
			this.myNum = 1;
		}
	
		public function onPress() : void {
			this.pressMethod ();
		};
		public function onDragOver() : void {
			this.pressMethod ();
		};
		public function pressMethod() : void {
			trace ("onPress " + this.myString);
			gotoAndStop ("happy");
			this.isDragging = true;
			startDrag (true);
		};
		public function releaseMethod() : void {
			trace ("onRelease " + this.myString);
			gotoAndStop ("unhappy");
			this.isDragging = false;
			stopDrag ();
		};
		public function onRelease() : void {
			this.releaseMethod ();
		};
		public function onReleaseOutside() : void {
			this.releaseMethod ();
		};
		public function onRollOver() : void {
			selected_mc.visible = true;
		};
		public function onRollOut() : void {
			selected_mc.visible = false;
		};
	}
	
}