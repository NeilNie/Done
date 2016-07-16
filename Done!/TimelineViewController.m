//
//  TimelineViewController.m
//  Done!
//
//  Created by Yongyang Nie on 7/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation TimelineViewController

NSString * const MSCEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSCDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSCTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    
    Events *event = [allEvents objectAtIndex:indexPath.row];
    cell.event = event;
    cell.titleLabel.textColor = [UIColor whiteColor];
    [cell setUpCell];
    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Done"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor orangeColor] title:@"Important"];
    [leftUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor blueColor] title:@"Hide"];;
    return leftUtilityButtons;
}

#pragma mark - SWTableViewCell Delegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self markImportant:(EventTableViewCell *)cell];
            break;
        case 1:
            NSLog(@"clock button was pressed");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (index) {
        case 0:
            [self clickedDone:(EventTableViewCell *)cell];
            break;
        case 1:
            [EventsHelper deleteEvent:[allEvents objectAtIndex:indexPath.row]];
            [allEvents removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            if(WCSession.isSupported){
                NSLog(@"sent request");
                WCSession *session = [WCSession defaultSession];
                session.delegate = self;
                [session activateSession];
                [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
                NSLog(@"updated context");
            }
            break;
        default:
            break;
    }
}

#pragma mark - EventCell Delegate

-(void)markImportant:(EventTableViewCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = cell.event;
    update.important = YES;
    [realm commitWriteTransaction];
}

-(void)clickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = cell.event;
    update.completed = YES;
    [realm commitWriteTransaction];
    allEvents = [EventsHelper findTodayNotCompletedEvents:[Events allObjects]];
    [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSCEventCellReuseIdentifier forIndexPath:indexPath];
    cell.event = [collectionViewArray objectAtIndex:indexPath.row];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSCDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSCTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
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

#pragma mark - Privates

-(IBAction)expandClose:(id)sender{
    
    if (self.constrs.constant == 40) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.constrs.constant = 250;
                [self.view layoutIfNeeded];
                self.button.transform = CGAffineTransformMakeRotation(2*M_PI_2);
            }];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.constrs.constant = 45;
                [self.view layoutIfNeeded];
                self.button.transform = CGAffineTransformMakeRotation(-2*M_PI_2);
            }];
        });
    }
}

-(NSArray<Events *> *)timePeriodsinTimeline{
    
    EventManager *manager = [[EventManager alloc] init];
    NSArray *calendarEvents = [manager getTodayEventCalendars];
    NSMutableArray *events = [NSMutableArray array];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd"];
    
    for (int i = 0; i < calendarEvents.count; i++) {
        Events *event = [[Events alloc] init];
        EKEvent *calendar = [calendarEvents objectAtIndex:i];
        if ([[formate stringFromDate:calendar.startDate] isEqualToString:[formate stringFromDate:calendar.endDate]]) {
            event.title = calendar.title;
            event.date = calendar.startDate;
            event.endDate = calendar.endDate;
            [events addObject:event];
        }
    }
    NSArray *returnArray = [[EventsHelper findTodayCompletedEvents:[Events allObjects]] arrayByAddingObjectsFromArray:events];
    return returnArray;
}

-(void)setUpCollectionView{
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSCEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSCDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSCTimeRowHeaderReuseIdentifier];
    
    //self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
    
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    
    collectionViewArray = [self timePeriodsinTimeline];
    allEvents = [EventsHelper findTodayNotCompletedEvents:[Events allObjects]];
    [self.tableView registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    self.tableView.layer.cornerRadius = 20.0f;
    [self setUpCollectionView];
    [self.tableView reloadData];
    [super viewDidLoad];
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
