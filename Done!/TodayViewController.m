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

@implementation TodayViewController {
    MDRippleLayer *mdLayer;
}

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
    Events *update = [EventsHelper findEventWithTitle:cell.titleLabel.text withAllRealm:[Events allObjects]];
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
-(IBAction)switchViews:(id)sender{
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (areAdsRemoved == NO && self.switchView.isOn) {
        [self initShowAlert];
    }
    if ([self.switchView isOn]) {
        [UIView animateWithDuration:0.2 animations:^{
            self.graphView.alpha = 1.0f;
        }];
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.graphView.alpha = 0.0f;
        }];
    }
}

-(void)setUpCollectionView{
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
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
    
    view.layer.shadowRadius = 1.5f;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(-1.0f, 2.5f);
    view.layer.shadowOpacity = 0.9f;
    view.layer.masksToBounds = NO;
}

-(void)setupView{
    
    //check for ads removed.
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!areAdsRemoved) {
        self.banner.adUnitID = @"ca-app-pub-7942613644553368/9252365932";
        self.banner.rootViewController = self;
        [self.banner loadRequest:[GADRequest request]];
    }else{
        self.banner.hidden = YES;
    }
    
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    [self.table reloadData];
    [self.collectionView reloadData];
    
    //set up views with data
    Events *event = [EventsHelper findMostRecentEvent:[NSDate date] withRealmResult:result];
    self.upcomingTime.text = [[EventsHelper dateFormatter] stringFromDate:event.date];
    self.upcomingTitle.text = event.title;
    self.totalLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)allEvents.count];
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
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (areAdsRemoved == NO) {
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        blurEffectView.frame = self.graphView.bounds;
//        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.graphView.center.x - 90, self.graphView.center.y, 180, 45)];
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Productivity Graph is a pro feature";
        label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
        label.textColor = [UIColor whiteColor];
        //[self.graphView addSubview:blurEffectView];
        [self.graphView addSubview:label];
    }
}
-(void)initShowAlert{
    
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    alert.showAnimationType = FadeIn;
    [alert addButton:NSLocalizedString(@"Learn More", nil) actionBlock:^(void) {
        //[self performSegueWithIdentifier:@"idShowPurchase" sender:nil];
    }];
    [alert showNotice:self title:NSLocalizedString(@"Notice", nil) subTitle: NSLocalizedString(@"Productivity Graph is a pro feature. You have to purchase it in order to enjoy the pro features.", nil) closeButtonTitle:@"Done" duration:0.0f];
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
-(IBAction)showMenu:(id)sender{
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
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
    
    [super viewDidLoad];
    
    //get data for today
    result = [Events allObjects];
    allEvents = [EventsHelper findEventsForToday:[NSDate date] withRealm:result];
    [self.table reloadData];
    
    self.labels = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7"];
    
    self.tvConst.constant = self.view.bounds.size.width / 3 - 5;
    self.todayConst.constant = self.view.bounds.size.width / 3 - 5;
    self.completedConst.constant = self.view.bounds.size.width / 3 - 5;
    self.tableContr.constant = self.view.bounds.size.height - 190 - 160;
    
    [self setUpGestures];
    [self setShadowforView:self.totalEView];
    [self setShadowforView:self.todayView];
    [self setShadowforView:self.completedEView];
    [self setShadowforView:self.graphView];
    [self setShadowforView:self.masterView];
    [self setShadowforView:self.switchView];
    
    [self setUpCollectionView];
    [self.collectionView reloadData];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
    
    self.completedEView.center = CGPointMake(self.completedEView.center.x, self.completedEView.center.y - 100);
    self.totalEView.center = CGPointMake(self.totalEView.center.x, self.totalEView.center.y - 100);
    self.todayView.center = CGPointMake(self.completedEView.center.x, self.todayView.center.y - 100);

    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.completedEView.center = CGPointMake(self.completedEView.center.x, self.completedEView.center.y + 100);
        self.totalEView.center = CGPointMake(self.totalEView.center.x, self.totalEView.center.y + 100);
        self.tableContr.constant = 4;
        [self.view layoutIfNeeded];
    }];
    //[self setUpGraphData];
    [self setupView];
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
