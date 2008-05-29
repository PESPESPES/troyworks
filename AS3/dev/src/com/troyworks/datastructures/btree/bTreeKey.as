package  { 
	 
	import flash.ui.Keyboard;
	 import com.troyworks.datastructures.btree.*;
	 //Keyboard Object Interface Definition
	//Listing 2. Keys in the bTree must implement this interface. This allows the bTree class methods for searching and inserting to order the keys properly in the index. 
	
	 
	// Interface for bTreeKeys
	interface com.troyworks.datastructures.btree.bTreeKey
	{
	   // Compares 'this' with thatkey
	   // Returns
	   // < 0 if this < thatkey
	   // =0 if this = thatkey
	   //  > 0 if this > thatkey
	  // public int compare(bTreeKey thatkey);
	   public function compare(thatkey:bTreeKey ) : Number;
	 
	   // Return a reference to the key object
	   //public Object getKey();
	   public function getKey () : Object;
	} 
	
}