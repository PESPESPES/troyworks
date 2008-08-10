package com.troyworks.io
{
    import flash.display.Sprite;
	import com.troyworks.io.fplib.IFile;
	import com.troyworks.io.fplib.IFileStream;
	import com.troyworks.io.fplib.IFileMode;
    
	public class FpLibSwf extends Sprite
	{
		public function FpLibSwf():void
		{
			// Need to reference the classes meant for export otherwise
			// the compiler won't add them to the SWF at all (ignoring `import`)
			// Set static vars that are objects (unable to set that in definition)
			
			// TODO: make this a parameter in the main SWF
			IFile.setBasePath('http://blaze.dnc.pl/~tw/PostReceiver/files/');
			
			IFileStream;
			IFileMode;
		}
	}
}