package com.troyworks.data.validators { 

	
	/**
	 * Taken from the USPS
	 * http://www.usps.com/ncsc/lookups/usps_abbreviations.html
	 * @author Troy Gardner
	 */
	public class USStateValidator extends Validator {
	
		public static const ALABAMA:USState = new USState("ALABAMA", "AL");
		public static const ALASKA:USState = new USState("ALASKA", "AK");
		public static const AMERICAN_SAMOA:USState = new USState("AMERICAN SAMOA", "AS");
		public static const ARIZONA:USState = new USState("ARIZONA", "AZ");
		public static const ARKANSAS:USState = new USState("ARKANSAS", "AR");
		public static const CALIFORNIA:USState = new USState("CALIFORNIA", "CA");
		public static const COLORADO:USState = new USState("COLORADO", "CO");
		public static const CONNECTICUT:USState = new USState("CONNECTICUT", "CT");
		public static const DELAWARE:USState = new USState("DELAWARE", "DE");
		public static const DISTRICT_OF_COLUMBIA:USState = new USState("DISTRICT OF COLUMBIA", "DC");
		public static const FEDERATED_STATES_OF_MICRONESIA:USState = new USState("FEDERATED STATES OF MICRONESIA", "FM");
		public static const FLORIDA:USState = new USState("FLORIDA", "FL");
		public static const GEORGIA:USState = new USState("GEORGIA", "GA");	
		public static const GUAM :USState = new USState("GUAM ", "GU");
		public static const HAWAII:USState = new USState("HAWAII", "HI");
		public static const IDAHO:USState = new USState("IDAHO", "ID");	
		public static const ILLINOIS :USState = new USState("ILLINOIS ", "IL");
		public static const INDIANA:USState = new USState("INDIANA", "IN");
		public static const IOWA:USState = new USState("IOWA", "IA");
		public static const KANSAS:USState = new USState("KANSAS", "KS");
		public static const KENTUCKY:USState = new USState("KENTUCKY", "KY");
		public static const LOUISIANA:USState = new USState("LOUISIANA", "LA");
		public static const MAINE:USState = new USState("MAINE", "ME");
		public static const MARSHALL_ISLANDS:USState = new USState("MARSHALL ISLANDS", "MH");
		public static const MARYLAND:USState = new USState("MARYLAND", "MD");
		public static const MASSACHUSETTS:USState = new USState("MASSACHUSETTS", "MA");
		public static const MICHIGAN:USState = new USState("MICHIGAN", "MI");
		public static const MINNESOTA:USState = new USState("MINNESOTA", "MN");
		public static const MISSISSIPPI:USState = new USState("MISSISSIPPI", "MS");
		public static const MISSOURI:USState = new USState("MISSOURI", "MO");
		public static const MONTANA:USState = new USState("MONTANA", "MT");
		public static const NEBRASKA:USState = new USState("NEBRASKA", "NE");
		public static const NEVADA:USState = new USState("NEVADA", "NV");
		public static const NEW_HAMPSHIRE:USState = new USState("NEW_HAMPSHIRE", "NH");
		public static const NEW_JERSEY:USState = new USState("NEW_JERSEY", "NJ");
		public static const NEW_MEXICO:USState = new USState("NEW_MEXICO", "NM");
		public static const NEW_YORK:USState = new USState("NEW YORK", "NY");
		public static const NORTH_CAROLINA:USState = new USState("NORTH CAROLINA", "NC");
		public static const NORTH_DAKOTA:USState = new USState("NORTH_DAKOTA", "ND");
		public static const NORTHERN_MARIANA_ISLANDS:USState = new USState("NORTHERN_MARIANA_ISLANDS", "MP");
		public static const OHIO:USState = new USState("OHIO", "OH");
		public static const OKLAHOMA:USState = new USState("OKLAHOMA", "OK");
		public static const OREGON:USState = new USState("OREGON", "OR");
		public static const PALAU:USState = new USState("PALAU", "PW");
		public static const PENNSYLVANIA:USState = new USState("PENNSYLVANIA", "PA");
		public static const PUERTO_RICO:USState = new USState("PUERTO RICO", "PR");
		public static const RHODE_ISLAND:USState = new USState("RHODE ISLAND", "RI");
		public static const SOUTH_CAROLINA:USState = new USState("SOUTH CAROLINA", "SC");
		public static const SOUTH_DAKOTA:USState = new USState("SOUTH DAKOTA", "SD");
		public static const TENNESSEE:USState = new USState("TENNESSEE", "TN");
		public static const TEXAS:USState = new USState("TEXAS", "TX");
		public static const UTAH:USState = new USState("UTAH", "UT");
		public static const VERMONT:USState = new USState("VERMONT", "VT");
		public static const VIRGIN_ISLANDS:USState = new USState("VIRGIN ISLANDS", "VI");
		public static const VIRGINIA:USState = new USState("VIRGINIA", "VA");
		public static const WASHINGTON:USState = new USState("WASHINGTON", "WA");
		public static const WEST_VIRGINIA:USState = new USState("WEST VIRGINIA", "WV");
		public static const WISCONSIN:USState = new USState("WISCONSIN", "WI");
		public static const WYOMING:USState = new USState("WYOMING", "WY");
	
		
		private var AB_idx:Object = new Object();
		private var FULL_idx:Object = new Object();
		//private static var hasInit:Boolean = false;
		public function USStateValidator() {
			super();
		}
		public function init():void{
			//TODO fill out indexes with the objects.
		}
		public function containsAbbeviation(key:String):Boolean{
			return AB_idx[key] != null;
		}
		public function containsFullname(fullName:String):Boolean{
			return FULL_idx[fullName] != null;
		}
	
	}
}