
package com.troyworks.logging {
	import flash.text.TextField;	
	import flash.display.MovieClip;	

	import com.troyworks.util.Trace;	

	import flash.net.XMLSocket;

	/**
	 * This is a very simple program designed to demostrate that MTASC is building
	 * correctly.
	 * http://www.mtasc.org/
	 * 
	 * MTasc Arguments are:
	 * 
	 * FLASH7
	 *  -swf build/MTASCTest.swf -main -header 800:600:20 
	 * or
	 * FLASH8
	 *  -swf build/MTASCTest.swf -main -header 800:600:20 -version 8
	 *  
	 * Here's a full blown one for command line.
	 *   C:\DATA_SYNC\CodeProjects\mtasc-1.12\mtasc.exe -swf build/MTASCTest.swf -main -header 800:600:20    -cp "C:\DATA_SYNC\CodeProjects\workspace\TroyWorks - dev\src"  -cp "C:\DATA_SYNC\CodeProjects\Actionscript AS 2.0\lib"  -cp "C:\DATA_SYNC\CodeProjects\workspace\TroyWorks - tests\src"  -cp C:\DATA_SYNC\CodeProjects\mtasc-1.12\std  MTascTest
	 * 
	 * 
	 * MMC arguments are
	 *  CODE:
	import com.troyworks.framework.logging.TestSOSLogger ;
	TestSOSLogger.main(this);
	 * @author Troy Gardner
	 */
	class TestSOSLogger extends MovieClip {
		public static var _libSOS : Function;
		static var app : TestSOSLogger;
		private var logger : SOSLogger;
		private var csock : XMLSocket;
		private var msock : XMLSocket;

		//necessary to include for compiliation.
		function TestSOSLogger() {
			super();
			// creates a 'tf' TextField size 800x600 at pos 0,0
			var txt : TextField = new TextField();
			txt.x = 0;
			txt.y = 0;
			txt.width = 800;
			txt.height = 600;
			// write some text into it
			txt.text = "Hello world ! \r Socket Connect?:";
			addChild(txt);
			runTests();
		}

		public function runTests() : void {
			//testShow();
			//Note that this demonstrates the collapisble messages
			//testSOS_CommandIdentify();
			//testFlashDebugIntegration();
			traceOutputTests();
			trace("testing section break....");
		//testSection_________________________________Break();

		//trace("testingSOS_Command1");
		//testSOS_Command1();
		//trace("testingSOS_Command2");
		//testSOS_Command2();
		//----------------//
		//testMessageColoring();
	//	testSection_________________________________Break();
	//	testSOS_foldedMessage();
	//			testSection_________________________________Break();
	//	testSOS_foldedMessage();
		
	//	testSOS_foldedMessage2();
		//testErrorMessage();
	//	testSOS_addCommand();
	//	testSOS_removeCommand_MenuItem();
	//	testSOS_removeCommand_Menu();
		
	//	testErrorDialog();
		//testLoginDialogBox();
		//testDialogWithComboBox();
		//testHide();
	//	testShowLogClients();
//		testSOSLoggerMessageColoring();
	//	testSOSLoggerMessageColoring2();
	//	testSOSLoggerMessageColoring3();
		}

		public function traceOutputTests() : void {
			trace("number " + 1);
			trace("string" + new String("HelloWorld"));
			trace("error " + "error message"); 
			//won't work
			trace("ERROR " + "error message2"); 
			//will work
			trace("WARNING " + "warning message");
			trace("INFO " + "info message");
			trace("HIGHLIGHT " + "highlight message");
			trace("\\\\\\\\\\\\\\\\ " + "start section message");
			var _ary : Array = ["A","B","C","D"];
			trace("array1 " + _ary);
			trace("array2 " + util.Trace.me(_ary, "Array2", true));
			trace("////////////////// " + "end section message");
		}

		public function testSOSLogger_BasicData() : void {
			logger = SOSLogger.getInstance("TestSOSLogger");
			logger.log(1,"Hello From SOSLogger");
			logger.logBreak();
			var _ary : Array = ["A","B","C","D"];
			logger.log(1, "Array");
			logger.log(2,_ary.toStint());
			logger.logBreak();
			logger.log(1,Trace.me(_ary, "Array2", true));
			logger.logBreak();
			logger.sos.showMessage("Message to SOS");
			logger.clearLog();
			testMessageColoring();
		}

		/*
		 * Note Mtasc won't let you compile things that would normally slip by in the IDE
		 * e.g. trace(bob), and trace("somethin;" + someThing);
		 * Error opening URL "file:///C|/DATA%5FSYNC/CodeProjects/workspace/TroyWorks%20%2D%20tests/src/jumaksdfjadsfjadsfads.swf"
		 * Warning: Reference to undeclared variable, 'bob'
		 * undefined
		 * Warning: callFunction is not a function
		 * Warning: Reference to undeclared variable, 'someThing'
		 * something: undefined
		 */
/*
		public function testFlashDebugIntegration() : void {
			trace("attempting to load a bogus movie");

			trace("hello world");

			//	trace(bob);
			callFunction();
			var something = 5;

			//	trace("something: " + someThing);

			var _mc : MovieClip = _root.createEmptyMovieClip("testxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", 10);
			_mc.loadMovie("jumaksdfjadsfjadsfads.swf");
		}*/

		public function getCommandSocket() : XMLSocket {
			if(csock == null) {
				var 	csock : XMLSocket = new XMLSocket();
				csock.connect("localhost", 4445);
				//WARNING: any one of these are needed for traces to show up
				// this for MTASC to keep it around
				//	_root.csock = csock;
				//	_global.csock = csock;
				this.csock = csock;
			}
			return csock;		
		}

		public function getMessageSocket() : XMLSocket {
			if(msock == null) {
				var 	msock : XMLSocket = new XMLSocket();
				msock.connect("localhost", 4444);
	//WARNING: any one of these are needed for traces to show up
		// this for MTASC to keep it around
		//	_root.csock = csock;
		//	_global.csock = csock;
			}
			this.msock = msock;
			return msock;		
		}

		/////////////////////////////////////////////////////////////////////////////////////
		//                   TEST SECTION BEGINS 
		////////////////////////////////////////////////////////////////////////////////////
		public function testSOSLoggerMessageColoring() : void {
			trace("testing message coloring");
			SOSLogger.getInstance("testSOSLoggerMessageColoring");
			var 	msock : XMLSocket = getCommandSocket();
			////////////////////////////////
			//these are done in pink
			csock.send("<clear/>");
			csock.send("<setKey><name>FATAL</name><color>" + 0xdd0000 + "</color></setKey>\n");
			csock.send("<setKey><name>WARNING</name><color>" + 0xFFcc00 + "</color></setKey>\n");
			csock.send("<setKey><name>INFO</name><color>" + 0xffcccc + "</color></setKey>\n");
			csock.send("<setKey><name>DEBUG</name><color>" + 0xccffff + "</color></setKey>\n");

			csock.send("<setKey><name>START</name><color>" + 0x63CF00 + "</color></setKey>\n");
			csock.send("<setKey><name>END</name><color>" + 0xCC6666 + "</color></setKey>\n");

			csock.send("<setKey><name>HILIGHT_YELLOW</name><color>" + 0xF7EB7B + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_ORANGE</name><color>" + 0xFFD7A5 + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_GRAPE</name><color>" + 0xC671A5 + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_SKYBLUE</name><color>" + 0x9CD7F7 + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_PURPLE</name><color>" + 0xC6BAF7 + "</color></setKey>\n");

			csock.send("<setKey><name>HILIGHT_LEMON</name><color>" + 0xFFF3B5 + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_LIME</name><color>" + 0xCCFF99 + "</color></setKey>\n");
			csock.send("<setKey><name>HILIGHT_TURQUOISE</name><color>" + 0x73C3CE + "</color></setKey>\n");
			/////////////////////
			csock.send("<showMessage key='FATAL'>FATAL!</showMessage>\n");
			//built in
			csock.send("<showMessage key='FlashError'> FlashErrore</showMessage>\n");
			csock.send("<showMessage key='WARNING'>WARNING!</showMessage>\n");
			csock.send("<showMessage key='INFO'>INFO!</showMessage>\n");
			csock.send("<showMessage key='DEBUG'>DEBUG!</showMessage>\n");
			csock.send("<showMessage key='START'>START!</showMessage>\n");
			csock.send("<showMessage key='END'>END!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_YELLOW'>HILIGHT_YELLOW!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_ORANGE'>HILIGHT_ORANGE!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_GRAPE'>HILIGHT_GRAPE!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_SKYBLUE'>HILIGHT_SKYBLUE!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_PURPLE'>HILIGHT_PURPLE!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_LEMON'>HILIGHT_LEMON!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_LIME'>HILIGHT_LIME!</showMessage>\n");
			csock.send("<showMessage key='HILIGHT_TURQUOISE'>HILIGHT_TURQUOISE!</showMessage>\n");
		}

		public function testSOSLoggerMessageColoring2() : void {
			trace("testing message coloring");
			var sos : SOSLogger = SOSLogger.getInstance("testSOSLoggerMessageColoring");

			sos.fatal("My Fatal");
			sos.severe("My Severe");
			sos.flash_error("My Error");
			sos.warn("My Warning");

			sos.info("My Info");

			sos.debug("My Debug");
			//////////////////////////////////////////////////
			sos.startSig("My Start Sig");
			sos.endSig("My End Sig");
			//////////////////////////////////////////////////
			sos.logLevel(LogLevel.HILIGHT_GRAPE, "Custom Highlight");
			sos.highlight("Highlight Plain");
		}

		public function testSOSLoggerMessageColoring3() : void {
			trace("testing message coloring");
			var sos : SOSLogger = SOSLogger.getInstance("testSOSLoggerMessageColoring");
			var _ary : Array = ["A","B","C","D"];
			sos.fatal("My Fatal\r" + _ary.join("\r"));
			sos.severe("My Severe");
			var o : Object = new Object();
			o.id = 1;
			o.name = "Jem";
			o.dob = new Date();
			o.oldEnoughToDrink = false;
			o.age = 3.5;
		
			sos.logLevel(LogLevel.HILIGHT_GRAPE, "Custom Highlight" + util.Trace.me(_ary, "my ary", false));
			var s : String = util.Trace.me(o, " my object", true);
			trace("obj: " + s);
			sos.highlight("Highlight Plain" + s);
		}

		//Note that this demonstrates the collapisble messages
		public function testSOS_CommandIdentify() : void {
			var csock : XMLSocket = getCommandSocket();

			csock.send("<commands>" + "<appName>Some Name</appName>" + "<appColor>16768477</appColor>" + "<identify/>" + "<showMessage>Test</showMessage>" + "</commands>\n");
		}

		public function testSOS_Command2() : void {
			var csock : XMLSocket = getCommandSocket();
			csock.send("sos connected " + (new Date()).toString());
			csock.send("<appName>Some Name</appName>\n");
			csock.send("<appColor>16768477</appColor>\n");
			csock.send("<identify/>\n");
			csock.send("<showMessage>Test</showMessage>\n");
		}

		public function testSOS_addCommand() : void {
			var csock : XMLSocket = getCommandSocket();
			csock.send("<commands>" + '<addCommand menu="My MenuName" item="My MenuItemName" mask="0" key="116">[command]</addCommand>' + "</commands>\n");
		}

		public function testSOS_removeCommand_MenuItem() : void {
			var csock : XMLSocket = getCommandSocket();
			csock.send("<commands>" + '<removeCommand menu="My MenuName" item="My MenuItemName" mask="0" key="116">[command]</removeCommand>' + "</commands>\n");
		}

		public function testSOS_removeCommand_Menu() : void {
			var csock : XMLSocket = getCommandSocket();
			csock.send("<commands>" + '<removeCommand menu="root" item="My MenuName" mask="0" key="116">[command]</removeCommand>' + "</commands>\n");
		}

		/*****************************************************
		 *  Note multi levels nesting doesn't work
		 */
		public function testSOS_foldedMessage() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<setKey><name>MyFirstKey</name><color>" + 0xffcccc + "</color></setKey>\n");

			msock.send("<showFoldMessage key='MyFirstKey'>" + "<title>foldMessage1</title>" + "<message>This is a multiline message:\nShow some Object...\n\ta: 1,\n\tb: 2</message>" + "</showFoldMessage>");

			msock.send("<showFoldMessage>" + "<title>foldMessage2 - without key</title>" + "<message>This is a multiline message:\nShow some Object...\n\ta: 1,\n\tb: 2</message>" + "</showFoldMessage>");
		}

		/*****************************************************
		 *  Note multi levels nesting doesn't work
		 */
		public function testSOS_foldedMessage2() : void {
			var 	csock : XMLSocket = getCommandSocket();
			csock.send("<setKey><name>MyFirstKey</name><color>" + 0xffcccc + "</color></setKey>\n");

			csock.send("<showFoldMessage key='MyFirstKey'>" + "<title>foldMessage2a</title>" + "<message>This is a multiline message:\nShow some Object...\n\ta: 1,\n\tb: 2</message>" + "<showFoldMessage>" + "<title>foldMessage2b - without key</title>" + "<message>This is a multiline message:\nShow some Object...\n\ta: 1,\n\tb: 2</message>" + "</showFoldMessage>" + "</showFoldMessage>");
		}

		/**************************************
		 * if the user clicked on the X button instead of minimize this will
		 * restore the SOS window
		 */
		public function testShow() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<show/>" + "</commands>\n");
		}

		/**************************************
		 * this will hide the SOS window as if the user clicked on the X button (instead of minimize) 
		 */
		public function testHide() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<hide/>" + "</commands>\n");				
		}

		/*********************************************
		 *  this will exit the SOSClient all together.
		 */
		public function testExit() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<exit/>" + "</commands>\n");
		}

		/*********************************************
		 *  this pops up a dialog for  user name and password
		 */
		public function testLoginDialogBox() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<showDialog>" + "<title>FCAdmin - Login</title>" + "<description>Please enter your Server and Login.</description>" + "<component>" + '<input name="Host" param="$host" value="fc.powerflasher.de" />' + '<input name="Port" param="$port" value="1111" />' + '<input name="Username" param="$username" value="admin" />' + '<inputPassword name="Password" param="$password" value="password" />' + "</component>" + "<execute>" + '<sendApp name="FCAdmin"><![CDATA[<selectInstance inst="$inst"/>]]></sendApp>' + "</execute>" + "</showDialog>" + "</commands>\n");
		}

		/*********************************************
		 *  this pops up a dialog with a combo box with 3 elements in it
		 *  once selected sends the command
		 */
		public function testDialogWithComboBox() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<showDialog>" + "<title>FCAdmin - Select Instance</title>" + "<description>Please select a FlashCom Instance</description>" + "<component>" + '<comboBox name="Instance" param="$inst">' + '<item name="Instance Name 1"/>' + '<item name="Instance Name 2"/>' + '<item name="Instance Name 3"/>' + "</comboBox>" + "</component>" + "<execute>" + '<sendApp name="FCAdmin"><![CDATA[<selectInstance inst="$inst"/>]]></sendApp>' + "</execute>" + "</showDialog>" + "</commands>\n");
		}

		/*********************************************
		 *  this pops up an error dialog box
		 */

		public function testErrorDialog() : void {
			var 	csock : XMLSocket = getCommandSocket();
			csock.send("<commands>" + "<showError title='mytitle' msg='somemessage'>" + "<title>MyErrorTitle</title>" + "<message>MyErrorMessage</message>" + "</showError>" + "</commands>\n");
		}

		public function testErrorMessage() : void {
			var 	csock : XMLSocket = getCommandSocket();
			////////////////////////////////
			//built in these are done in red
			csock.send("<showMessage key='FlashError'> Here's an error message</showMessage>\n");
		}

		/*********************************************
		 *  Shows how many clients and there names are currently connected
		 *  
		 *  e.g.
		 *  Name:unknown IP:/127.0.0.1
		1 Clients connected
		 */

		public function testShowLogClients() : void {
			var 	msock : XMLSocket = getCommandSocket();
			msock.send("<commands>" + "<showLogClients/>" + "</commands>\n");
		}

		public function testSection_________________________________Break() : void {
			var 	msock : XMLSocket = getMessageSocket();
			////////////////////////////////
			//these are done in pink
			msock.send("<setKey><name>SectionBreak</name><color>" + 0xcccccc + "</color></setKey>\n");
			msock.send("<showMessage key='SectionBreak'>====================================================================================================</showMessage>\n");
		}

		public function testMessageColoring() : void {
			var 	msock : XMLSocket = getMessageSocket();
			////////////////////////////////
			//these are done in pink
			msock.send("<setKey><name>MyFirstKey</name><color>" + 0xffcccc + "</color></setKey>\n");
			msock.send("<showMessage key='MyFirstKey'>Hallo1!</showMessage>\n");
			msock.send("<showMessage key='MyFirstKey'>Hallo2!</showMessage>\n");
		
			//////////////////////////////
			//these are done in blue
			msock.send("<setKey><name>MySecondKey</name><color>" + 0xccffff + "</color></setKey>\n");
			msock.send("<showMessage key='MySecondKey'>Hallo1!</showMessage>\n");
			msock.send("<showMessage key='MySecondKey'>Hallo2!</showMessage>\n");
			/////////////////////////////////
			// these are done in plain (or rather whatever the connection was colored in)
			msock.send("<showMessage>No Key Here! ... uses Connection Color!</showMessage>\n");
		}
	}
}