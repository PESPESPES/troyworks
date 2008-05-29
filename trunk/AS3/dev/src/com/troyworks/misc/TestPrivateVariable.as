package  { 
	class com.troyworks.misc.TestPrivateVariable {
		public function TestPrivateVariable() {
			this.initProperties();
	 }
		function initProperties() : void {
			public var really_private_variable = "you can't change it! ";
			this.addProperty("_public_variable", public function () {
				return really_private_variable;
			  }, function (val:String) {
						really_private_variable = "you can't change it! "+val;
			  });
	 }
	}
	
}