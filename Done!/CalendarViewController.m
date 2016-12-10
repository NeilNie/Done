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
    cell.dateLabel.text = [[Date getDefaultDateFormatter] stringFromDate:event.date];
    
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
    
    NSMutableArray *array = [EventsHelper findEventsForToday:dayView.date withRealm:[Events allObjects]];
    if(array.count > 0){
        eventArray = array;
        [self.table reloadData];
    }
    self.eventCountl.text = [NSString stringWithFormat:NSLocalizedString(@"%lu Events on this day", nil), (unsigned long)array.count];
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"MMMM, dd"];
    self.yearLabel.text = NSLocalizedString(@"2016", nil);
    self.dateLabel.text = [formate stringFromDate:dayView.date];
    [formate setDateFormat:@"EEEE"];
    self.navigationItem.title = [formate stringFromDate:dayView.date];
    
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
    NSMutableArray *array = [EventsHelper findEventsForToday:dayView.date withRealm:[Events allObjects]];
    if(array.count > 0){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

#pragma mark - Privates

-(void)setShadowforView:(UIView *)view{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
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

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
            [UIView animateWithDuration:0.5 animations:^{
                self.labelContr1.constant = 0;
                self.labelContr2.constant = 0;
                self.labelConst3.constant = 0;
                self.contr.constant = 250;
                [self.table reloadData];
                [self.view layoutIfNeeded];
            }];
        }else if (swipe.direction == UISwipeGestureRecognizerDirectionDown){
            [UIView animateWithDuration:0.5 animations:^{
                self.labelContr1.constant = 110;
                self.labelContr2.constant = 45;
                self.labelConst3.constant = 45;
                self.contr.constant = 0;
                [self.view layoutIfNeeded];
            }];
        }
    });
}

-(void)setUpGestures{
    
    NSLog(@"set up gesture");
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.calendarContentView addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.calendarContentView addGestureRecognizer:swipeUp];
}
-(void)setUpLabels{
    
    self.contr.constant = 0;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"MMMM, dd"];
    self.yearLabel.text = NSLocalizedString(@"2016", ni
                                            );
    self.dateLabel.text = [formate stringFromDate:[NSDate date]];
    [formate setDateFormat:@"EEEE"];
    self.navigationItem.title = [formate stringFromDate:[NSDate date]];
    
    NSMutableArray *array = [EventsHelper findEventsForToday:[NSDate date] withRealm:[Events allObjects]];
    if(array.count > 0){
        eventArray = [[NSMutableArray alloc] initWithArray:array];
        [self.table reloadData];
    }
    self.eventCountl.text = [NSString stringWithFormat:NSLocalizedString(@"%lu Events on this day", nil), (unsigned long)array.count];
}
- (IBAction)addEvent:(id)sender {
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [_calendarManager reload];
    
    NSMutableArray *array = [EventsHelper findEventsForToday:[NSDate date] withRealm:[Events allObjects]];
    if(array.count > 0){
        eventArray = array;
        [self.table reloadData];
    }
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    [self setUpLabels];
    [self setUpGestures];
    [self setShadowforView:self.table];
    [self setShadowforView:self.addButton];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
