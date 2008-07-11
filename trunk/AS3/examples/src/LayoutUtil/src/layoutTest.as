import com.troyworks.ui.DisplayObjectSnapShot;
import com.troyworks.ui.IDisplayObjectSnapShot;
import com.troyworks.ui.LayoutUtil;


var slugsPath:String = "slugs/";

selection_cb.addItem({data: slugsPath +"1024wx768h slug.swf", label:"1024wx768h slug.swf"});
selection_cb.addItem({data: slugsPath +"600wx1200h slug.swf", label:"600wx1200h slug.swf"});
selection_cb.addItem({data: slugsPath +"1200wx600h slug.swf", label:"1200wx600h slug.swf"});
selection_cb.addItem({data: slugsPath +"800wx600h slug.swf", label:"800wx600h slug.swf"});
selection_cb.addItem({data: slugsPath +"600wx800h slug.swf", label:"600wx800h slug.swf"});
selection_cb.addItem({data: slugsPath +"320wx240h slug.swf", label:"320wx240h slug.swf"});
selection_cb.addItem({data: slugsPath +"240wx320h slug.swf", label:"240wx320h slug.swf"});

//selection_cb.addItem({data: "http://troyworks.googlecode.com/svn/trunk/AS3/examples/src/LayoutUtil/build/slugs/100x100%20slug.swf", label:"100x100 slug.swf"});
selection_cb.addItem({data: slugsPath +"100x100 slug.swf", label:"100x100 slug.swf"});
selection_cb.addItem({label:"-------------viewported --------------"});
selection_cb.addItem({data: slugsPath +"viewported 50x50 slug.swf", label:"viewported 50x50 slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 240wx320h slug.swf", label:"viewported 240wx320h slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 320wx240h slug.swf", label:"viewported 320wx240h slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 240wx320h tall slug.swf", label:"viewported 240wx320h tall slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 320wx240h tall slug.swf", label:"viewported 320wx240h tall slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 240hx320w t slug.swf", label:"viewported 240hx320w t slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 240hx320w w slug.swf", label:"viewported 240hx320w w slug.swf"});
selection_cb.addItem({label:"-------------new viewports --------------"});
selection_cb.addItem({data: slugsPath +"viewported 240hx320w h slug.swf", label:"viewported 240hx320w h slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 600hx400w r slug.swf", label:"viewported 600hx400w r slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 400hx600w slug.swf", label:"viewported 400hx600w slug.swf"});
selection_cb.addItem({data: slugsPath +"viewported 500wx500h slug.swf", label:"viewported 500wx500h slug.swf"});
//selection_cb.addItem({data:"http://troyworks.com/xml_proxy.php?url=http://troyworks.googlecode.com/svn-history/r21/trunk/AS3/examples/src/LayoutUtil/build/slugs/viewported%20500wx500h%20slug.swf", label:"viewported 500wx500h slug.swf"});
//selection_cb.addItem({data:"http://troyworks.googlecode.com/svn-history/r21/trunk/AS3/examples/src/LayoutUtil/build/slugs/viewported%20210wx315h%20slug.swf", label:"remote viewported 210wx315h slug.swf"});
selection_cb.addItem({data:"viewported 210wx315h slug.swf", label:"viewported 210wx315h slug.swf"});

selection_cb.addEventListener(Event.CHANGE, selectionChange);


placement_cb.addItem({data:"CENTER", label:"CENTER"});
placement_cb.addItem({data:"LEFT", label:"LEFT"});
placement_cb.addItem({data:"RIGHT", label:"RIGHT"});
placement_cb.addItem({data:"MIDDLE", label:"MIDDLE"});
placement_cb.addItem({data:"TOP", label:"TOP"});
placement_cb.addItem({data:"BOTTOM", label:"BOTTOM"});
placement_cb.addItem({data:"SCALETO_AR_CENTER", label:"SCALETO_AR_CENTER"});
placement_cb.addItem({data:"SCALETO_AR_CROP", label:"SCALETO_AR_CROP"});
placement_cb.addItem({data:"SCALETO_FILL", label:"SCALETO_FILL"});

placement_cb.addEventListener(Event.CHANGE, placeA);
placement_cb.addEventListener(Event.CHANGE, placeB);
placement_cb.addEventListener(Event.CHANGE, placeC);


placeA_chb.addEventListener(MouseEvent.CLICK,updateBackgrounds);
placeB_chb.addEventListener(MouseEvent.CLICK,updateBackgrounds);
placeC_chb.addEventListener(MouseEvent.CLICK,updateBackgrounds);

print_btn.addEventListener(MouseEvent.CLICK, printDrawing);

var A_loader:Loader;
var B_loader:Loader;
var C_loader:Loader;

var A_mc:MovieClip;
var B_mc:MovieClip;
var C_mc:MovieClip;
var A_snap:IDisplayObjectSnapShot;
var B_snap:IDisplayObjectSnapShot;
var C_snap:IDisplayObjectSnapShot;


function placeA(event:Event = null):void {
	trace("PLACE AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
	if (A_mc == null) {
		return;
	}

	switch (placement_cb.selectedItem.data) {
		case "SCALETO_AR_CENTER" :
			LayoutUtil.scaleTo(backgroundV_mc, A_mc, A_snap, "CENTER");
			A_mc.alpha =.4;
			break;
		case "CENTER" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap);
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap);
			A_mc.alpha =.4;
			break;
		case "LEFT" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap, "LEFT");
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap);
			A_mc.alpha =.4;
			break;
		case "RIGHT" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap, "RIGHT");
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap);
			A_mc.alpha =.4;
			break;
		case "MIDDLE" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap);
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap, "MIDDLE");
			A_mc.alpha =.4;
			break;
		case "TOP" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap);
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap, "TOP");
			A_mc.alpha =.4;
			break;
		case "BOTTOM" :
			A_mc.x = LayoutUtil.getAlignH(backgroundV_mc, A_mc, A_snap);
			A_mc.y = LayoutUtil.getAlignV(backgroundV_mc, A_mc, A_snap, "BOTTOM");
			A_mc.alpha =.4;
			break;
		case "SCALETO_AR_CROP" :
			LayoutUtil.scaleTo(backgroundV_mc, A_mc, A_snap, "CROP");
			A_mc.alpha =.4;
			break;
		case "SCALETO_FILL" :
			LayoutUtil.scaleTo(backgroundV_mc, A_mc, A_snap, "FILL");
			A_mc.alpha =.4;
			break;
	}
}

function placeB(event:Event = null):void {
	trace("PLACE BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
	if (B_mc == null) {
		return;
	}

	switch (placement_cb.selectedItem.data) {
		case "SCALETO_AR_CENTER" :
			LayoutUtil.scaleTo(background_mc, B_mc, B_snap, "CENTER");
			B_mc.alpha =.4;
			break;
		case "CENTER" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap);
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap);
			B_mc.alpha =.4;
			break;
		case "LEFT" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap, "LEFT");
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap);
			B_mc.alpha =.4;
			break;
		case "RIGHT" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap, "RIGHT");
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap);
			B_mc.alpha =.4;
			break;
		case "MIDDLE" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap);
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap, "MIDDLE");
			B_mc.alpha =.4;
			break;
		case "TOP" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap);
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap, "TOP");
			B_mc.alpha =.4;
			break;
		case "BOTTOM" :
			B_mc.x = LayoutUtil.getAlignH(background_mc, B_mc, B_snap);
			B_mc.y = LayoutUtil.getAlignV(background_mc, B_mc, B_snap, "BOTTOM");
			B_mc.alpha =.4;
			break;
		case "SCALETO_AR_CROP" :
			LayoutUtil.scaleTo(background_mc, B_mc, B_snap, "CROP");
			B_mc.alpha =.4;
			break;
		case "SCALETO_FILL" :
			LayoutUtil.scaleTo(background_mc, B_mc, B_snap, "FILL");
			B_mc.alpha =.4;
			break;
	}
}
function placeC(event:Event = null):void {
	trace("PLACE CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
	if (C_mc == null) {
		return;
	}
	switch (placement_cb.selectedItem.data) {
		case "SCALETO_AR_CENTER" :
			LayoutUtil.scaleTo(backgroundW_mc, C_mc, C_snap, "CENTER");
			C_mc.alpha =.4;
			break;
		case "CENTER" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap);
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc, C_snap);
			C_mc.alpha =.4;
			break;
		case "LEFT" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap, "LEFT");
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc, C_snap);
			C_mc.alpha =.4;
			break;
		case "RIGHT" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap, "RIGHT");
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc);
			C_mc.alpha =.4;
			break;
		case "MIDDLE" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap);
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc, C_snap, "MIDDLE");
			C_mc.alpha =.4;
			break;
		case "TOP" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap);
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc, C_snap, "TOP");
			C_mc.alpha =.4;
			break;
		case "BOTTOM" :
			C_mc.x = LayoutUtil.getAlignH(backgroundW_mc, C_mc, C_snap);
			C_mc.y = LayoutUtil.getAlignV(backgroundW_mc, C_mc, C_snap, "BOTTOM");
			C_mc.alpha =.4;
			break;
		case "SCALETO_AR_CROP" :
			LayoutUtil.scaleTo(backgroundW_mc, C_mc, C_snap, "CROP");
			C_mc.alpha =.4;
			break;
		case "SCALETO_FILL" :
			LayoutUtil.scaleTo(backgroundW_mc, C_mc, C_snap, "FILL");
			C_mc.alpha =.4;
			break;			
	}
}
function A_completeSWFLoadHandler(event:Event):void {
	A_mc= MovieClip(Loader(event.target.loader).content);
	A_snap= LayoutUtil.snapshotDimensions(A_mc);
	attachArea_mc.addChild(A_mc);
	placeA();
}
function loadA_SWF(swf:String) {
	trace("loadA_SWF " + swf);
	if (A_mc != null) {
		attachArea_mc.removeChild(A_mc);
	}
	/////////////////////////////////////
	A_loader = new Loader();
	A_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, A_completeSWFLoadHandler);
	var Arequest:URLRequest = new URLRequest(swf);
	A_loader.load(Arequest);
}

function B_completeSWFLoadHandler(event:Event):void {
	B_mc= MovieClip(Loader(event.target.loader).content);
	B_snap= LayoutUtil.snapshotDimensions(B_mc);
	attachArea_mc.addChild(B_mc);
	placeB();
}

function loadB_SWF(swf:String) {
	if (B_mc != null) {
		attachArea_mc.removeChild(B_mc);
	}
	/////////////////////////////////////
	B_loader = new Loader();
	B_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, B_completeSWFLoadHandler);
	var Brequest:URLRequest = new URLRequest(swf);
	B_loader.load(Brequest);
}
function C_completeSWFLoadHandler(event:Event):void {
	C_mc= MovieClip(Loader(event.target.loader).content);
	C_snap= LayoutUtil.snapshotDimensions(C_mc);
	attachArea_mc.addChild(C_mc);
	placeC();
}
function loadC_SWF(swf:String) {
	if (C_mc != null) {
		attachArea_mc.removeChild(C_mc);
	}
	/////////////////////////////////////
	C_loader = new Loader();
	C_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, C_completeSWFLoadHandler);
	var Crequest:URLRequest = new URLRequest(swf);
	C_loader.load(Crequest);
}


function selectionChange(evt) {
	trace(evt.target.selectedItem.label);
	if (placeA_chb.selected) loadA_SWF(evt.target.selectedItem.data);
	if (placeB_chb.selected) loadB_SWF(evt.target.selectedItem.data);
	if (placeC_chb.selected) loadC_SWF(evt.target.selectedItem.data);
}

function updateBackgrounds(evt){	
	if (!evt.target.selected) {
		trace(evt.target);
		if (evt.target == placeA_chb && A_mc != null) {
			attachArea_mc.removeChild(A_mc);
			A_mc = null;
		}
		else if (evt.target == placeB_chb && B_mc != null) {
			attachArea_mc.removeChild(B_mc);
			B_mc = null;
		}
		else if (evt.target == placeC_chb && C_mc != null) {
			attachArea_mc.removeChild(C_mc);
			C_mc = null;
		}
	}
}

function printDrawing(event:Event = null):void
{
	if (placeA_chb.selected) LayoutUtil.printImagePortrait(A_mc,A_snap);
	if (placeC_chb.selected) LayoutUtil.printImageLandscape(C_mc,C_snap);
}