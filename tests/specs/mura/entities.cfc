/**
* This tests the BDD functionality in TestBox.
*/
component extends="testbox.system.BaseSpec"{

/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		session.siteid='default';
	}

	function afterAll(){}

/*********************************** BDD SUITES ***********************************/

	function run(){
		var data={};

		for(entityName in application.objectMappings){
			data={
				siteid='default',
				entities=application.objectMappings,
				$=application.serviceFactory.getBean('$').init('default'),
				entityName=entityName
			};
			
			describe(
				title="Testing #data.entityName# entity", 
				body=function() {
					
					var exists=data.$.getServiceFactory().containsBean(data.entityName);

					if( exists && !isObject(data.$.getBean(data.entityName))){
						return;
					}

					it(
						title="should exist in bean factory",
						body=function(){
							expect(data.exists).toBeTrue();
						},
						data={exists=exists}
					);

					if(exists){
						
						var bean=data.$.getBean(data.entityName);
						
						structAppend(data,{
							bean=bean,
							properties=bean.getProperties(),
							synthedFunctions=bean.getSynthedFunctions(),
							columns=bean.getColumns()
						});
						
						it(
							title="should have built in feed access",
							body=function(){
								expect(
									(
										structKeyExists(bean,'getFeed')
										&& isQuery(bean.getFeed().getQuery())
									)
								).toBeTrue();
							},
							data={
								bean=bean
							}
						);

						for(prop in data.properties){
							data.prop=prop;

							if(structKeyExists(data.properties[data.prop],'cfc') && data.$.getServiceFactory().containsBean(data.properties[data.prop].cfc)){
				
								it(
									title='#data.prop# should have cfc',
									body=function(){ 
										expect(data.properties[data.prop].cfc).toBeGT('');
									},
									data={
										properties=data.properties,
										prop=data.prop
									}
								);

								data.validFieldType=(
									structKeyExists(data.properties[data.prop],'fieldType') 
									&& listFindNoCase('one-to-many,many-to-one,one-to-one,many-to-many',data.properties[data.prop].fieldtype)
								);
								
								it(
									title='#data.prop# should have valid fieldtype',
									body=function(){ 
										expect(data.validFieldType).toBeTrue();
									},
									data={validFieldType=data.validFieldType}
								);

								if(data.validFieldType){

									if(data.properties[data.prop].fieldtype == 'one-to-many'){
										var objInstance=evaluate('data.bean.get#data.prop#Iterator()');
										it(
											title='#data.entityName#.get#data.prop#Iterator() should return valid object',
											body=function(){ 
												expect(
													(right(getMetaData(data.objInstance).fullname,len('iterator'))=='iterator')
													).toBeTrue();
											},
											data={objInstance=objInstance}
										);


									} else {
										var objInstance=evaluate('data.bean.get#data.prop#()');

										it(
											title='#data.entityName#.get#data.prop#() should return valid object',
											body=function(){ 	
												expect(isObject(data.objInstance)).toBeTrue();
											},
											data={objInstance=objInstance}
										);
									}
				
								}
				
							} else if (
								structKeyExists(data.properties[data.prop],'fieldtype')
								&& listFindNoCase('one-to-many,many-to-one,one-to-one,many-to-many',data.properties[data.prop].fieldtype)
								) {
								it(
									title='#data.prop# should have valid cfc',
									body=function(){ 
										expect(false).toBeTrue();
									}
								);
							} 
		
							else if (isStruct(data.columns) && structKeyExists(data.columns,data.prop)) {
								//writeDump(var=data.columns,abort=1);
								it(
									title='#data.prop# should match schema datatype #ucase(data.columns[data.prop].datatype)#',
									body=function(){ 
										var columnType=data.properties[data.prop].dataType;

										if(columnType=='varchar'){
											expect( listFindNoCase('string,varchar',data.columns[data.prop].datatype) ).toBeTrue();
										} else if (columnType=='text'){
											expect( (data.columns[data.prop].datatype=='text') ).toBeTrue();
										} else if (columnType=='longtext'){
											expect( (data.columns[data.prop].datatype=='longtext') ).toBeTrue();
										} else if (columnType=='char'){
											expect( (data.columns[data.prop].datatype=='char') ).toBeTrue();
										} else if ( listFindNoCase('int,integer,number',data.columns[data.prop].datatype) ){
											expect( listFindNoCase('int,integer,number',data.columns[data.prop].datatype) ).toBeTrue();
										} else if (columnType=='tinyint'){
											expect( listFindNoCase('tiny,number',data.columns[data.prop].datatype) ).toBeTrue();
										} else if (columnType=='double'){
											expect( (data.columns[data.prop].datatype=='double') ).toBeTrue();
										} else if (columnType=='float'){
											expect( (data.columns[data.prop].datatype=='float') ).toBeTrue();
										} else if (listFindNoCase('date,timestamp,datetime',data.columns[data.prop].datatype)){
											expect( (data.columns[data.prop].datatype=='datetime') ).toBeTrue();
										}

									},
									data={
										properties=data.properties,
										columns=data.columns,
										prop=data.prop
									}
								);
							}
			

						} 
	
					
					}
					
				},
				data=data
			);

			

		}

		

	}

}