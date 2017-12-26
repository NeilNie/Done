//
//  EventManager.m
//  
//
//  Created by Yongyang Nie on 6/17/16.
//
//

#import "EventManager.h"

@implementation EventManager

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.eventStore = [[EKEventStore alloc] init];

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        // Check if the access granted value for the events exists in the user defaults dictionary.
        if ([userDefaults valueForKey:@"eventkit_events_access_granted"] != nil) {
            // The value exists, so assign it to the property.
            self.eventsAccessGranted = [[userDefaults valueForKey:@"eventkit_events_access_granted"] intValue];
        }
        else{
            // Set the default value.
            self.eventsAccessGranted = NO;
        }        
    }
    return self;
}

-(void)setEventsAccessGranted:(BOOL)eventsAccessGranted{
    _eventsAccessGranted = eventsAccessGranted;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:eventsAccessGranted] forKey:@"eventkit_events_access_granted"];
}

//for display's sake, convert all the EKEvent (local calendar) to Task object so UIColletionView layout can understand it. Remember in controller implementation append the newly created array to all events.

+(NSArray<Task *> *)timePeriodsinTimeline{
    
    NSArray *calendarEvents = [[[EventManager alloc] init] getTodayLocalEvent];
    NSMutableArray <Task *> *events = [NSMutableArray array];
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd"];
    
    for (int i = 0; i < calendarEvents.count; i++) {
        
        Task *event = [[Task alloc] init];
        EKEvent *calendar = [calendarEvents objectAtIndex:i];
        if ([[formate stringFromDate:calendar.startDate] isEqualToString:[formate stringFromDate:calendar.endDate]]) {
            event.title = calendar.title;
            event.date = calendar.startDate;
            event.endDate = calendar.endDate;
            [events addObject:event];
        }
    }
    return events;
}

-(NSArray *)getLocalEventCalendars{
    
    NSArray *allCalendars = [self.eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSMutableArray *localCalendars = [[NSMutableArray alloc] init];
    
    for (int i=0; i<allCalendars.count; i++) {
        
        EKCalendar *currentCalendar = [allCalendars objectAtIndex:i];
        if (currentCalendar.type == EKCalendarTypeLocal) {
            [localCalendars addObject:currentCalendar];
        }
    }
    return (NSArray *)localCalendars;
}

-(NSArray *)getTodayLocalEvent{
    
    NSArray *allCalendars = [self getLocalEventCalendars];
    NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:[Date todayStarts] endDate:[Date tomorrowStarts] calendars:allCalendars];
    NSArray *todayEvents = [self.eventStore eventsMatchingPredicate:predicate];
    return todayEvents;
}

-(NSMutableArray <Task *> *)convertEKEventtoEvents{
    
    NSMutableArray *eventsToday = [[NSMutableArray alloc] initWithArray:[self getTodayLocalEvent]];
    
    if (eventsToday.count == 0) {
        return nil;
    }
    
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i = 0; i < eventsToday.count; i++) {
        EKEvent *EKEvent = [eventsToday objectAtIndex:i];
        Task *event = [[Task alloc] init];
        event.title = EKEvent.title;
        event.date = EKEvent.startDate;
        event.endDate = EKEvent.endDate;
        [returnArray addObject:event];
    }
    return returnArray;
}

-(NSArray<Task *> *)findEventsToday{
    
    NSMutableArray *eventsToday = [self convertEKEventtoEvents];
    [eventsToday addObjectsFromArray:[EventsHelper findTodayNotCompletedEvents:[Task allObjects]]];
    
    NSMutableArray *periodArray = [NSMutableArray array];
    for (int i = 0; i < eventsToday.count; i++) {
        
        Task *event = [eventsToday objectAtIndex:i];
        
        if (event.endDate) {
            TimePeriod *period = [[TimePeriod alloc] initWithStart:event.date andEnd:event.endDate];
            [periodArray addObject:period];
        }else{
            TimePeriod *period = [[TimePeriod alloc] initWithStart:event.date andEnd:[NSDate dateWithTimeInterval:1200 sinceDate:event.date]];
            [periodArray addObject:period];
        }
    }
    NSArray *result = [eventsToday sortedArrayUsingComparator:^NSComparisonResult(Task *event1, Task *event2) {
        return [event1.date compare:event2.date];
    }];

    return result;
}

-(NSMutableArray <Task *> *)convertPeriodsToEvents:(NSArray *)periods{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i = 0; i < periods.count; i++) {
        TimePeriod *period = [periods objectAtIndex:i];
        Task *event = [[Task alloc] init];
        event.date = period.startDate;
        event.endDate = period.endDate;
        event.title = NSLocalizedString(@"Free time", nil);
        [returnArray addObject:event];
    }
    return returnArray;
}


-(NSMutableArray<TimePeriod *> *)findFreePeriodsToday{
    
    NSMutableArray *busyTimes = [self findEventsToday];
    NSMutableArray *freePeriods = [NSMutableArray array];
    
    ////1
    //go through all the busy periods in the day, and find the gaps between each peroids.
    if (busyTimes.count >= 1) {
        for (int i = 0; i < busyTimes.count - 1; i++) {
            
            Task *current = [busyTimes objectAtIndex:i];
            Task *next = [busyTimes objectAtIndex:i + 1];
            
            //if the gap between the events are more than 5 minutes, then create a TimePeriod object and add it to the array.
            if ([current.endDate timeIntervalSinceDate:next.date] < - 15 * 60) { // if
                TimePeriod *freePeriod = [[TimePeriod alloc] initWithStart:[NSDate dateWithTimeInterval:10 * 60 sinceDate:current.endDate] andEnd:[NSDate dateWithTimeInterval:-10 * 60 sinceDate:next.date]];
                [freePeriods addObject:freePeriod];
            }
        }
        
        ////2
        //if the first event of the day is after 9, then
        NSDate *todayAtEight = [Date getDateTodayWithHour:8 minutes:0];
        Task *firstPeriod = [busyTimes objectAtIndex:0];
        
        //
        if ([todayAtEight timeIntervalSinceDate:firstPeriod.date] > 20 * 60) {
            
        }
    }else return nil;
    
    return freePeriods;
}

@end
