package  com.troyworks.data{ 
	public class MultiEntryDictionary extends Object
	{
		///////////////////////////////
		// Stores things as one type multiple values
		// e.g. Dictionary.word[0...N] definitions.
		public function MultiEntryDictionary ()
		{
		}
		public function addItem (key : String, value : Object) : void
		{
			if (key == null || key == " ")
			{
				key = "_";
			}
			if (this [key] == null)
			{
				this [key] = new Array ();
			}
			//remove event, object and function
			this [key].push (value);
		}
		public function addAllItems (key : String, value : Array) : void
		{
			if (key == null || key == " ")
			{
				key = "_";
			}
			if (this [key] == null)
			{
				this [key] = value;
			} else
			{
				this [key] = this [key].concat (value);
			}
		}
		public function getAllItems (key : String) : Array
		{
		//	trace("----getAllItems type:" + key);
			if (key == null || key == " ")
			{
				key = "_";
			}
			var p : Array = this [key];
			if (p != null)
			{
				//trace(" contains types");
				return p;
			} else
			{
				//trace("doen'ts contain types");
				//should probably concat all the terms into one array
				return null;
			}
		}
		public function getAllTypes () : void
		{
		//	var _array:Array = new Array ();
			trace ("getAllTypes--");
			trace ((this ["LJ"] != null) + " lj key is not null" );
			trace ((this ["_"] != null) + "_ key is not null" );
			for (var i in this)
			{
				trace ("\n" + i + " in " + this [i]);
			}
		}
		/****************************************************
		 * getItem looks inside the Dictionary for the particular 
		 * entry, in some cases it might be two levels deep
		 * thus 2 keys can be used to retrieve it.
		 */
		public function getItem (key : String, key2 : Object) : Object
		{
			if (key == null || key == " ")
			{
				key = "_";
			}
			if (key2 == null){
				key2 = 0;
			}
			var p : Array = this [key];
			if (p != null)
			{
				var res:Object = p [key2];
			//	trace(res + " type exists looking for "+ key+ "."+key2);
				return res ;
			} else
			{
				//trace(" could not find type "+  key + "." + key2);
				//trace(this.toString());
				return null;
			}
		}
		public function removeItem (key : String, value : Object) : Object
		{
			if (key == null || key == " ")
			{
				key = "_";
			}
			var p = this [key];
			if (p != null)
			{
				return p.splice (value, 1);
			}
			if (p.length == 0)
			{
				//trace("no more listeners for event "+event);
				delete (this [key]);
			}
		}
		public function removeAllItems (key : String, value : String = null) : Object
		{
			if (key == null || key == " ")
			{
				key = "_";
			}
			var p : Array = this [key];
			if (p != null)
			{
				//trace("no more listeners for event "+event);
				delete (this [key]);
				return p;
			}
		}
		public function toString(keysOnly:Boolean):String{
			var res:Array = new Array();
	
			for(var i in this){
				var v:String = (keysOnly == null || keysOnly == false)?"' = v:'" + this[i]+"'":"";
				var s:String = " k:'" + i + v;
				res.push(s);
			}
			res.reverse(); 
			if(keysOnly){
				res.unshift("keys only");
			}
			return res.join("\r");
		}
	}
	
}