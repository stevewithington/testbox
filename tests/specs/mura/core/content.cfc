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

		 	var config={
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

			var entityName='content';
			var entityClass='mura.content.contentBean';

			var $=application.serviceFactory.getBean('$').init(config.siteid);
			
			var bean=$.getBean(entityName).loadBy(contentid=config.contentid);

			if(bean.exists()){
				bean.delete();
				bean=$.getBean(entityName).loadBy(contentid=config.contentid);
			}


			bean=$.getBean(entityName);
		 	
		 	it(
		 		title="Should be able to load an empty contentBean",
			 	body=function() {
				 	expect( data.bean ).toBeInstanceOf(data.entityClass);
				},
				data={
					bean=bean,
					entityclass=entityclass
				}
			);

			it(
				title="Should not exist",
			 	body=function() {
				 	expect(yesNoFormat(data.bean.exists()) ).toBeFalse();
				},
				data={bean=bean}
			);

			it(
				title="Should be able to save",
			 	body=function() {
				 	expect( data.bean.set(data.config).save().exists() ).toBeTrue;
				},
				data={
					bean=bean,
					config=config
				}
			);

			
			var loadChecks=['contentid','remoteid','filename','title','urltitle'];

			for(var key in loadChecks){
				var args={'#key#'=config[key]};

				it(
					title="Should be able to load by #key#",
			 		body=function() {
				 		var bean=data.$.getBean(data.entityName).loadBy(argumentCollection=data.args);
					 	expect( bean.exists() ).toBeTrue();
					},
					data={
						entityName=entityName,
						args=args,
						$=$
					}
				);

			}

			bean.delete();

		});

		describe("Testing Content Intervals", function() {

		 	var calendarConfig={
				title="My Unit Testing Calendar",
				filename="my-unit-testing-calendar",
				urltitle="my-unit-testing-calendar",
				siteID="default",
				parentID="00000000000000000000000000000000001",
				contentID='0000000000000000000000000000000test',
				type="Calendar",
				approved="1"
			};

			var $=application.serviceFactory.getBean('$').init(calendarConfig.siteid);
			
			var calendar=$.getBean('content').loadBy(contentid=calendarConfig.contentid);

			if(calendar.exists()){
				calendar.delete();
				calendar=$.getBean('content').loadBy(contentid=calendarConfig.contentid);
			}

			calendar.set(calendarConfig).save();

			it(
				title="Should be able to create a calendar for testing content intervals",
			 	body=function() {
				 	expect( data.calendar.exists() ).toBeTrue();
				},
				data={calendar=calendar}
			);

			if(calendar.exists()){


				var events='';
				var params={};
				var eventConfig={
					title="My Unit Testing Event",
					filename="my-unit-testing-event",
					urltitle="my-unit-testing-event",
					siteID="default",
					parentID=calendar.getContentID(),
					type="Page",
					approved="1",
					display=2,
					displayStart=now(),
					displayStop=now()
				};
		
				var event=$.getBean('content').set(eventConfig).save();

				//Daily
				event.setDisplayInterval({
					repeats=1,
					event=1,
					type='daily'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="DAILY: Should have an event each day until the to date",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();

					 		if(dateFormat(instance.getdisplayStart(),'yyyy-mm-dd') != dateFormat(current,'yyyy-mm-dd')){
					 			complete=false;
					 			break;
					 		}

					 		current=dateAdd('d',1,current);
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);

				//Weekly
				event.setDisplayInterval({
					repeats=1,
					event=1,
					type='weekly',
					daysofweek='1,3,5,7'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now()),
					daysofweek="1,3,5,7"
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="WEEKLY: Should only have events on days 1,3,5,7",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();

					 		if(!listFind(data.params.daysofweek,dayofWeek(instance.getdisplayStart()))){
					 			complete=false;
					 			break;
					 		}
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);
	

				//WeekEnds
				event.setDisplayInterval({
					repeats=1,
					type='weekends'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now()),
					daysofweek='1,7'
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="WEEKENDS: Should only have events on days 1,7",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();

					 		if(!listFind(data.params.daysofweek,dayofWeek(instance.getdisplayStart()))){
					 			complete=false;
					 			break;
					 		}
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);

				//WeekDays
				event.setDisplayInterval({
					repeats=1,
					type='weekdays'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now()),
					daysofweek="2,3,4,5,6"
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="WEEKDAYS: Should only have events on days 2,3,4,5,6",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();

					 		if(!listFind(data.params.daysofweek,dayofWeek(instance.getdisplayStart()))){
					 			complete=false;
					 			break;
					 		}
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);


				//Bi-Weekly
				event.setDisplayInterval({
					repeats=1,
					type='bi-weekly',
					daysofweek=dayofweek(now())
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now()),
					daysofweek=dayofweek(now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="BI-WEEKLY: Should have 14 days between dates",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;
					 	var previous=data.params.from;
					 	var diff=0;
					 	var started=false;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();
					 		diff=dateDiff('d',previous,instance.getdisplayStart());

					 		if(started && diff!=14){
					 			complete=false;
					 			break;
					 		} else {
					 			started=true;
					 		}

					 		previous=instance.getdisplayStart();
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);

				//Monthly
				event.setDisplayInterval({
					repeats=1,
					type='monthly'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',3,now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="MONTHLY: Should have 1 month between dates",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;
					 	var previous=data.params.from;
					 	var diff=0;
					 	var started=false;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();
					 		diff=dateDiff('m',previous,instance.getdisplayStart());

					 		if(started && diff!=1){
					 			complete=false;
					 			break;
					 		} else {
					 			started=true;
					 		}

					 		previous=instance.getdisplayStart();
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);
	
				//Yearly
				event.setDisplayInterval({
					repeats=1,
					type='yearly'
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('yyyy',3,now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);
				
				it(
					title="YEARLY: Should have 1 year between dates",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;
					 	var previous=data.params.from;
					 	var diff=0;
					 	var started=false;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();
					 		diff=dateDiff('yyyy',previous,instance.getdisplayStart());

					 		if(started && diff!=1){
					 			complete=false;
					 			break;
					 		} else {
					 			started=true;
					 		}

					 		previous=instance.getdisplayStart();
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);

				//End After
				event.setDisplayStop('');
				event.setDisplayInterval({
					repeats=1,
					type='daily',
					end='after',
					endafter=5
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);

				it(
					title="ENDS AFTER: Should only have 5 events",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;
					 	var i=0;

					 	while(data.events.hasNext()){
					 		data.events.next();
					 		i++;

					 		if(i > 5){
					 			complete=false;
					 			break;
					 		}
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);


				//End On
				event.setDisplayStop('');
				event.setDisplayInterval({
					repeats=1,
					type='daily',
					end='on',
					endon=dateAdd('d',5,now())
				}).setApproved(1).save();

				params=	{
					from=now(),
					to=dateAdd('m',1,now()),
					endon=dateAdd('d',5,now())
				};

				events=calendar.getEventsIterator(
					argumentCollection=params
				);

				it(
					title="ENDS ON: Should only have events before end date",
				 	body=function() {
					 	var instance='';
					 	var current=data.params.from;
					 	var complete=true;
					 	var i=0;

					 	while(data.events.hasNext()){
					 		instance=data.events.next();
					 		
					 		if(fix(instance.getDisplayStart()) > fix(data.params.endon)){
					 			complete=false;
					 			break;
					 		}
					 	}

					 	expect(complete).tobeTrue();
					},
					data={
						events=events,
						params=params
					}
				);

	
				event.delete();
			}

			calendar.delete();
		 	
		});


	}


}