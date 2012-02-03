import massive.munit.TestSuite;

import com.troyworks.core.cogs.CogEventImporterTest;
import com.troyworks.core.cogs.FsmTest;
import com.troyworks.core.cogs.HsmTest;
import com.troyworks.core.cogs.NameSpaceTest;
import ExampleTest;
import test.FunctionSignatureTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(com.troyworks.core.cogs.CogEventImporterTest);
		add(com.troyworks.core.cogs.FsmTest);
		add(com.troyworks.core.cogs.HsmTest);
		add(com.troyworks.core.cogs.NameSpaceTest);
		add(ExampleTest);
		add(test.FunctionSignatureTest);
	}
}
