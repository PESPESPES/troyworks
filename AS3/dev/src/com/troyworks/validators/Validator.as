package com.troyworks.validators { 
	/**
	 * A composite validator 
	 * 
	 * In general RIA validation takes the form of two types both with
	 * the goal of providing immediate feedback to the user when something
	 * has gone wrong.
	 * 
	 * 1) 'live' - after a field has recieved focus, while a user is typing/entering values
	 *     eg. invalid characters, you have 3 characters left
	 * 2) 'completed' - after a field has lost focus, type and range checkiing
	 *     e.g.
	 * 
	 * In general Validators live in the spectrum here:
	 * 
	 * UI Field -> Format Parser -> Tmp Model -> Validator ->Model  
	 * 
	 * @author Troy Gardner
	 */
	public class Validator {
	
	   	public var validators:Array;
	   	
	   	public function Validator() {
	   		validators = new Array();
	   	}
		public function addValidator(validator:Validator):void{
			validators.push(validator);
		}
		public function doValidate(val:Object):Boolean{
			var passed:Boolean = true;
			if(validators.length > 0){
				for (var i : Number = 0; i < validators.length; i++) {
					var cValidR:Validator = Validator(validators[i]);
					passed = cValidR.doValidate(val);
					
				}
			}
			return passed;
		}	
	}
}