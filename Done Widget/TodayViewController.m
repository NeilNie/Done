//
//  TodayViewController.m
//  Done Widget
//
//  Created by Yongyang Nie on 5/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    
    [self setUpData];
    [self setUpView];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpView];
    [super viewDidAppear:YES];
}

-(void)setUpData{
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    date = [shared valueForKey:@"date"];
    title = [shared valueForKey:@"title"];
    totalEvents = [shared valueForKey:@"totalEvents"];
    completedEvents = [shared valueForKey:@"completedEvents"];
}

-(void)setUpView{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.upComingDate.text = [formate stringFromDate:date];
    self.upComingTitle.text = title;
    self.todaySummary.text = [NSString stringWithFormat:@"There are %lu events today and you have completed %lu of them.", totalEvents.integerValue, completedEvents.integerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    NSLog(@"set up margin");
    margins.bottom = 10.0;
    margins.left = 10.00;
    return margins;
}

@end
