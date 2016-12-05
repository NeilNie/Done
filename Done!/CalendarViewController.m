//
//  CalendarViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *completedData;
@property (strong, nonatomic) NSMutableArray *eventNumber;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation CalendarViewController

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    cell.contentView.frame = cell.bounds;
    cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cell.event = [collectionViewArray objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *time = [collectionViewArray objectAtIndex:indexPath.row];
    return time.date;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *time = [collectionViewArray objectAtIndex:indexPath.row];
    if (time.endDate) {
        return time.endDate;
    }else{
        return [time.date dateByAddingTimeInterval:60*30];
    }
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout{
    return [NSDate date];
}

//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
//    Events *event = [eventArray objectAtIndex:indexPath.row];
//    cell.titleLabel.text = event.title;
//    cell.dateLabel.text = [[Date getDefaultDateFormatter] stringFromDate:event.date];
//    
//    return cell;
//}

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
        [self.collectionView reloadData];
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
                [self.collectionView reloadData];
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

-(void)setUpCollectionView{
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    self.collectionView.frame = self.collectionView.bounds;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionView reloadData];
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
        [self.collectionView reloadData];
    }
    self.eventCountl.text = [NSString stringWithFormat:NSLocalizedString(@"%lu Events on this day", nil), (unsigned long)array.count];
}

- (IBAction)addNewEvent:(id)sender {
    //[self performSegueWithIdentifier:@"idaddNewEvent" sender:nil];
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{

    [_calendarManager reload];
    
    NSMutableArray *array = [EventsHelper findEventsForToday:[NSDate date] withRealm:[Events allObjects]];
    if(array.count > 0){
        eventArray = array;
        [self.collectionView reloadData];
    }
    
    //collection view settings
    NSMutableArray *events = [EventsHelper findTodayNotCompletedEvents:[Events allObjects]];
    collectionViewArray = [events arrayByAddingObjectsFromArray:[EventManager timePeriodsinTimeline]];
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
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
