//
//  ComplicationController.m
//  Done! Apple Watch Extension
//
//  Created by Yongyang Nie on 4/23/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "ComplicationController.h"

@interface ComplicationController ()

@end

@implementation ComplicationController

#pragma mark - Timeline Configuration

- (void)getSupportedTimeTravelDirectionsForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimeTravelDirections directions))handler {
    handler(CLKComplicationTimeTravelDirectionForward|CLKComplicationTimeTravelDirectionBackward);
}

- (void)getTimelineStartDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getTimelineEndDateForComplication:(CLKComplication *)complication withHandler:(void(^)(NSDate * __nullable date))handler {
    handler(nil);
}

- (void)getPrivacyBehaviorForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationPrivacyBehavior privacyBehavior))handler {
    handler(CLKComplicationPrivacyBehaviorShowOnLockScreen);
}

#pragma mark - Timeline Population

- (void)getCurrentTimelineEntryForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTimelineEntry * __nullable))handler {
    
    NSLog(@"got current entry");
    RLMResults *re = [Events allObjects];
    Events *event = [re objectAtIndex:0];
    
    CLKComplicationTemplateModularLargeStandardBody *template = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
    template.headerTextProvider = [CLKTimeIntervalTextProvider textProviderWithStartDate:[NSDate date] endDate:event.date];
    template.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:event.title shortText:@"Event Title"];
    
    CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
    handler(entry);
    // Call the handler with the current timeline entry
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication beforeDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    
    NSMutableArray<CLKComplicationTimelineEntry *> *entries = [[NSMutableArray alloc] init];
    RLMResults *result = [Events allObjects];
    NSLog(@"all entries %@", result);
    
    NSMutableArray *array = [EventsHelper convertToArray:result];
    NSString *string = [NSString stringWithFormat:@"%lu events today, you have completed %lu of them.", (unsigned long)result.count, (unsigned long)[EventsHelper findCompletedEvents:array withDate:[NSDate date]].count];
    
    for (Events *event in result) {
        
        if (result.count < limit && [event.date timeIntervalSinceDate:date] > 0){
            CLKComplicationTemplateModularLargeStandardBody *template = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
            template.headerTextProvider = [CLKTimeIntervalTextProvider textProviderWithStartDate:[NSDate date] endDate:event.date];
            template.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:event.title shortText:@"Event Title"];
            template.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:string shortText:@"Today"];
            
            CLKComplicationTimelineEntry *entry = [CLKComplicationTimelineEntry entryWithDate:[NSDate date] complicationTemplate:template];
            [entries addObject:entry];
        }
    }
    // Call the handler with the timeline entries prior to the given date
    handler(entries);
}

- (void)getTimelineEntriesForComplication:(CLKComplication *)complication afterDate:(NSDate *)date limit:(NSUInteger)limit withHandler:(void(^)(NSArray<CLKComplicationTimelineEntry *> * __nullable entries))handler {
    // Call the handler with the timeline entries after to the given date
    handler(nil);
}

#pragma mark Update Scheduling

- (void)getNextRequestedUpdateDateWithHandler:(void(^)(NSDate * __nullable updateDate))handler {
    // Call the handler with the date when you would next like to be given the opportunity to update your complication content
    NSLog(@"next request time updated");
    handler([NSDate dateWithTimeIntervalSinceNow:60 * 60]);
}

#pragma mark - Placeholder Templates

- (void)getPlaceholderTemplateForComplication:(CLKComplication *)complication withHandler:(void(^)(CLKComplicationTemplate * __nullable complicationTemplate))handler {
    
    RLMResults *result = [Events allObjects];
    
    if (result.count > 0) {
        Events *event = [result objectAtIndex:0];
        CLKComplicationTemplateModularLargeStandardBody *template = [[CLKComplicationTemplateModularLargeStandardBody alloc] init];
        template.headerTextProvider = [CLKTimeIntervalTextProvider textProviderWithStartDate:[NSDate date] endDate:[NSDate dateWithTimeIntervalSinceNow:60 * 60]];
        template.body1TextProvider = [CLKSimpleTextProvider textProviderWithText:event.title shortText:@"Event Title"];
        //template.body2TextProvider = [CLKSimpleTextProvider textProviderWithText:@"Please wait" shortText:@"My name"];
        // This method will be called once per supported complication, and the results will be cached
        handler((CLKComplicationTemplate *)template);
    }else{
        handler(nil);
    }
}

@end
