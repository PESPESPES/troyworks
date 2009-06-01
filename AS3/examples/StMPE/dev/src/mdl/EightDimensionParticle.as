package mdl {
	import flash.display.MovieClip;	
	
	import com.troyworks.data.Default;	

	import flash.filters.GlowFilter;	
	import flash.display.Sprite;	

	import com.troyworks.core.tweeny.*;

	/**
	 * @author Troy Gardner
	 */
	public class EightDimensionParticle extends Object {

		private var _ui : Sprite;
		public var uiTny : Tny;
		public var modl : Model;
		public var pmdl : EightDimensionParticle;
		public var id : Number;
		//////// Standards or E8 ////////
		public var nname : String;
		public var nlabel : String;
		public var nsize : Number;
		public var ncolor : Number;
		public var ncolorObj : Colors;
		public var nshape : RenderShape = RenderShape.M_CIRCLE;
		//////// GUT (Grand Unified Theory) ////////////////////////
		public var gutname : String;//="X"; 
		public var gutlabel : String;//"X boson";
		public var gutcolor : Number;//="black";
		public var gutcolorObj : Colors;
		public var gutshape : RenderShape = RenderShape.M_CIRCLE;//"circle";
	
		 
		////////////////////////
		public var angleX : Number = 0;
		public var angleY : Number = 0;
		public var angleZ : Number = 0;
		public var distFromCamera : Number = 0;

		public static const HOVER_COLOR : Number = 0xFFCC33;
		public static const SELECTED_FIRST_COLOR : Number = 0xFFFF00;
		public static const SELECTED_SECOND_POSSIBLE_COLOR : Number = 0x66FFFF ;
		public static const SELECTED_SECOND_COLOR : Number = 0x333399;
		public static const RESULT_COLOR : Number = 0x66FF66;

		public const HOVER_FILTER : GlowFilter = new GlowFilter(HOVER_COLOR, .6, 10, 10, 4, 1, true);
		public const SELECTED_FIRST_FILTER : GlowFilter = new GlowFilter(SELECTED_FIRST_COLOR, 1, 20, 20, 4);
		public const SELECTED_SECOND_POSSIBLE_FILTER : GlowFilter = new GlowFilter(SELECTED_SECOND_POSSIBLE_COLOR, 1, 10, 10, 4);
		public const SELECTED_SECOND_FILTER : GlowFilter = new GlowFilter(SELECTED_SECOND_COLOR, 1, 20, 20, 4);
		public const RESULT_FILTER : GlowFilter = new GlowFilter(RESULT_COLOR, 1, 20, 20, 4);

		public var isFocused : Boolean = false;
		public static const NOT_SELECTED : Number = 0;
		public static const SELECTED_FIRST : Number = 1;
		public static const SELECTED_SECOND_POSSIBLE : Number = 2;
		public static const SELECTED_SECOND : Number = 4;
		public static const RESULT : Number = 8;
		private var _selectedState : Number = NOT_SELECTED;
		// dimension coordinates
		public var outboundParticleLinks : Array = new Array();

		///////////////////Point System->Theory /////////////////////////////
		public var isStandardModel : Boolean = false;
		public var isPati_Salam : Boolean = false;  //GUT
		public var isGeorgi_Glashow : Boolean = false; //GUT
		public var isE6 : Boolean = false; //GUT
		public var isE8 : Boolean = false;

		///////////////////////////////////////////////
		public var coords : Array = new Array();
		public var curCoordsIdx : int = 0;

		public var curCoords : EightDimensionParticleLabelledCoordinates;
		public var gutcoord : EightDimensionParticleLabelledCoordinates;
		public var smcoord : EightDimensionParticleLabelledCoordinates;	
		public var e8coord : EightDimensionParticleLabelledCoordinates;
		public var labelMC : MovieClip;

		public function EightDimensionParticle(d1 : Number = 0,d2 : Number = 0,d3 : Number = 0,d4 : Number = 0,d5 : Number = 0,d6 : Number = 0,d7 : Number = 0,d8 : Number = 0,sym : String = "mcir", color : String = "mgray", name : String = "unnamed", label : String = "") : void {
			super();
			e8coord = new EightDimensionParticleLabelledCoordinates(d1, d2, d3, d4, d5, d6, d7, d8);
			smcoord = new EightDimensionParticleLabelledCoordinates(d1, d2, d3, d4, d5, d6, d7, d8);
			gutcoord = new EightDimensionParticleLabelledCoordinates(d1, d2, d3, d4, d5, d6, d7, d8);
			curCoords = e8coord;
			coords.push(e8coord);
			coords.push(smcoord);
			coords.push(gutcoord);
			//	trace("new EightDimensionParticle " + sym);
			this.nshape = RenderShape.parse(sym);
			this.nsize = this.nshape.scale;
			this.nname = name;
			this.nlabel = label;
			this.ncolorObj = Colors.parse(color);
			this.ncolor = this.ncolorObj.rgb; 
			//0 if it's not in the standard model. All points are in e8.
			//this.isStandardModel = isStandardModel;
		}

		public function get ui() : Sprite {
			return _ui;
		}

		public function set ui(view : Sprite) : void {
			_ui = view;
			if(uiTny == null) {
				uiTny = new Tny(view);
			} else {
				uiTny.target = view;
			}
		}

		public function set name( value : String ) : void {
			if(modl != null && modl.isGUTmode) {
				gutname = value;
			} else {
				nname = value;
			}
		}

		public function get name( ) : String {
			if(modl != null && modl.isGUTmode) {
				return  gutname;
			} else {
				return	nname;
			}
		}

		
		//	private var _label : String;

		public function set label( value : String ) : void {
			if(modl != null && modl.isGUTmode) {
				gutlabel = value;
			} else {
				nlabel = value;
			}
		}

		public function get label( ) : String {
			if(modl != null && modl.isGUTmode) {
				return  gutlabel;
			} else {
				return	nlabel;
			}
		}

		
		public function redrawUI() : void {
			if(modl != null && modl.isGUTmode) {
				trace(id +  " drawing with GUT color " + gutcolor);
				gutshape.draw(ui, gutcolor);
			
			} else {
				trace(id +  " drawing with NORMAL color " + ncolor);
				nshape.draw(ui, ncolor);
			}
				labelMC.gotoAndStop(int(name));
		}

		public function updateUI() : void {
			if(ui != null) {
				///////////////// FOCUSED /////////////////////
				if(isFocused) {
					var ary : Array = ui.getChildByName("shape").filters;
					ary.push(HOVER_FILTER);
					ui.getChildByName("shape").filters = ary;
					//		ui.alpha = 1;
				} else {
					//////////////// NOT FOCUSED ////////////////////////
					//trace("updatingUI " + _selectedState);
					switch(_selectedState) {	
						case RESULT:
							ui.getChildByName("shape").filters = [RESULT_FILTER];
							//	ui.alpha = 1;
							break;
			
						case SELECTED_FIRST:
							//	trace("SELECTED FIRST!");
							ui.getChildByName("shape").filters = [SELECTED_FIRST_FILTER];
							//	clip.visible = false;
							//	ui.alpha = 1;
							break;
						case SELECTED_SECOND:
							//		trace("SELECTED SECOND");
							ui.getChildByName("shape").filters = [SELECTED_SECOND_FILTER];
							//	ui.alpha = 1;
							break;
						case SELECTED_SECOND_POSSIBLE:
							ui.getChildByName("shape").filters = [SELECTED_SECOND_POSSIBLE_FILTER];
							//	ui.alpha = ( modl.secondClicked == null) ? 1 : .3;
							break;
						case NOT_SELECTED:
							ui.getChildByName("shape").filters = [];
							//	ui.alpha = (modl.firstClicked == null&& modl.secondClicked == null) ? 1 : .02;
							break;	
						default:
							trace("ERROR not selected ");
							break;
					}
				}
				/////////////////// UI ////////////////////
			// UI.setAxisLabel(ui.getChildByName(lbl), 
			}
		}

		public function setCurrentCoordinates(cid : int = 0) : void {
			//trace("setCurrentCoordinates " + label + " " + id + " = " + coords[cid]);
			if(coords[cid] != null) {
				curCoordsIdx = cid;
				curCoords = coords[cid];
			} else {
				throw new Error("EightDimensionalParticle.setCurrentCoordinates " + cid + " does not exist");
			}
		}

		public function set selectedState(stateNo : Number) : void {
			trace("!!!!!!!!!!!!!!!!!!!!!! set selectedState " + stateNo);
			if(_selectedState != stateNo) {
				_selectedState = stateNo;
				updateUI();
			}
		}

		public function get selectedState() : Number {			
			return _selectedState;
		}

		public function clone() : EightDimensionParticle {
			//trace("clone");
			var res : EightDimensionParticle = new EightDimensionParticle();
			res.isStandardModel = isStandardModel;
			res.isPati_Salam = isPati_Salam;
			res.isGeorgi_Glashow = isGeorgi_Glashow;
			res.isE6 = isE6;
			res.isE8 = isE8;
			
			res.coords = this.coords;
			res.curCoordsIdx = this.curCoordsIdx;
			res.curCoords = new EightDimensionParticleLabelledCoordinates();
			res.nname = String(this.nname);
			res.id = Number(this.id);
			res.label = String(this.label);
			res.nlabel = String(this.nlabel);
			res.ncolor = Number(this.ncolor);
			res.nshape = this.nshape;
			
			res.gutname = new String(this.gutname); 
			res.gutlabel = new String(this.gutlabel);
			res.gutcolor = new Number(this.gutcolor);
			res.gutcolorObj = this.gutcolorObj;
			res.gutshape = this.gutshape;
			res.e8coord = this.e8coord.deepClone();
			res.smcoord = this.smcoord.deepClone();
			res.gutcoord = this.gutcoord.deepClone();
			if(this.e8coord == this.curCoords) {
				res.curCoords = res.e8coord; 
			}
			if(this.gutcoord == this.curCoords) {
				res.curCoords = res.gutcoord; 
			}
			
			if(this.smcoord == this.curCoords) {
				res.curCoords = res.smcoord; 
			}
			
			/*			res.curCoords.d1 = Number(this.curCoords.d1);
			res.curCoords.d2 = Number(this.curCoords.d2);
			res.curCoords.d3 = Number(this.curCoords.d3);
			res.curCoords.d4 = Number(this.curCoords.d4);
			res.curCoords.d5 = Number(this.curCoords.d5);
			res.curCoords.d6 = Number(this.curCoords.d6);
			res.curCoords.d7 = Number(this.curCoords.d7);
			res.curCoords.d8 = Number(this.curCoords.d8);
			
			res.curCoords.d1Lbl = String(this.curCoords.d1Lbl);
			res.curCoords.d2Lbl = String(this.curCoords.d2Lbl);
			res.curCoords.d3Lbl = String(this.curCoords.d3Lbl);
			res.curCoords.d4Lbl = String(this.curCoords.d4Lbl);
			res.curCoords.d5Lbl = String(this.curCoords.d5Lbl);
			res.curCoords.d6Lbl = String(this.curCoords.d6Lbl);
			res.curCoords.d7Lbl = String(this.curCoords.d7Lbl);
			res.curCoords.d8Lbl = String(this.curCoords.d8Lbl);*/		
			return res;
		}

		public function addToVector(v : EightDimensionVector) : EightDimensionVector {
			var res : EightDimensionVector = new EightDimensionVector();
			res.d1 = this.curCoords.d1 + v.d1;
			res.d2 = this.curCoords.d2 + v.d2;
			res.d3 = this.curCoords.d3 + v.d3;
			res.d4 = this.curCoords.d4 + v.d4;
			res.d5 = this.curCoords.d5 + v.d5;
			res.d6 = this.curCoords.d6 + v.d6;
			res.d7 = this.curCoords.d7 + v.d7;
			res.d8 = this.curCoords.d8 + v.d8;
			return res;			
		}

		
		public static function XMLFactory(xml : XML) : EightDimensionParticle {
			/*	<p id="177"
			name="\bar{c}_L^{\lor }" color="drora" symbol="mutr" label="anti-charm quark"
			sm="0" ps="0" gg="0" e6="1" e8="1"
			gutname="X" gutcolor="black" gutsymbol="circle" gutlabel="X boson"
			e8coordlbl="-1/2,1/2,-1/2,-1/2,-1/2,1/2,-1/2,-1/2" e8coord="-0.5,0.5,-0.5,-0.5,-0.5,0.5,-0.5,-0.5"
			gutcoordlbl="-1/2,1/2,-1/2,-1/2,-1/2,1/2,-1/2,-1/2" gutcoord="-0.5,0.5,-0.5,-0.5,-0.5,0.5,-0.5,-0.5"
			smcoordlbl="-1/2,1/2,-1/2,-1/2,-1/2,1/2,-1/2,-1/2" smcoord="-0.5,0.5,-0.5,-0.5,-0.5,0.5,-0.5,-0.5"
			/>*/
			var res : EightDimensionParticle = new EightDimensionParticle(0, 0, 0, 0, 0, 0, 0, 0, xml.@symbol, xml.@color, xml.@name, xml.@label);
			res.isStandardModel = xml.@sm == "1";
			res.isPati_Salam = xml.@ps == "1";
			res.isGeorgi_Glashow = xml.@gg == "1";
			res.isE6 = xml.@e6 == "1";
			res.isE8 = xml.@e8 == "1";
			//	trace("new E8Particle  " + res.name + " sm " + res.isStandardModel + " ps " + res.isPati_Salam  + " gg " +res.isGeorgi_Glashow + " e6 " + res.isE6 + " e8 "+ res.isE8);
			if(false){
			res.gutname = Default.getString(new String(xml.@gutname), res.nname); 
			res.gutlabel = Default.getString(new String(xml.@gutlabel), res.nlabel);
			var co : Number = Default.getNumberFromString(String(xml.@gutcolor), res.ncolor);
			res.gutcolorObj = Colors.parse(String(co));
			res.gutcolor = res.gutcolorObj.rgb;
			res.gutshape = RenderShape.parse(Default.getString(new String(xml.@gutsymbol), xml.@symbol));
			}
			//DEFAULT TO THE NORMAL COLORS //////
			res.gutname = res.nname; 
			res.gutlabel = res.nlabel;
			res.gutcolorObj = res.ncolorObj;
			res.gutcolor = res.ncolorObj.rgb;
			res.gutshape = res.nshape;
			//			res.name = String();
			//			res.color = Colors.parse().rgb;
			//			trace("XML FAcTres.curCoords. xml.@symbol);
			//			res.shape = RenderShape.parse();
			//////////////////////////////////////////////////////////
			//                 E8 
			//////////////////////////////////////////////////////////
			var coord : Array;
			var coordLbl : Array;
			////////////// COORDINATE ////////////////////////
			coord = String(xml.@e8coord).split(",");
			res.e8coord.d1 = Number(coord[0]);
			res.e8coord.d2 = Number(coord[1]);
			res.e8coord.d3 = Number(coord[2]);
			res.e8coord.d4 = Number(coord[3]);
			res.e8coord.d5 = Number(coord[4]);
			res.e8coord.d6 = Number(coord[5]);
			res.e8coord.d7 = Number(coord[6]);
			res.e8coord.d8 = Number(coord[7]);

			////////////// COORDINATE LABEL  ////////////////////////
			coordLbl = String(xml.@e8coordlbl).split(",");
			res.e8coord.d1Lbl = coordLbl[0];
			res.e8coord.d2Lbl = coordLbl[1];
			res.e8coord.d3Lbl = coordLbl[2];
			res.e8coord.d4Lbl = coordLbl[3];
			res.e8coord.d5Lbl = coordLbl[4];
			res.e8coord.d6Lbl = coordLbl[5];
			res.e8coord.d7Lbl = coordLbl[6];
			res.e8coord.d8Lbl = coordLbl[7];
			//////////////////////////////////////////////////////////
			//                 GUT 
			//////////////////////////////////////////////////////////
			////////////// COORDINATE ////////////////////////
			coord = String(xml.@gutcoord).split(",");
			res.gutcoord.d1 = Number(coord[0]);
			res.gutcoord.d2 = Number(coord[1]);
			res.gutcoord.d3 = Number(coord[2]);
			res.gutcoord.d4 = Number(coord[3]);
			res.gutcoord.d5 = Number(coord[4]);
			res.gutcoord.d6 = Number(coord[5]);
			res.gutcoord.d7 = Number(coord[6]);
			res.gutcoord.d8 = Number(coord[7]);

			////////////// COORDINATE LABEL  ////////////////////////
			coordLbl = String(xml.@gutcoordlbl).split(",");
			res.gutcoord.d1Lbl = coordLbl[0];
			res.gutcoord.d2Lbl = coordLbl[1];
			res.gutcoord.d3Lbl = coordLbl[2];
			res.gutcoord.d4Lbl = coordLbl[3];
			res.gutcoord.d5Lbl = coordLbl[4];
			res.gutcoord.d6Lbl = coordLbl[5];
			res.gutcoord.d7Lbl = coordLbl[6];
			res.gutcoord.d8Lbl = coordLbl[7];
			//////////////////////////////////////////////////////////
			//                 STANDARD MODEL
			//////////////////////////////////////////////////////////
			////////////// COORDINATE ////////////////////////
			coord = String(xml.@smcoord).split(",");
			res.smcoord.d1 = Number(coord[0]);
			res.smcoord.d2 = Number(coord[1]);
			res.smcoord.d3 = Number(coord[2]);
			res.smcoord.d4 = Number(coord[3]);
			res.smcoord.d5 = Number(coord[4]);
			res.smcoord.d6 = Number(coord[5]);
			res.smcoord.d7 = Number(coord[6]);
			res.smcoord.d8 = Number(coord[7]);

			////////////// COORDINATE LABEL  ////////////////////////
			coordLbl = String(xml.@smcoordlbl).split(",");
			res.smcoord.d1Lbl = coordLbl[0];
			res.smcoord.d2Lbl = coordLbl[1];
			res.smcoord.d3Lbl = coordLbl[2];
			res.smcoord.d4Lbl = coordLbl[3];
			res.smcoord.d5Lbl = coordLbl[4];
			res.smcoord.d6Lbl = coordLbl[5];
			res.smcoord.d7Lbl = coordLbl[6];
			res.smcoord.d8Lbl = coordLbl[7];

			return res;
		}

		public function getScreenX(cam : Camera) : Number {
			//trace("dx " + cam.getX() + getX());
			var scale : Number = cam.focalLength / (cam.focalLength + getZ() + cam.getZ());
			//	trace("scale " + scale);
			var res : Number = cam.vpX + (cam.getX() + getX()) * scale;
			//	trace("res " + res);
			return res;
		}

		public function getScreenY(cam : Camera) : Number {
			//	trace("dy " + cam.getY() + getY());
			var scale : Number = cam.focalLength / (cam.focalLength + getZ() + cam.getZ());
			//	trace("scale " + scale);
			var res : Number = cam.vpY + (cam.getY() + getY()) * scale;
			//	trace("res " + res);
			return res;
		}

		public function getScreenZ(cam : Camera) : Number {
			var scale : Number = cam.focalLength / (cam.focalLength + getZ() + cam.getZ());
			//trace("scale " + scale);
			//var res:Number = cam.vpZ+ (cam.getZ() + getZ()) * scale;
			//trace("res " + res);
			return scale;
		}

		public function setPosition(v : EightDimensionVector) : void {
			this.curCoords.d1 = v.d1;
			this.curCoords.d2 = v.d2;
			this.curCoords.d3 = v.d3;
			this.curCoords.d4 = v.d4;
			this.curCoords.d5 = v.d5;
			this.curCoords.d6 = v.d6;
			this.curCoords.d7 = v.d7;
			this.curCoords.d8 = v.d8;
		}

		public function setX(val : Number) : void {
			//trace(modl + " modl " );
			//	trace(modl.curXaxis + " setX " + val);
			switch(modl.curXaxis) {
				case Dimension.D1:
					this.curCoords.d1 = val;
					break;
				case Dimension.D2:
					this.curCoords.d2 = val;
					break;
				
				case Dimension.D3:
					this.curCoords.d3 = val;
					break;
				
				case Dimension.D4:
					this.curCoords.d4 = val;
					break;
				
				case Dimension.D5:
					this.curCoords.d5 = val;
					break;
				
				case Dimension.D6:
					this.curCoords.d6 = val;
					break;
				
				case Dimension.D7:
					this.curCoords.d7 = val;
					break;
				
				case Dimension.D8:
					this.curCoords.d8 = val;
					break;
			}
		}

		public function getX() : Number {
			//	trace(modl.curXaxis + " getX ");
			switch(modl.curXaxis) {
				case Dimension.D1:
					return this.curCoords.d1;
				case Dimension.D2:
					return this.curCoords.d2;
				case Dimension.D3:
					return this.curCoords.d3;
				case Dimension.D4:
					return this.curCoords.d4;
				case Dimension.D5:
					return this.curCoords.d5;
				case Dimension.D6:
					return this.curCoords.d6;
				case Dimension.D7:
					return this.curCoords.d7;
				case Dimension.D8:
					return this.curCoords.d8;
			}
			trace("NO model");
			return NaN;
		}

		public function setY(val : Number) : void {
			switch(modl.curYaxis) {
				case Dimension.D1:
					this.curCoords.d1 = val;
					break;
				case Dimension.D2:
					this.curCoords.d2 = val;
					break;
				
				case Dimension.D3:
					this.curCoords.d3 = val;
					break;
				
				case Dimension.D4:
					this.curCoords.d4 = val;
					break;
				
				case Dimension.D5:
					this.curCoords.d5 = val;
					break;
				
				case Dimension.D6:
					this.curCoords.d6 = val;
					break;
				
				case Dimension.D7:
					this.curCoords.d7 = val;
					break;
				
				case Dimension.D8:
					this.curCoords.d8 = val;
					break;
			}
		}

		public function getY() : Number {
			switch(modl.curYaxis) {
				case Dimension.D1:
					return this.curCoords.d1;
				case Dimension.D2:
					return this.curCoords.d2;
				case Dimension.D3:
					return this.curCoords.d3;
				case Dimension.D4:
					return this.curCoords.d4;
				case Dimension.D5:
					return this.curCoords.d5;
				case Dimension.D6:
					return this.curCoords.d6;
				case Dimension.D7:
					return this.curCoords.d7;
				case Dimension.D8:
					return this.curCoords.d8;
			}
			return NaN;
		}

		public function setZ(val : Number) : void {
			switch(modl.curZaxis) {
				case Dimension.D1:
					this.curCoords.d1 = val;
					break;
				case Dimension.D2:
					this.curCoords.d2 = val;
					break;
				
				case Dimension.D3:
					this.curCoords.d3 = val;
					break;
				
				case Dimension.D4:
					this.curCoords.d4 = val;
					break;
				
				case Dimension.D5:
					this.curCoords.d5 = val;
					break;
				
				case Dimension.D6:
					this.curCoords.d6 = val;
					break;
				
				case Dimension.D7:
					this.curCoords.d7 = val;
					break;
				
				case Dimension.D8:
					this.curCoords.d8 = val;
					break;
			}
		}

		public function getZ() : Number {
			switch(modl.curZaxis) {
				case Dimension.D1:
					return this.curCoords.d1;
				case Dimension.D2:
					return this.curCoords.d2;
				case Dimension.D3:
					return this.curCoords.d3;
				case Dimension.D4:
					return this.curCoords.d4;
				case Dimension.D5:
					return this.curCoords.d5;
				case Dimension.D6:
					return this.curCoords.d6;
				case Dimension.D7:
					return this.curCoords.d7;
				case Dimension.D8:
					return this.curCoords.d8;
			}
			return NaN;
		}		

		public function rotateX(angleX : Number) : void {
			this.angleX = angleX;
			//	trace("rotateX " + this.angleX );
			var cosX : Number = Math.cos(angleX);
			var sinX : Number = Math.sin(angleX);
			
			var y1 : Number = getY() * cosX - this.curCoords.d3 * sinX;
			var z1 : Number = this.curCoords.d3 * cosX + getY() * sinX;
			
			setY(y1);
			this.curCoords.d3 = z1;
		}

		public function rotateY(angleY : Number) : void {
			this.angleY = angleY;
			//	trace("rotateY " + this.angleY );
			var cosY : Number = Math.cos(angleY);
			var sinY : Number = Math.sin(angleY);
			
			var x1 : Number = getX() * cosY - this.curCoords.d3 * sinY;
			var z1 : Number = this.curCoords.d3 * cosY + getX() * sinY;
			
			setX(x1);
			this.curCoords.d3 = z1;
		}

		public function rotateZ(angleZ : Number) : void {
			this.angleZ = angleZ;
			//	trace("rotateZ " + this.angleZ);
			var cosZ : Number = Math.cos(angleZ);
			var sinZ : Number = Math.sin(angleZ);
			
			var x1 : Number = getX() * cosZ - getY() * sinZ;
			var y1 : Number = getY() * cosZ + getX() * sinZ;
			
			setX(x1);
			setY(y1);
		}

		public function toString() : String {
			//			return this.d1 + " " + this.d2 + " " + this.d3;
			return  "P" + name;
		}

		public function toXMLString() : String {
			var res : String = '<p id="1" name="1" e8coordlbl="1,1,0,0,0,0,0,0" e8coord="1,1,0,0,0,0,0,0" color="lgree" symbol="mcir" label="spin connection" sm="1" />';
			return res;
		}
	}
}
