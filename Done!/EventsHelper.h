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

@interface EventsHelper : NSObject <WCSessionDelegate>

/*
 create an event object with date, title. Other info should be in a dictionary and will be process in the method. (to be implemented)
 */
+(void)createEventWithDate:(NSDate *)date title:(NSString *)title otherInfo:(NSDictionary *)info;

/*
 Delete an event, the `Events` object will be passed in the paramenter.
 */
+(void)deleteEvent:(Events *)event;

/*
 Modify event with value. The object that is being alternated is the key value. (This method need to be implemented)
 */
+(void)modifyEventValue:(NSString *)value withKey:(NSString *)key;

/*
 The parameter is a `RLMResults` object. The method goes through all the `Events` and turn the `RLMResults` object into a NSMutableArray;
 */
+(NSMutableArray *)convertToArray:(RLMResults *)results;

/*
 The opposite of the previous method. It takes in an array and turn store them in Default Realm.
 */
+(void)createRealmWithArray:(NSMutableArray *)array;

/*
 Important method. Call this when Realm objects are modified and the device need to notify the counterpart.
 */
+(void)eventsAreModified:(id)object;

@end