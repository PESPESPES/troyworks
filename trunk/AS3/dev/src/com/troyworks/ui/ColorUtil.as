/**
* ...
* @author Default
* @version 0.1
*/

package com.troyworks.ui {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ColorUtil {
		public static const BLACK:uint = 0x000000;
		public static const GRAY1:uint = 0x111111;
		public static const GRAY2:uint = 0x222222;
		public static const GRAY3:uint = 0x333333;
		public static const GRAY4:uint = 0x444444;
		public static const GRAY5:uint = 0x555555;
		public static const GRAY6:uint = 0x666666;
		public static const GRAY7:uint = 0x777777;
		public static const GRAY8:uint = 0x888888;
		public static const GRAY9:uint = 0x999999;
		public static const GRAYA:uint = 0xAAAAAA;
		public static const GRAYB:uint = 0xBBBBBB;
		public static const GRAYC:uint = 0xCCCCCC;
		public static const GRAYD:uint = 0xDDDDDD;
		public static const GRAYE:uint = 0xEEEEEE;
		public static const WHITE:uint = 0xFFFFFF;
		public static const ALL_SHADES:Array = [BLACK,GRAY1,GRAY2,GRAY3,GRAY4,GRAY5,GRAY6,GRAY7,GRAY8,GRAY9,GRAYA,GRAYB,GRAYC,GRAYD,GRAYE,WHITE];
		public function ColorUtil() {
			
		}
		public static function getBestBWContrastFrom(rgb:uint, crossOverToWhiteAT:uint = 162):uint{
			var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
			var res:Number = (cR + cG + cB)/3;
			//trace("cR " + cR + " cG " + cG + " cB " + cB + " = " + res + "/ "+ crossOverToWhiteAT+ " less than cross " + (res < crossOverToWhiteAT) );
			if(res > crossOverToWhiteAT){
				return BLACK;
			}else{
				return WHITE;
			}
			
		}
		public static function getSaturationFromRGB(rgb:uint):Number{
			var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
			var max:Number = Math.max(Math.max(cR, cG),cB);
			var min:Number = Math.min(Math.min(cR , cG), cB);
     
	
     
			var saturation:Number = 0;
			if(max != 0){
				saturation = 1 - min/max;
			}
			return saturation;
		}
		public static function getAverageLuminosity(arrayRGB:Array):Number{
			var len:int = arrayRGB.length;
			var tot:Number = 0;
			while(len--){
				tot +=getSaturationFromRGB((arrayRGB[len] as ColorStatistic).rgb);
			}
			var res = tot/arrayRGB.length;
			return res;
		}
/*http://blog.paranoidferret.com/index.php/2007/08/22/javascript-interactive-color-picker/
 * public static  function calculateHSV()
    {
					var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
      var max = Math.max(Math.max(red, green), blue);
      var min = Math.min(Math.min(red, green), blue);
     
      value = max;
     
      saturation = 0;
      if(max != 0)
        saturation = 1 - min/max;
       
      hue = 0;
      if(min == max)
        return;
     
      var delta = (max - min);
      if (red == max)
        hue = (green - blue) / delta;
      else if (green == max)
        hue = 2 + ((blue - red) / delta);
      else
        hue = 4 + ((red - green) / delta);
      hue = hue * 60;
      if(hue <0)
        hue += 360;
    }*/
		public static function getDistanceFromShade(rgb:uint):Number{
			var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
			var lowest:uint;
			var mid1:uint;
			var mid2:uint;
			//find the lowest color
			if(cR == cG && cG == cB){
				//found a gray, black or white
				return 0;
			}else if(cR < cG && cR < cB){
			   lowest = cR;	
			   mid1 = cG;
			   mid2 = cB;
			}else if(cG < cR && cG < cB){
				lowest = cG;	
				mid1 = cR;
			    mid2 = cB;
			}else if(cB < cG && cB < cR){
				lowest = cB;	
				mid1 = cG;
			    mid2 = cR;
			}
			var distanceFromShade:Number = Math.sqrt(Math.pow((cG - lowest),2)+Math.pow((cB - lowest),2));
			return distanceFromShade;
		}
			
		/* From
		 * http://www.latiumsoftware.com/en/articles/00015.php
		 * 
		 * find the highest color component, ratchet up and down
		 * from white to black keeping the same color balance.
		 * */
		public static function getHues(rgb:uint, len:int = 10):Array{
			var res:Array = new Array();
			var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
			trace("IN r " + cR + " g " + cG + " b " + cB);
			
			
			var nRGB:uint;
			var hR:uint;
			var hG:uint;
			var hB:uint;
			var p:Number;
			for (var i:int = 0; i < len; i++){
				p =  i/len;
				hR = cR * p;
				hG = cG * p;
				hB = cB *p;
				trace("r " + hR + " g " + hG + " b " + hB);
				
				nRGB = (hR << 16 |  hG << 8 | hB);
				trace("adding new Hue" + nRGB);
				res.push(nRGB);
			}
			return res;
		}
		/* from 
		 * http://www.latiumsoftware.com/en/articles/00015.php
		 * mix with each color of gray average out
		 * 
		 *           orange   gray
			Red   = (  255  + 128 ) / 2 = 192
			Green = (  128  + 128 ) / 2 = 128
			Blue  = (   0   + 128 ) / 2 = 64
		*/
		public static function getShades(rgb:uint):Array{
			var res:Array = new Array();
			var cR:uint;
			var cG:uint;
			var cB:uint;
			cR = rgb >>16;
			cG = rgb >>8 & 0xFF;
			cB = rgb & 0xFF;
			var sRGB:uint;
			var nRGB:uint;
			var lR:uint;
			var lG:uint;
			var lB:uint;
			var hR:uint;
			var hG:uint;
			var hB:uint;
			
			for (var i:int = 0; i < ALL_SHADES.length; i++){
				sRGB = ALL_SHADES[i];
				lR = sRGB  >>16;
				lG = sRGB  >>8 & 0xFF;
				lB = sRGB  & 0xFF;
				hR = (cR + lR)/2;
				hG = (cG + lG)/2;
				hB = (cB + lB)/2;
				nRGB = (hR << 16 |  hG << 8 | hB);
				res.push(nRGB);
			}
			return res;
		}

		/*		var clip:Bitmap = Bitmap(Loader(event.target.loader).content);
	var res:Array = ColorUtil.indexColors(clip);	
		 * for(var i = 0; i < 10; i++){
				trace(res[i].rgb + " = " + res[i].total);
			}*/
		public static function indexColors(bitmap:*):Array{
			
			var res:Array = new Array();
			var idx:Dictionary = new Dictionary();
			var bd:BitmapData = (bitmap is Bitmap)? (bitmap as Bitmap).bitmapData: bitmap as BitmapData;
			var i:int = bd.width;
			var j:int = 0;
			var k:String;
			var rgb:uint;
			trace(" indexingBitmap w " + bd.width + " h " + bd.height);
			var colors:int = 0;
			while(i--){
				j = bd.height;
				while(j--){
					rgb = bd.getPixel(i,j);
	//				trace(" i "+ i + " j " + j + " = " + rgba);
					if(idx[rgb] == null){
						idx[rgb] = 1;
						colors++;
					}else{
						idx[rgb]++;
					}
					
				}
			}

			

			
			for(k in idx){
				res.push( new ColorStatistic(parseInt(k), idx[k],idx[k]/colors));
			}
			res.sortOn("total", Array.NUMERIC | Array.DESCENDING);

			return res;
		}
		/*
		 * algorithm from 
		 * http://www.axiomx.com/posterize.htm
		* The function works with integers between 2 and 255. Lower numbers produce more dramatic results.
		* Because it works with an image object, there's no need to use return to pass it back to the handler that called it.
		*/
		public static function posterize(bitmap:*, posterizeValue:int):BitmapData{
			//thisImage, thisW, thisH, thisValue
			var res:BitmapData;
			
			 if (posterizeValue == 0 ||  posterizeValue < 2 || posterizeValue > 255){
				 throw new Error("posterize value must be between 2 and 255");
			 }
			 //-- First divide 256 possible values by the posterize value to get the number of color areas.
				var  numOfAreas:Number = 256.0000 / posterizeValue;
			// -- Then the number of color values between 0 and 255 that are defined by the boundaries between the above color areas.
		//-- To understand how this works, remember that it only takes 1 line to divide a rectangle into 2 areas.
			var numOfValues:Number = 255.0000 / (posterizeValue - 1);


			var bd:BitmapData = (bitmap is Bitmap)? (bitmap as Bitmap).bitmapData: bitmap as BitmapData;
			res = new BitmapData(bd.width, bd.height);
			var i:int = bd.width;
			var j:int = 0;

			var rgb:uint;
			trace(" indexingBitmap w " + bd.width + " h " + bd.height);
			var currentRed :uint;
			var currentGreen :uint;
			var currentBlue :uint;
	
			var redAreaFloat:Number;
			var redArea :Number;
			var newRed:Number;
			var newRedFloat:Number;

			var greenAreaFloat:Number;
			var greenArea :Number;
			var newGreen:Number;
			var newGreenFloat:Number;

			var blueAreaFloat:Number;
			var blueArea :Number;
			var newBlue:Number;
			var newBlueFloat:Number;

			while(i--){
				j = bd.height;
				while(j--){
					rgb = bd.getPixel(i,j);
	//				trace(" i "+ i + " j " + j + " = " + rgba);
					currentRed  = rgb >>16;
					currentGreen  = rgb >> 8 & 0xFF;
					currentBlue  = rgb  & 0xFF;
				 // First, we need to find the color area that the pixel's red value falls within.
					  // The result has to be an parseInt, but it can't be rounded to the higher value.
					  // Since we're working with floating point numbers, there's no graceful way to convert them to parseInts without rounding.
					  // So we have to create 2 variables and perform a comparison to get the correct number.
					  // Divide the pixel's value by the number of color areas to get the floating point number.
					  redAreaFloat = currentRed / numOfAreas;
					  // Round it to the nearest parseInt.
					  redArea = Math.round(redAreaFloat);
					  // if( the number was rounded to the higher value, subtract 1 from it.
					  if( redArea > redAreaFloat ){ redArea = redArea - 1;}
					  // Now we can find the pixel's new color value. Again we need to create 2 variables to compare.
					  // Multiply the number of color values by pixel's color area to get the fraction.
					  newRedFloat = numOfValues * redArea;
					  // Round it.
					  newRed = Math.round(newRedFloat);
					  // if( the number was rounded to the higher value, subtract 1 from it.
					  if( newRed > newRedFloat ){ newRed = newRed - 1;}

					  // Do the same for the pixel's green and blue values.

					  greenAreaFloat = currentGreen / numOfAreas;
					  greenArea = Math.round(greenAreaFloat);
					  if( greenArea > greenAreaFloat ){ greenArea = greenArea - 1;}
					  newGreenFloat = numOfValues * greenArea;
					  newGreen = Math.round(newGreenFloat);
					  if( newGreen > newGreenFloat ){ newGreen = newGreen - 1;}

					  blueAreaFloat = currentBlue / numOfAreas;
					  blueArea = Math.round(blueAreaFloat);
					  if( blueArea > blueAreaFloat ){ blueArea = blueArea - 1;}
					  newBlueFloat = numOfValues * blueArea;
					  newBlue = Math.round(newBlueFloat);
					  if( newBlue > newBlueFloat ){ newBlue = newBlue - 1;}

					  // Set the pixel to the new color.
					  res.setPixel(i, j, (newRed << 16 |  newGreen << 8 | newBlue));
					
				}
			}
			return res;
		}
	}
	
}
