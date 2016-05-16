//
//  TodayViewController.h
//  Done Widget
//
//  Created by Yongyang Nie on 5/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "Events.h"
#import "Projects.h"
#import "EventsHelper.h"

@interface TodayViewController : UIViewController{
    NSMutableArray *result;
    NSDate *date;
    NSString *title;
    NSNumber *totalEvents;
    NSNumber *completedEvents;
}
@property (weak, nonatomic) IBOutlet UILabel *upComingTitle;
@property (weak, nonatomic) IBOutlet UILabel *upComingDate;
@property (weak, nonatomic) IBOutlet UILabel *todaySummary;

@end
