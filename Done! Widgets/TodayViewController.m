//
//  TodayViewController.m
//  Done! Widgets
//
//  Created by Yongyang Nie on 4/21/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return result.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateStyle = NSDateFormatterLongStyle;
    NSDictionary *dictionary = [result objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = [dictionary objectForKey:@"title"];
    cell.titleLabel.textColor = [UIColor whiteColor];
    cell.dateLabel.text = [dictionary objectForKey:@"date"];
    cell.button.hidden = YES;
    return cell;
}


- (void)viewDidLoad {
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    result = [NSMutableArray array];
    result = [shared valueForKey:@"RealmResult"];
    NSLog(@"result %@", result);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    margins.bottom = 10.0;
    margins.left = 5;
    margins.right = 5;
    return margins;
}

@end
