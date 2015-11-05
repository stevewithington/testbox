/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	include '/config/applicationSettings.cfm';

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/test" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	
	include '/config/appcfc/onApplicationStart_method.cfm';
	include '/config/appcfc/onRequestStart_method.cfm';
}