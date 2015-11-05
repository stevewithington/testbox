/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing Variable Access", function() {

		 	structAppend(url,{
				siteId = "default",
				testURLVar="fromurl"
			});

			structAppend(form,{
				testFormVar="fromform"
			});

			$=application.serviceFactory.getBean('$').init();
			
			it(
		 		title="Should be able to access url variables through EVENT scope",
			 	body=function() {
				 	expect( (data.$.event('testURLVar')=='fromurl') ).toBeTrue();
				},
				data={
					$=$
				}
			);
			
			it(
		 		title="Should be able to access form variables through EVENT scope",
			 	body=function() {
				 	expect( (data.$.event('testFormVar')=='fromform') ).toBeTrue();
				},
				data={
					$=$
				}
			);
			
			$.event(
				'contentBean',
				$.getBean('content').loadBy(filename='')
			);

			it(
		 		title="Should be able to access content variables through CONTENT scope",
			 	body=function() {
				 	expect( len(data.$.content('title')) ).toBeTrue();
				},
				data={
					$=$
				}
			);

			it(
		 		title="Should be able to access content methods",
			 	body=function() {
				 	expect( len(data.$.getTitle()) ).toBeTrue();
				},
				data={
					$=$
				}
			);


			//This obviously won't pass if you are not logged into Mura
			it(
		 		title="Should be able to access the current user variables through CURRENTUSER scope",
			 	body=function() {
				 	expect( len(data.$.currentUser('username')) ).toBeTrue();
				},
				data={
					$=$
				}
			);

			it(
		 		title="Should be able to access the rendering methods",
			 	body=function() {
				 	expect( len(data.$.createHREF(filename='test')) ).toBeTrue();
				},
				data={
					$=$
				}
			);

		});

	}

}