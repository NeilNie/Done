//
//  EventManager.h
//  
//
//  Created by Yongyang Nie on 6/17/16.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "Events.h"
#import "Date.h"
#import "TimePeriod.h"
#import "EventsHelper.h"

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

-(NSArray *)getTodayLocalEvent;

/**
  This method will find all the events on this calendar day and return an array of Events objects.
  @param nil
  @returns NSMutableArray<Events *> *
  @exception nil
  */
-(NSMutableArray<Events *> *)findEventsToday;

/**
 This method will find free periods on this calendar day and return an array of TimePeriods.
 @param nil
 @returns NSMutableArray<TimePeriod *> *
 @exception nil
 */
-(NSMutableArray<TimePeriod *> *)findFreePeriodsToday;


+(NSArray<Events *> *)timePeriodsinTimeline;

@end
