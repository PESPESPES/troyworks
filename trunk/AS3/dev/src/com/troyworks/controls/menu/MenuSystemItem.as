package com.troyworks.controls.menu {
	import flash.utils.Dictionary;	

	import com.troyworks.data.iterators.IIterator;	
	import com.troyworks.controls.menu.IMenuDataItem;

	/**
	 * @author Troy Gardner
	 */
	public class MenuSystemItem implements IMenuDataItem {
		public static var IDz : int = 0;
		public var id : Number = MenuSystemItem.IDz++;
		public static var _ALL : Dictionary = new Dictionary();
		public static var _ALLDEEPLINKS : Dictionary = new Dictionary();
		private var _name : String;
		public var target : String;
		public var href : String;
		public var deeplink : String;
		private var _isSelected:Boolean = false;
		private var _parent : IMenuDataItem;
		public var selectedBullet:String = "<img src='selectedIcon' width='10' height='10'>";

		public function MenuSystemItem() {
			super();
		//	trace('MenuSystemItem');
			_ALL[id] = this;
		}

		public function iterator() : IIterator {
			return null;
		}

		public function addItem(item : IMenuDataItem) : void {
		}

		public function removeItem(item : IMenuDataItem) : void {
		}

		public function getName() : String {
			return _name;
		}
		public function set isSelected(val:Boolean):void{
			_isSelected = val;
		}
		public function get isSelected():Boolean{
			return _isSelected;
		}
		
		public function setName(name : String) : void {
			_name = name;
		}

		public function getParent() : IMenuDataItem {
			return _parent;
		}

		public function setAnchor(a : XMLList) : void {
			href = a.@href;
			target = a.@target;
			deeplink = a.@name;
			if(_ALLDEEPLINKS[deeplink] == null){
			_ALLDEEPLINKS[deeplink] = this;
			}
			if(a.text().length() >0 ){
			_name = a.text()[0];
			}else{
				_name = "";
			}
		}

		public function setParent(parent : IMenuDataItem) : void {
			_parent = parent;
		}

		public function getDeepLink() : String {
			return String(deeplink);
		}

		public function getHyperLink() : String {
			var lnk : String = "event:" + deeplink;
			
			return (isSelected)?_name: (<a name={deeplink} href={lnk} target="mainFrame">{_name}</a>).toXMLString();
		}
		public function getHref():String{
			return String(href);
		}
		public function getTarget():String{
			return String(target);
		}
		public function getMenuLinks() : Array {
			var curNav : Array = new Array();
			var iter : IIterator = iterator();
			if(iter != null) {
				var mI : MenuSystemItem;
				while(iter.hasNext()) {
					mI = MenuSystemItem(iter.next());
					trace(XML(mI.getHyperLink()).toXMLString());
					curNav.push(XML(mI.getHyperLink()).toXMLString());
				} 
				return curNav;
			}else {
				return [];
			}
		}
	}
}
