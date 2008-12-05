package com.troyworks.geom.d1 { 
	//!-- UTF8
	trace("\t included line_segment.as");
	/*************************************************************************
	* The Code to represent a the line segment (shadow) projected from a datagrid Line on an implied /line axis/spectrum.
	* but may be entangled in more than one dimension (as in a grid manager).
	*
	* Here's the LineSegment Family
	* LineSegment
	*    +--Empty
	*    +--Text
	*    +--DrillDown
	*    +--CheckBox
	*    +--TextButton
	*    +--Scrollbar
	TODO:
	Constraint: minPos, maxPos on spectrum;
	minPercent, curPercent, maxPercent, 
	Alignment, absolute left, left of neighbor, center, right of neighbor absolute right.
	isFixedPostionInArray = can't be moved (e.g expander/scrollbar)
	isFixedPosition = tied to a specific location.
	
	************************************************************/
	public function line_segment() {
		
	}
	LineSegment = function (Name, CurSizeInPixels) {
		this.init(Name, CurSizeInPixels);
	};
	LineSegment.prototype.init = function(Name, CurSizeInPixels) {
		this.name = Name;
		this.id = -1;
		this.m_start = 0;
		this.m_end = 0;
		this.m_percent = 0;
		//original
		this.o_Size = CurSizeInPixels;
		this.o_percent = SizeInPercent;
		//
		this.minSize = null;
		this.size = CurSizeInPixels;
		this.maxSize = null;
		this.isFixedSize = false;
		this.isFixedPosition = false;
		this.isCollapsed = false;
		this.delimiter = (_global.labelData.THOUSANDSEP == null) ? ',' : _global.labelData.THOUSANDSEP;
		//trace("new LineSegment "+this.toString());
	};
	LineSegment.prototype.setMinSize = function(val) {
		this.c_minSize = (val == null) ? (0) : (val);
		if (this.c_minSize != null && this.o_Size<this.c_minSize) {
			this.o_Size = this.c_minSize;
		}
	};
	LineSegment.prototype.getMinSize = function() {
		return this.c_minSize;
	};
	LineSegment.prototype.setMaxSize = function(val) {
		this.c_maxSize = val;
		if (this.c_maxSize != null && this.c_maxSize<this.o_Size) {
			this.o_Size = this.c_maxSize;
		}
	};
	LineSegment.prototype.getMaxSize = function(val) {
		return this.c_maxSize;
	};
	LineSegment.prototype.setSizeConstraint = function(minSize, maxSize) {
		this.minSize = (minSize == null) ? (0) : (minSize);
		this.maxSize = (maxSize == null) ? (null) : (maxSize);
		if (this.minSize == this.Size && this.maxSize == this.Size) {
			this.isFixedSize = true;
		}
	};
	LineSegment.prototype.setFixedSize = function(desiredSize) {
		this.setSize(desiredSize);
		this.setSizeConstraint(desiredSize, desiredSize);
	};
	LineSegment.prototype.getIsFixedSize = function() {
		if (this.c_minSize == this.o_Size && this.c_maxSize == this.o_Size) {
			return true;
		} else {
			return false;
		}
	};
	LineSegment.prototype.setSize = function(SizeInPixels, isFixedSize) {
		//trace("LineSegment.setSize " + SizeInPixels);
		public var val = SizeInPixels;
		if (isFixedSize == null || !isFixedSize) {
			if (this.c_minSize != null) {
				val = (SizeInPixels<this.c_minSize) ? this.c_minSize : SizeInPixels;
			}
			if (this.c_maxSize != null) {
				val = (this.c_maxSize<SizeInPixels) ? this.c_maxSize : SizeInPixels;
			}
		} else {
			this.c_minSize = SizeInPixels;
			this.c_maxSize = SizeInPixels;
		}
		this.o_Size = val;
		this.m_end = this.m_start+this.o_Size;
	};
	LineSegment.prototype.getSize = function() {
		//trace("LineSegment.getSize " + this.o_Size);
		return this.o_Size;
	};
	LineSegment.prototype.setStartPoint = function(val) {
		//trace("LineSegment.setStartPoint:"+val + " typeof " + typeof(val));
		this.m_start = val;
		this.m_end = val+this.o_Size;
	};
	LineSegment.prototype.getStartPoint = function() {
		//trace("LineSegment.getStartPoint");
		return this.m_start;
	};
	LineSegment.prototype.setEndPoint = function(val) {
		//trace("LineSegment.setEndPoint"+val);
		this.m_end = val;
		this.m_start = val-this.o_Size;
	};
	LineSegment.prototype.getEndPoint = function(val) {
		//trace("LineSegment.getStartPoint");
		return this.m_end;
	};
	LineSegment.prototype.setPercent = function(val) {
		//trace("LineSegment.setPercent"+val);
		this.m_percent = val;
	};
	LineSegment.prototype.getPercent = function(val) {
		//trace("LineSegment.getPercent");
	
		return this.m_percent;
	};
	LineSegment.prototype.isInBounds = function(pos, inclusive) {
		//trace("LineSegment.isInBounds");
		if (inclusive) {
			return (this.m_start<=pos && pos<=this.m_end);
		} else {
			return (this.m_start<pos && pos<this.m_end);
		}
	};
	LineSegment.prototype.makeInBounds = function(pos) {
		if (pos<this.m_start) {
			return this.m_state;
		} else if (this.m_end<pos) {
			return this.m_end;
		} else {
			return pos;
		}
	};
	/////---------------------These have to go AFTER the functions are declared -------------------------------///
	LineSegment.prototype.addProperty("minSize", LineSegment.prototype.getMinSize, LineSegment.prototype.setMinSize);
	LineSegment.prototype.addProperty("maxSize", LineSegment.prototype.getMaxSize, LineSegment.prototype.setMaxSize);
	LineSegment.prototype.addProperty("isFixedSize", LineSegment.prototype.getIsFixedSize, null);
	LineSegment.prototype.addProperty("A", LineSegment.prototype.getStartPoint, LineSegment.prototype.setStartPoint);
	LineSegment.prototype.addProperty("B", LineSegment.prototype.getEndPoint, LineSegment.prototype.setEndPoint);
	LineSegment.prototype.addProperty("size", LineSegment.prototype.getSize, LineSegment.prototype.setSize);
	LineSegment.prototype.addProperty("percent", LineSegment.prototype.getPercent, LineSegment.prototype.setPercent);
	LineSegment.prototype.toString = function() {
		return "\r[ "+this.id+", \t '"+this.name+"', \t A:'"+this.m_start+"', \t B:'"+this.m_end+"' \t  size:'"+this.size+"' \t '"+(this.percent*100)+"'% \t fixed:"+this.isFixedSize+" ]";
	};
	
	
	/***********TEST CODE************************
	var c1 = new LineSegment("one", 10);
	trace(c1+" b? "+c1.B + " test: " + (c1.A==0) + " " + (c1.B == 10));
	c1.A = 5;
	trace(c1 + " test: " + (c1.A==5) + " " + (c1.B == 15));
	c1.B = 8;
	trace(c1+ " test: " + (c1.A==-2) + " " + (c1.B == 8));
	c1.size= 50;
	trace(c1+ " test: " + (c1.A==-2) + " " + (c1.B == 48));
	c1.minSize = 5;
	c1.size = 2;
	trace(c1+ " test: " + (c1.A==-2) + " " + (c1.B == 3));
	c1.maxSize = 5;
	c1.size = 12;
	trace(c1+ " test: " + (c1.A==-2) + " " + (c1.B == 3));
	//***************************************/
	
}