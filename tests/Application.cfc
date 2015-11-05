/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	
	include '/config/applicationSettings.cfm';

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	// Map back to its root
	rootPath = '/tests/specs/';   //REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings[ "/testbox" ] = rootPath;
	// Map resources
	this.mappings[ "/coldbox" ] = this.mappings[ "/tests" ] & "resources/coldbox";
	
	// any orm definitions go here.
	
	include '/config/appcfc/onApplicationStart_method.cfm';
	include '/config/appcfc/onRequestStart_method.cfm';

}