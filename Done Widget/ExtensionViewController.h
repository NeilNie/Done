//
//  ExtensionViewController.h
//  Done!
//
//  Created by Yongyang Nie on 7/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"
#import "List.h"
#import "EventsHelper.h"

@interface ExtensionViewController : UIViewController {
    NSMutableArray *result;
    NSDate *date;
    NSString *title;
    NSNumber *totalEvents;
    NSNumber *completedEvents;
}
@property (weak, nonatomic) IBOutlet UILabel *upComingTitle;
@property (weak, nonatomic) IBOutlet UILabel *upComingDate;
@property (weak, nonatomic) IBOutlet UILabel *todaySummary;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
