//
//  CalendarViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return eventArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    Events *event = [eventArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [[self dateFormatter] stringFromDate:event.date];
    return cell;
}

#pragma mark - JTCalendar Delegate

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    // Use to indicate the selected date
    dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView duration:.1 options:0 animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
    } completion:nil];
    
    // Load the previous or next page if touch a day from another month
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    if([self haveEventForDay:dayView.date withRealmResult:[Events allObjects]]){
        NSLog(@"%@", eventArray);
        [self.table reloadData];
    }
    
}

- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(dateSelected && [_calendarManager.dateHelper date:dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date withRealmResult:[Events allObjects]]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

#pragma mark - Privates

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date withRealmResult:(RLMResults *)realm
{
    [eventArray removeAllObjects];
    for (int i = 0; i < realm.count; i++) {
        
        Events *event = [realm objectAtIndex:i];
        NSString *string = [[self dateFormatter] stringFromDate:event.date];
        if ([string isEqualToString:[[self dateFormatter] stringFromDate:date]]) {
            [eventArray addObject:event];
            return YES;
        }
    }
    return NO;
    
}


#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    [_calendarManager reload];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    eventArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
