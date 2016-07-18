//
//  EventsHelper.h
//  Done!
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import "Events.h"
#import "Projects.h"

@interface EventsHelper : NSObject

/**
 create an event object with date, title. Other info should be in a dictionary and will be process in the method. (to be implemented)
 */
+(Events *)createEventWithDate:(NSDate *)date title:(NSString *)title otherInfo:(NSDictionary *)info;

+(Projects *)createProjectWithDate:(NSDate *)date title:(NSString *)title;

/**
 Delete an event, the `Events` object will be passed in the paramenter.
 */
+(void)deleteEvent:(Events *)event;

/**
 Modify event with value. The object that is being alternated is the key value. (This method need to be implemented)
 */
+(void)modifyEventValue:(NSString *)value withKey:(NSString *)key;

/**
 The opposite of the previous method. It takes in an array and turn store them in Default Realm. The array parameter has to include 
 */
+(void)createRealmWithArray:(NSMutableArray *)array;

/**
 This method converts all the Event objects to a NSMutableArray that contains Event objects.
 */

+(NSMutableArray *)convertEventsToArray:(RLMResults *)results;

/**
 This method finds all the Event objects on a specific day which is the parameter.
 */
+(NSMutableArray *)findEventsForToday:(NSDate *)today withRealm:(RLMResults *)realm;

+(NSMutableArray *)findEventsForToday:(NSDate *)today withArrayOfEvents:(NSMutableArray *)realm;

+(NSMutableArray *)findTodayCompletedEvents:(RLMResults *)realm;

+(NSMutableArray *)findCompletedEventsWithArrayOfEvents:(NSMutableArray *)realm withDate:(NSDate *)date;

/**
 This method finds all the completed events on a day which is the parameter. The method returns an NSMutableArray that contains events objects.
 */
+(NSMutableArray *)findCompletedEventsRealm:(RLMResults *)realm withDate:(NSDate *)date;

/**
 This method converts all Event objects, disregarding date, completion to an NSMutableArray that contains NSDictionaries.
 */
+(NSMutableArray *)convertAllObjecttoArray;

+(NSMutableArray *)findTodayNotCompletedEvents:(RLMResults *)realm;

+(NSMutableArray *)findNotCompletedEvents:(RLMArray *)realm;

+(Events *)findEarliestEventTodayWithArray:(NSMutableArray *)array;

//+(Events *)findEventWithTitle:(NSString *)string withRealm:(RLMArray *)array;

+(Events *)findEventWithTitle:(NSString *)string withAllRealm:(RLMResults *)array;

+(Events *)findMostRecentEvent:(NSDate *)date withArrayOfEvents:(NSMutableArray *)realm;

+(Projects *)findProjectWithName:(NSString *)name;

///Find the most recent event on a day. Parameters: date and realm (RLMArray and RLMResults).

+(Events *)findMostRecentEvent:(NSDate *)date withRealm:(RLMArray *)realm;
+(Events *)findMostRecentEvent:(NSDate *)date withRealmResult:(RLMResults *)realm;

+(NSMutableArray *)findImportantEvents:(NSDate *)date withRealm:(RLMResults *)realm;

#pragma mark - Helpers

+ (NSString *)uoid;

+ (NSDateFormatter *)dateFormatter;

@end
