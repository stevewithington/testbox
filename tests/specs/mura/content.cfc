/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){
		if(isDefined('bean') && bean.exists()){
			bean.delete();
		}
		console( "Executed afterAll() at #now()#" );
	}

/*********************************** BDD SUITES ***********************************/

	function run(){
		describe("Testing persistence", function() {

		 	config={
				title="My Unit Test",
				filename="my-unit-test",
				urltitle="my-unit-test",
				siteID="default",
				parentID="00000000000000000000000000000000001",
				contentID="0000000000000000000000000000000test",
				type="Page",
				subtype="Default",
				remoteID="remoteIDforUnitTest"
			};

			entityName='content';
			entityClass='mura.content.contentBean';

			$=application.serviceFactory.getBean('$').init(config.siteid);
			
			bean=$.getBean(entityName).loadBy(contentid=config.contentid);

			if(bean.exists()){
				bean.delete();
				bean=$.getBean(entityName).loadBy(contentid=config.contentid);
			}

		 	it("Should be able to load an empty contentBean",
		 	function() {
		 		bean=$.getBean(entityName);
			 	expect( bean ).toBeInstanceOf(entityClass);
			});

			it("Should not exist",
		 	function() {
			 	expect(yesNoFormat(bean.exists()) ).toBeFalse();
			});

			it("Should be able to save",
		 	function() {
			 	expect( bean.set(config).save().exists() ).toBeTrue;
			});

			
			loadChecks=['contentid','remoteid','filename','title','urltitle'];

			for(var key in loadChecks){
				args={'#key#'=config[key]};

				it(
					title="Should be able to load by #key#",
			 		body=function() {
				 		bean=$.getBean(entityName).loadBy(argumentCollection=args);
					 	expect( bean.exists() ).toBeTrue();
					},
					entityName=entityName,
					args=args
				);

			}
		});

	}

}