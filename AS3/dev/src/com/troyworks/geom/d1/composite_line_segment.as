package com.troyworks.geom.d1 { 
	//!-- UTF8
	trace("\t included composite_line_segment.as");
	/************************************************************
	* Manages a group of LineSegments on a larger line segment. Behavior is non-overlapping.
	*
	************************************************************/
	CompositeLineSegment = function (Name, Size, InterLineSpacingInPixels) {
		this.init(Name, Size, InterLineSpacingInPixels);
	};
	CompositeLineSegment.extend(LineSegment);
	CompositeLineSegment.prototype.init = function(Name, Size, InterLineSpacingInPixels) {
		super.init(Name, Size);
		this.A = 0;
		this.size = (Size == null) ? (100) : (Size);
		this.line_array = new Array();
		this.colSpacing = (InterLineSpacingInPixels == null) ? (1) : (InterLineSpacingInPixels);
	};
	CompositeLineSegment.prototype.addLine = function(newLineSegment) {
		if (this.line_array.length == 0) {
			//trace("adding first line");
			newLineSegment.A = 0;
			
		} else {
			//trace("adding next line " + this.line_array);
			var i = this.line_array.length-2;
			var i2 = this.line_array.length-1;
			//trace("new line's [" + i2 + "]. A " + newLineSegment.A  + " will = ["+i+"] B " +  this.line_array[i].B);
			newLineSegment.A = this.line_array[i].B;
		}
		
		this.line_array.push(newLineSegment);
		this.onLineArrayChangedHandler();
	};
	CompositeLineSegment.prototype.setLines = function(line_array) {
		//trace("CompositeLineSegment.setLines");
		this.line_array = line_array;
		this.onLineArrayChangedHandler();
	};
	////////////////////////////////////////////
	// inserts the LineSegment at postion (zero based)
	CompositeLineSegment.prototype.insertLine = function(newLineSegment, pos) {
		this.line_array.splice(pos, 0, newLineSegment);
		this.onLineArrayChangedHandler();
	};
	////////////////////////////////////////////
	// removes the LineSegment at postion (zero based)
	CompositeLineSegment.prototype.removeLineAt = function(newLineSegmentPosition) {
		public var c = (this.line_array.splice(newLineSegmentPosition, 1))[0];
		this.onLineArrayChangedHandler();
		return c;
	};
	////////////////////////////////////////////
	// swap LineSegments (zero based)
	CompositeLineSegment.prototype.swapLinePositions = function(currentLineSegmentPosition, newLineSegmentPosition) {
		//trace("swapping");
		public var c = this.line_array.splice(currentLineSegmentPosition, 1);
		trace(this);
		this.line_array.splice(newLineSegmentPosition, 0, c[0]);
		this.onLineArrayChangedHandler();
	};
	////////////////////////////////////////////
	// removes all LineSegments
	CompositeLineSegment.prototype.graphics.clear = function() {
		this.line_array = new Array();
	};
	///////////////////////////////////////////
	// reassigns the order id, Size and xposition
	// upon add,removing or changing of the array.
	CompositeLineSegment.prototype.onLineArrayChangedHandler = function() {
		//trace("CompositeLineSegment.onLineArrayChangedHandler");
		this.reIndexLines();
		//	this.fitLinesToSize();
	};
	/////////////////////////////////////////////
	// reassigns the order of the column id's to match 
	// their new position.
	CompositeLineSegment.prototype.reIndexLines = function() {
		//trace("CompositeLineSegment.reIndexLines");
		public var pos = this.line_array[0].A;
		public var len = this.line_array.length;
		public var s = 0;
		for (public var i = 0; i<len; i++) {
			public var ln = this.line_array[i];
			ln.A = pos;
			ln.id = i;
			pos = ln.B;
			s += ln.size;
			//trace("pos " + pos + " " + ln);
			//trace(" reindex " + i + "should be " + this.line_array[i].id);
		}
		this.setSize(s);
		trace(" supposed size " + s +" reIndexLines end size" + this.size);
	};
	//////////////////////////////////////////////
	// figures out how much Size/pecentageall the LineSegments take up
	// bottom up approach to layout.
	CompositeLineSegment.prototype.calcSize = function() {
		var ci = this.line_array.length;
		this.size = 0;
		this.LineTotalSize = 0;
		//trace("this.size " + this.size);
		while (ci--) {
			//trace("ci " + ci);
			//trace("this.size " + this.size);
			//  trace("this.getTotalSizeForLine("+ ci + ") " + this.getTotalSizeForLine(ci));
			//trace("this.line_array["+ ci + "].size " + this.line_array[ci].size);
			this.size += this.getTotalSizeForLine(ci);
			this.LineTotalSize += this.line_array[ci].size;
		}
		//trace("CompositeLineSegment.prototype.calcSize = "+this.size);
		//////////then reassign percentages of whole and postions.
		var xpos = 0;
		for (var ci = 0; ci<this.line_array.length; ci++) {
			public var c = this.line_array[ci];
			public var cwid = this.line_array[ci].size;
			public var cswid = this.getTotalSizeForLine(ci);
			//trace("line wid "+cwid);
			c.gpercent = cswid/this.size;
			c.percent = cwid/this.LineTotalSize;
			//trace(c.A+" 1 ");
			c.A = xpos;
			//trace(c.A+" 2 ");
			xpos += cswid;
		}
		return this.size;
	};
	////////////////////////////////////////////////////////////////////
	// gets the padding size in pixels that goes on the right of the given linepos
	CompositeLineSegment.prototype.getSpacingForLine = function(Linepos) {
		return ((Linepos == this.line_array.length-1) ? (0) : (this.colSpacing));
	};
	//////////////////////////////////////////////////////////////
	// for a given line pos get the size of it and any padding to the rights
	CompositeLineSegment.prototype.getTotalSizeForLine = function(Linepos) {
		//trace("getTotalSizeForLine ("+ Linepos + "):  " + this.line_array[Linepos].size + " - " + this.getSpacingForLine(Linepos));
		//trace(this);
		return (this.line_array[Linepos].size+this.getSpacingForLine(Linepos));
	};
	////////////////////////////////////////////////////////
	// with the given size of the grid
	// adjust all the lines to fit.
	//
	CompositeLineSegment.prototype.fitLinesToSize = function(DesiredSizeInPixels) {
		DesiredSizeInPixels = (DesiredSizeInPixels == null) ? this.size : DesiredSizeInPixels;
		var curSize = this.size;
		var cSize = this.calcSize();
		var totFlexLineSize = 0;
		var totFixedLineSize = 0;
		var totSpacerSize = 0;
		//	trace("1)" + this.toString());
		//////////////////////////////////////////////////////
		///(1) remove all that which is fixed in size,
		//	var ci = this.line_array.length;
		for (var ci in this.line_array) {
			//	while (ci--) {
			public var c = this.line_array[ci];
			public var cTotalWid = this.getSpacingForLine(ci);
			//adjust the total space taking up by spacers
			totSpacerSize += cTotalWid;
			if (c.isFixedSize) {
				totFixedLineSize += c.size;
			} else {
				totFlexLineSize += c.size;
			}
		}
		var totLineSpaceSize = DesiredSizeInPixels-totSpacerSize;
		var widToFill = DesiredSizeInPixels-totSpacerSize-totFixedLineSize;
		//trace("2)" + this.toString());
		//////////////////////////////////////////////////////
		//(3)pass adjust those that can be moved
		var widPos = 0;
		var ary = this.line_array;
		var len = ary.length;
		for (var i = 0; i<len; i++) {
			public var c = ary[i];
			if (!c.isFixedSize) {
				c.percent = c.size/totFlexLineSize;
				c.size = c.percent*widToFill;
			}
			c.percent = c.size/totLineSpaceSize;
			//trace(" c percent "+c.size+" "+totLineSpaceSize+" "+c.percent);
			c.A = widPos;
			//trace("c.pos " + c.pos);
			widPos += (c.size+this.getSpacingForLine(i));
		}
		//	trace("3)" + this.toString());
		this.size = DesiredSizeInPixels;
	};
	CompositeLineSegment.prototype.getIndexForPosition = function(pos, lowIdx, hiIdx) {
		//trace("getIndexForPosition : " + pos + " lowIdx " + lowIdx+ " hiIdx " +  hiIdx);
		var lo = (lowIdx == null)? (0):(lowIdx);
		var _ary = (hiIdx== null)?(this.line_array):(hiIdx);
		var hi = _ary.length-1;
		var mid;
		////////range check first//////////////
		if (pos <= _ary[0].m_start) {
		   return 0;
		} else if( _ary[hi].m_end<=pos){
		   return hi;
		}
		////////search through range//////////////
		while (lo<=hi) {
			mid = Math.floor((lo+hi)/2);
		//	trace(lo + " " + mid + " " + hi);
		//	trace(_ary[mid].m_start+ " " + pos + " " + _ary[mid].m_end );
			if (pos<_ary[mid].m_start) {
		//		trace("adjust  hi lower" + pos + " <  " + _ary[mid].m_start);
				hi = mid-1;
			} else if ((_ary[mid].m_end +this.getSpacingForLine(mid)) < pos) {
		//			trace("adjust low up" + (_ary[mid].m_end +this.getSpacingForLine(mid)) + " < " + pos);
				lo = mid+1;
			} else {
		//		trace("return mid " );
				return mid;
			}
		}
		//trace("couldn't find   " );
		return -1;
	};
	CompositeLineSegment.prototype.getNextPosition = function(frompos, fromIdx, above) {
		if(above){
			public var star = this.line_array[fromIdx].m_start; 
			public var end = (this.line_array[fromIdx].m_end +this.getSpacingForLine(fromIdx)) ; 
			public var atEnd = ((this.line_array.length -1) ==fromIdx);
			////(frompos < end) this minus is to deal with wierd rounding errors that get triggered improperly
			//trace("frompos " + frompos + "fromIdx " + fromIdx + " star " + star + " end " +end );
			if((Math.round(frompos - end)  < 0) || atEnd){
				trace( typeof(frompos) + " " + typeof(end));
			//	trace("returning end " + frompos + " " + end + " ?:" +  ((frompos - end)  > 0)+"  " + (frompos - end)+ " " + atEnd);
		           return end;
			}else {
			   fromIdx++;
			  //trace("returning next end idx:" + fromIdx  + " pos: " + (this.line_array[fromIdx].m_end));
			   return (this.line_array[fromIdx].m_end+this.getSpacingForLine(fromIdx));
			}
		}else{
			public var star = (this.line_array[fromIdx].m_start) ; 
			public var atStart = (0 ==fromIdx);
			if((Math.round(star - frompos)  < 0)|| atStart ){
		           return star;
			}else {
			   return this.line_array[(fromIdx - 1)].m_start;
			}
		}
		
	};
	//////////////////////////////////////////////////////
	// set a uniform name=value pair on the line array
	CompositeLineSegment.prototype.setProperty = function(name, value) {
		var ci = this.line_array.length;
		while (ci--) {
			this.line_array[ci][name] = value;
		}
	};
	CompositeLineSegment.prototype.toString = function() {
		return this.line_array.toString();
	};
	/*********************TEST CODE ***************************************
	function TestCompositeLineSegment() {
		trace("TestCompositeLineSegment()");
		_global.testCase = -1;
		var firstTest = 4;
		var lastTest = 6;
		for (var i = firstTest; i<=lastTest; i++) {
	'
			trace("Test"+i+" ------------------\r before: "+cm.toString());
			_global.testCase = i;
			switch (testCase) {
			case 1 :
				var c = cm.removeLineAt(1);
				trace("removing cell at pos[1] id="+c.id);
				break;
			case 2 :
				trace("inserting a linesegment at position [1]");
				cm.insertLine(new LineSegment("1.5", 3), 1);
				break;
			case 3 :
				trace("erasing all child lines");
				cm.graphics.clear();
				break;
			case 4 :
				var wid = cm.calcSize();
				trace("calculating Size bottom up = "+wid+" cached "+cm.size);
				break;
			case 5 :
				var wid = cm.fitLinesToSize(100);
				trace("fitting Lines to Size 100 "+wid+" cached "+cm.size);
				break;
			case 6 :
				trace("trying to swap [1] to [0]h");
				cm.swapLinePositions(1, 0);
				break;
			}
			trace(" after:"+cm.toString());
		}
	}
	TestCompositeLineSegment();
	//**************TEST CODE END**********************************************/
}