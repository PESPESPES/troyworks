package  { 
	
	
	USER_ACCESS_ROLE
	
		public  var USER:Number = 0;
		public  var GROUP:Number =1;
		public  var OTHER:Number = 2;
	    UNKNOWN
		SYSTEM
	
	OPERATIONS
		APPLICATION
			START
			EXIT
			HELP
	
		FILE
			NEW
			OPEN
		   	 OPEN_ALL
			SAVE
			 SAVE_ALL
				SAVE_AS
			CLOSE
			 CLOSE_ALL
			REVERT
			IMPORT
			EXPORT
	
	
		EDIT
			UNDO
			REDO
			RENAME
			CUT
			COPY
			  DUPLICATE
			PASTE
				PASTE_SPECIAL
			SWAP
			SELECT
			SELECT_ALL
			DESELECT
			DESELECT_ALL
			FIND
			  FIND_NEXT
			  FIND_PREVIOUS
			  FIND_AND_REPLACE
			  FIND_IN_SCOPE (global, user etc)
			NAVIGATE (in scope)
				PREVIOUS
				NEXT
		PREFERENCES
		PRINT
			PRINT_SCOPE (page, document)
			SETUP
	
	COMPOSITE_OPERATIONS
		public  var READ:Number = 0;
		public  var WRITE:Number =1;
		public  var OVERWRITE
		public  var APPEND:Number = 2;
	
		public  var OPEN:Number =1;
		public  var DELETE:Number =1;
	
		public  var EXECUTE:Number = 4;
	
}