package  { 
	// JavaScript Document
	import flash.text.TextField;
	my_txt.onChanged = function(){
	 this.text = this.parent.my_array[2];
	 };
	Array.prototype.setChangeHandler = function(callback) {
	 public var len = this.length;
	 for (public var i = 0; i < len; ++i) {
	  this.watch(i, callback);
	 }
	};
	
	//usage example
	my_array = ["a", "b", "c"];
	t0_txt = new TextField();
	addChildAt(t0_txt, 0);
	t0_txt.width = 20;
	t0_txt.height = 20;
	
	t1_txt = new TextField();
	addChildAt(t1_txt, 1);
	t1_txt.x = 30;
	t1_txt.width = 20;
	t1_txt.height = 20;
	
	t2_txt = new TextField();
	addChildAt(t2_txt, 2);
	t2_txt.x = 60;
	t2_txt.width = 20;
	t2_txt.height = 20;
	
	
	my_array.setChangeHandler(function (propName, oldVal, newVal) {
	 _root["t" + propName + "_txt"].text = newVal;
	 return newVal;
	});
	my_array[0] = "d";
	my_array[1] = "e";
	my_array[2] = "f";
	/*=====
	
	"setChangeHandler" should be called everytime the array length is 
	changed.
	And of course this is one-way communication from the array to the 
	textfields.
	To achieve mutual communication, TextField.onChanged, as has been 
	suggested previously in this thread, should be added.
	
	Cheers,
	*/
}