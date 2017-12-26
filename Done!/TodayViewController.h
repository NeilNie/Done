//
//  TodayViewController.h
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>
#import <WatchKit/WatchKit.h>

#import "AppDelegate.h"
#import "Task.h"
#import "List.h"
#import "EventTableViewCell.h"
#import "EventsHelper.h"
#import "Date.h"
#import "Done_-Swift.h"

@interface TodayViewController : UIViewController <WCSessionDelegate>

//@property (weak, nonatomic) IBOutlet GADBannerView *banner;
@property (weak, nonatomic) IBOutlet UILabel *completedLabel;

@property (weak, nonatomic) IBOutlet UIView *todayView;
@property (weak, nonatomic) IBOutlet UIView *masterView;
@property (weak, nonatomic) IBOutlet UIView *graphView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *clearLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSMutableArray *buttons;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *todayConstr;

@end
