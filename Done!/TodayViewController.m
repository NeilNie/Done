//
//  TodayViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"

@interface TodayViewController ()

@end

@implementation TodayViewController

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    Events *event = [allEvents objectAtIndex:indexPath.row];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy HH:MM"];
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [formate stringFromDate:event.date];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return allEvents.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    cell.event = [allEvents objectAtIndex:indexPath.row];
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
    Events *event = [allEvents objectAtIndex:indexPath.row];
    return [event.date dateByAddingTimeInterval:-(60 * 60 * 2)];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *event = [allEvents objectAtIndex:indexPath.row];
    // Most sports last ~3 hours, and SeatGeek doesn't provide an end time
    return event.date;
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout{
    return [NSDate date];
}

#pragma mark - EventCell Delegate

-(void)clickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = cell.event;
    update.completed = YES;
    [realm commitWriteTransaction];
    allEvents = [EventsHelper findTodayNotCompletedEvents:[Events allObjects]];
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Privates

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe{
    
    NSLog(@"swiped");
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [UIView animateWithDuration:0.4 animations:^{
            self.contr.constant = self.masterView.bounds.size.width;
            [self.view layoutIfNeeded];
        }];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [UIView animateWithDuration:0.4 animations:^{
            self.contr.constant = 0;
            [self.view layoutIfNeeded];
        }];
        [self setUpCollectionView];
        [self.collectionView reloadData];
    }
}

-(void)setUpCollectionView{
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
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
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    if (_graphView.alpha == 1) {
        [self performSegueWithIdentifier:@"showGraphUI" sender:nil];
    }
}

-(void)setUpGestures{
    
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.table addGestureRecognizer:left];
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.collectionView addGestureRecognizer:right];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.graphView addGestureRecognizer:tap];
}

-(void)setShadowforView:(UIView *)view{
    
    view.layer.cornerRadius = 15;
    view.layer.shadowRadius = 2.0f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 3.0f);
    view.layer.shadowOpacity = 0.8f;
    view.layer.masksToBounds = NO;

}

-(void)setUpUserInterface{

    //set up data
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    [self.table reloadData];
    [self.collectionView reloadData];
    self.labels = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7"];
    
    //set up views with data
    //self.totalLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)allEvents.count];
    self.completedLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[EventsHelper findCompletedEventsWithArrayOfEvents:allEvents withDate:[NSDate date]].count];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formate setDateFormat:@"MMMM"];
    self.yearLabel.text = [NSString stringWithFormat:@"%@ 2016", [formate stringFromDate:date]];
    [formate setDateFormat:@"dd"];
    self.dateLabel.text = [formate stringFromDate:date];
    [formate setDateFormat:@"EEEE"];
    self.weekLabel.text = [formate stringFromDate:[NSDate date]];
    
    //hide or show table
    if (allEvents.count == 0) {
        self.table.hidden = YES;
        self.collectionView.hidden = YES;
        self.clearLabel.hidden = NO;
    }else{
        self.table.hidden = NO;
        self.collectionView.hidden = NO;
        self.clearLabel.hidden = YES;
    }
}

- (void)setUpLineGraph{
    
    self.data = [[NSMutableArray alloc] initWithObjects:self.completedData,self.eventNumber, nil];
    self.graphView.dataSource = self;
    self.graphView.lineWidth = 3.0;
    
    self.graphView.valueLabelCount = 5;
    [self.graphView draw];
}

-(void)setUpGraphData{
    
    self.data = [NSMutableArray array];
    self.completedData = [NSMutableArray array];
    self.eventNumber = [NSMutableArray array];
    
    RLMResults *events = [Events allObjects];
    for (int i = 7; i > 0; i--) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:i * -(60 * 60 * 24)];
        NSMutableArray *a = [EventsHelper findCompletedEventsRealm:events withDate:date];
        NSMutableArray *a2 = [EventsHelper findEventsForToday:date withRealm:events];
        [self.completedData addObject:[NSNumber numberWithInteger:a.count]];
        [self.eventNumber addObject:[NSNumber numberWithInteger:a2.count]];
    }
    [self setUpLineGraph];
    [self.graphView reset];
    [self.graphView draw];
}

- (void)updateAuthorizationStatusToAccessEventStore {
    
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            
            self.ApplicationDelegate.eventManager.eventsAccessGranted = NO;
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Oh No" message:@"We have no acess to your calendar" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertView animated:YES completion:nil];
            break;
        }
            
            // 4
        case EKAuthorizationStatusAuthorized:
            self.ApplicationDelegate.eventManager.eventsAccessGranted = YES;
            NSLog(@"access granted");
            break;
            
            // 5
        case EKAuthorizationStatusNotDetermined: {

            [self.ApplicationDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                if (error == nil) {
                    // Store the returned granted value.
                    self.ApplicationDelegate.eventManager.eventsAccessGranted = granted;
                }
                else{
                    // In case of error, just log its description to the debugger.
                    NSLog(@"%@", [error localizedDescription]);
                }
            }];
            break;
        }
    }
}

-(void)setUpview{

    self.todayConstr.constant = (self.view.frame.size.width - 10) * 3 / 4;
    
    //set up shadows in view
    [self setShadowforView:self.preferenceButton];
    [self setShadowforView:self.userButton];
    [self setShadowforView:self.todayView];
    [self setShadowforView:self.graphView];
    [self setShadowforView:self.masterView];
    [self setShadowforView:self.calendarButton];
    [self setShadowforView:self.listButton];
    [self setShadowforView:self.addNewButton];
    //set up for animation
}

#pragma mark - GraphKit Delegate

- (NSInteger)numberOfLines {
    return [self.data count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_orangeColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return [[@[@1.5, @2] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    self.ApplicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setUpGestures];
    [self setUpCollectionView];
    [self setUpview];
    [self updateAuthorizationStatusToAccessEventStore];
    
#warning testing methods
    NSLog(@"%@", [NYDate getDateTodayWithHour:15 minutes:0]);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{

//#warning fix this methods
    //[self setUpGraphData];
    [self setUpUserInterface];
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue destinationViewController] isKindOfClass:[CreateNewVC class]]) {
        CreateNewVC *vc = [segue destinationViewController];
        vc.sender = @"event";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
