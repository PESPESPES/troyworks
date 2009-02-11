// *****************************************************************************************
// TickingClocksExample.as
// 
// Copyright (c) 2007 Ryan Taylor | http://www.boostworthy.com
// 
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// *****************************************************************************************
// 
// +          +          +          +          +          +          +          +          +
// 
// *****************************************************************************************

// PACKAGE /////////////////////////////////////////////////////////////////////////////////

package
{
	// IMPORTS /////////////////////////////////////////////////////////////////////////////
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
//	import com.boostworthy.animation.easing.Transitions;
//	import com.boostworthy.animation.management.AnimationManager;
//	import com.boostworthy.animation.rendering.RenderMethod;
	import com.troyworks.core.tweeny.*;
	
	// SWF /////////////////////////////////////////////////////////////////////////////////
	
	// Note: If using the Flash IDE to compile, these settings will be ignored.
	[SWF(backgroundColor="#111111", frameRate="31", width="550", height="400")]
	
	// CLASS ///////////////////////////////////////////////////////////////////////////////
	
	/**
	 * This example file provides you with an example of using the animation manager 
	 * to quickly and easily create animations that simulate various clocks using 
	 * the rotation animation capabilities.
	 * <p>
	 * Instructions for use:
	 * <p>
	 * Flash IDE users - this class is already set as the document class in the 
	 * corresponding FLA file for you. Simply open the FLA file and make any 
	 * changes to this file to experiment.
	 * <p>
	 * Non-Flash IDE users - Treat this class as your 'Main' class when you compile.
	 * 
	 * @see	com.boostworthy.animation.management.AnimationManager
	 */
	public class TickingClocksExample extends Sprite
	{
		// *********************************************************************************
		// CLASS DECLERATIONS
		// *********************************************************************************
		
		// CONSTANTS ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Configures the color of the clocks.
		 */
		protected const CLOCK_COLOR:uint            = 0x006666;
		
		/**
		 * Configures the radius of the clocks.
		 */
		protected const CLOCK_RADIUS:Number         = 50;
		
		/**
		 * Configures the color of the clock hands.
		 */
		protected const CLOCK_HAND_COLOR:uint       = 0x91B197;
		
		/**
		 * Configures the width of the clock hands.
		 */
		protected const CLOCK_HAND_WIDTH:Number     = 3;
		
		/**
		 * Configures the height of the clock hands.
		 */
		protected const CLOCK_HAND_HEIGHT:Number    = 50;
		
		// MEMBERS /////////////////////////////////////////////////////////////////////////
		
		/**
		 * Holds an instance of the animation manager.
		 */
		//protected var m_objAnimationManager:AnimationManager;
		
		/**
		 * Clock sprite number one.
		 */
		protected var m_spClockOne:Sprite
		
		/**
		 * The clock hand for clock number one.
		 */
		protected var m_spClockOneHand:Sprite
		
		/**
		 * Clock sprite number two.
		 */
		protected var m_spClockTwo:Sprite
		
		/**
		 * The clock hand for clock number two.
		 */
		protected var m_spClockTwoHand:Sprite
		
		protected var m_spClockOneHandTny:Tny;
				protected var m_spClockTwoHandTny:Tny;
		// *********************************************************************************
		// EVENT HANDLERS
		// *********************************************************************************
		
		/**
		 * Constructor.
		 */
		public function TickingClocksExample()
		{
			// Initialize this object.
			init();
		}
		
		// *********************************************************************************
		// INTERNAL
		// *********************************************************************************
		
		// INIT ////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initializes this object.
		 */
		protected function init():void
		{
			// Set all default property values.
			setDefaultValues();
			
			// Create a new animation manager.
			//m_objAnimationManager = new AnimationManager();
			
			// Create clock number one.
			createClockOne();
			
			// Create clock number two.
			createClockTwo();
			
			// Create the animations for the two clocks.
			createAnimations();
		}
		
		/**
		 * Applies all default values to the corresponding properties.
		 */
		protected function setDefaultValues():void
		{
			// Apply the default values.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align     = StageAlign.TOP_LEFT;
		}
		
		// GRAPHICS ////////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates clock sprite number one for the example.
		 */
		protected function createClockOne():void
		{
			// Create a new sprite and draw the clock face.
			m_spClockOne      = new Sprite();
			m_spClockOne.name = "m_spClockOne";
			m_spClockOne.graphics.beginFill(CLOCK_COLOR);
			m_spClockOne.graphics.drawCircle(0, 0, CLOCK_RADIUS);
			
			// Create a new sprite and draw the clock hand.
			m_spClockOneHand      = new Sprite();
			m_spClockOneHand.name = "m_spClockOneHand";
			m_spClockOneHand.graphics.beginFill(CLOCK_HAND_COLOR);
			m_spClockOneHand.graphics.drawRect(-CLOCK_HAND_WIDTH / 2, -CLOCK_HAND_HEIGHT, CLOCK_HAND_WIDTH, CLOCK_HAND_HEIGHT);
			m_spClockOne.addChild(m_spClockOneHand);
			
			// Add the clock to the display container.
			addChild(m_spClockOne);
			
			// Position the clock.
			m_spClockOne.x = 200;
			m_spClockOne.y = Math.floor(stage.stageHeight / 2);
			m_spClockOneHandTny = new Tny(m_spClockOneHand);
		
		}
		
		/**
		 * Creates clock sprite number two for the example.
		 */
		protected function createClockTwo():void
		{
			// Create a new sprite and draw the clock face.
			m_spClockTwo      = new Sprite();
			m_spClockTwo.name = "m_spClockTwo";
			m_spClockTwo.graphics.beginFill(CLOCK_COLOR);
			m_spClockTwo.graphics.drawCircle(0, 0, CLOCK_RADIUS);
			
			// Create a new sprite and draw the clock hand.
			m_spClockTwoHand      = new Sprite();
			m_spClockTwoHand.name = "m_spClockTwoHand";
			m_spClockTwoHand.graphics.beginFill(CLOCK_HAND_COLOR);
			m_spClockTwoHand.graphics.drawRect(-CLOCK_HAND_WIDTH / 2, -CLOCK_HAND_HEIGHT, CLOCK_HAND_WIDTH, CLOCK_HAND_HEIGHT);
			m_spClockTwo.addChild(m_spClockTwoHand);
			
			// Add the clock to the display container.
			addChild(m_spClockTwo);
			m_spClockTwoHandTny = new Tny(m_spClockTwoHand);
			// Position the clock.
			m_spClockTwo.x = Math.floor(stage.stageWidth - 200);
			m_spClockTwo.y = Math.floor(stage.stageHeight / 2);
		}
		
		// ANIMATION ///////////////////////////////////////////////////////////////////////
		
		/**
		 * Creates animations for the two clock sprites.
		 */
		 protected function stepAnimation():void{
			 trace("steppoing Animation=================================");
			 m_spClockOneHandTny.rotation = m_spClockOneHand.rotation +6;
			m_spClockOneHandTny.duration = 1;

		 }
		 protected function stepAnimation2():void{
			 trace("steppoing Animation=================================");
			 			m_spClockTwoHandTny.rotation = m_spClockTwoHand.rotation +30;
			m_spClockTwoHandTny.duration = 5;

		 }

		protected function createAnimations():void
		{
			trace("creating Animations");
			// Create a ticking animation that emulates a typical watch for clock number one.
			//m_objAnimationManager.rotation(m_spClockOneHand, 6, 1000, 0, Transitions.ELASTIC_OUT, RenderMethod.TIMER);
			m_spClockOneHandTny.ease = Elastic.easeOut;
			m_spClockOneHandTny.onComplete = stepAnimation;
			stepAnimation();
			
			
			m_spClockTwoHandTny.ease = Linear.easeInOut;
			m_spClockTwoHandTny.onComplete = stepAnimation2;
			stepAnimation2();
			// Create a luxuriously smooth animation typical of your Rolex or Omega watch
			// for clock number two.
			//m_objAnimationManager.rotation(m_spClockTwoHand, 360, 60000, 0, Transitions.LINEAR, RenderMethod.TIMER);
		}
	}
}