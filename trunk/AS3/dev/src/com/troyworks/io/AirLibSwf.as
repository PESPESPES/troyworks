package com.troyworks.io
{
    import flash.display.Sprite;
	import com.troyworks.io.airlib.IFile;
	import com.troyworks.io.airlib.IFileStream;
	import com.troyworks.io.airlib.IFileMode;
	
	public class AirLibSwf extends Sprite
	{
		public function AirLibSwf():void
		{
			// Need to reference the classes meant for export otherwise
			// the compiler won't add them to the SWF at all (ignoring `import`)
			IFile;
			IFileStream;
			IFileMode;
		}
	}
}