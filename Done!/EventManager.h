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
#import "NYDate.h"
#import "NYTimePeriod.h"
#import "EventsHelper.h"

@interface EventManager : NSObject

@property (nonatomic, strong) EKEventStore *eventStore;
@property (nonatomic) BOOL eventsAccessGranted;

-(NSArray *)getLocalEventCalendars;
-(NSArray *)getTodayEventCalendars;
-(NSMutableArray<Events *> *)busyTimesToday;
-(NSMutableArray<NYTimePeriod *> *)freeTimesToday;
+(NSArray<Events *> *)timePeriodsinTimeline;

@end
