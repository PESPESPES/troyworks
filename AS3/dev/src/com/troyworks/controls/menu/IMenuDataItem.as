package com.troyworks.controls.menu {
    import com.troyworks.data.iterators.IIterator;   
   
    /**
     * @author Troy Gardner
     */
    public interface IMenuDataItem {
        function iterator():IIterator;
        function addItem(item:IMenuDataItem):void;
        function removeItem(item:IMenuDataItem):void;
        function getName():String;
        function getDeepLink():String;
        function setName(name:String):void;
        function getParent():IMenuDataItem;
        function setParent(parent:IMenuDataItem):void;
        function getMenuLinks():Array;
        function getHref():String;
        function getMovieClipName():String;
        function getTarget():String;
        function set isSelected(val:Boolean):void;
        function get isSelected():Boolean;
    }
}