package com.troyworks.snippets.patterns {
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	/*based on the excellent work of Ted Patrick
	* http://www.onflex.org/ted/2006/04/magic-with-flashutilproxy.php#comments
	*/
	public dynamic class SingletonProxy extends Proxy {
		
		private static var staticObject:*;
		private var innerObject:*;
		

		// constructor
		public function SingletonProxy( ... rest:Array  ) {

			// test for staticObject
			if( ! staticObject ){
				
				// test for constructor arguments
				if( rest[0] ){

					//set value of staticObject
					staticObject = rest[0];

				}else{
			
					//set value of staticObject	
					staticObject = new Object();

				}
			}	

			//set value of instance innerObject to staticObject property
			this.innerObject = staticObject;
		
		}

    	
		// override to catch call operations
		flash_proxy override function callProperty( name:* , ... rest ):* 
		{

			// call method on innerObject and return it!
    			return this.innerObject[ name.toString() ].apply( this.innerObject , rest );

		}

     	
		// override to catch delete operations
		flash_proxy override function deleteProperty( name:* ):Boolean  
    		{
			// if innerObject has a property
			if( this.innerObject[ name.toString() ] ){
				
				//delete the property
    				delete this.innerObject[ name.toString() ];

				//return boolean
    				return true;
    			}

			//return boolean on failure to delete
    			return false;

    		}

    	
		// override to catch get operations
		flash_proxy override function getProperty( name:* ):*  
    		{   
 	
			// return the property on innerObject	
    			return this.innerObject[name.toString()];

    		}

    	
		// override to catch has operations
		flash_proxy override function hasProperty( name:* ):Boolean 
    		{
			
			// when a property exists, return true	
    			if( this.innerObject[ name.toString() ] ) return true;

			// return false when that fails
    			return false;

    		}

    	
		// override to catch set operations
		flash_proxy override function setProperty( name:* , value:* ):void 
		{
			// set the value of a property on innerObject
			this.innerObject[ name.toString() ] = value;
		
		}
		
	}
	
}