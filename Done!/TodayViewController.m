//
//  TodayViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"

@interface TodayViewController ()

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSMutableArray *completedData;
@property (strong, nonatomic) NSMutableArray *eventNumber;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) AppDelegate *ApplicationDelegate;
@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation TodayViewController

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#pragma mark - UIViewControllerPreviewingDelegate

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit{
    
}

-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location{
    return nil;
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
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
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

#pragma mark - CreateNew Delegate

-(void)addProject:(Projects *)project{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:project];
    [realm commitWriteTransaction];
    NSLog(@"new project added %@", project);
}

#pragma mark - Privates

-(NSArray<Events *> *)timePeriodsinTimeline{

    NSArray *calendarEvents = [[[EventManager alloc] init] getTodayEventCalendars];
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
    NSArray *returnArray = [allEvents arrayByAddingObjectsFromArray:events];
    return returnArray;
}

-(IBAction)refreshData:(id)sender{
    
    result = [Events allObjects];
    collectionViewArray = [self timePeriodsinTimeline];
    allEvents = [EventsHelper findTodayNotCompletedEvents:result];
    self.ApplicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setUpCollectionView];
    [self setUpview];
    
    //YOU SHOULDN'T DO THIS. Call the -setUpGraph function in a dispatch block with system low level timer. However, there is no easy workaround. We have to wait until the layout is full loaded and setup before calling -setUpGraph function.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.graphView reset];
        [self setUpGraphData];
    });
    [self.collectionView reloadData];
    [self setUpUserInterface];
}

-(IBAction)addNewEvent:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController * __strong view = [storyboard instantiateViewControllerWithIdentifier:@"createNew"];
    ((CreateNewVC *)view.topViewController).delegate = self;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:view animated:YES completion:nil];
    });
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
    [self.collectionView reloadData];
}

-(void)tapGesture:(UITapGestureRecognizer *)tap{
    if (_graphView.alpha == 1) {
        [self performSegueWithIdentifier:@"showGraphUI" sender:nil];
    }
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

    self.labels = @[@"1", @"2", @"3",@"4", @"5", @"6",@"7"];
    
    //set up views with data
    NSUInteger totalEts = allEvents.count;
    NSUInteger compleEts = [EventsHelper findCompletedEventsWithArrayOfEvents:allEvents withDate:[EventsHelper currentDateLocalTimeZone]].count;
    self.completedLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)compleEts, (unsigned long)totalEts];
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
        self.collectionView.hidden = YES;
        self.clearLabel.hidden = NO;
    }else{
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
    for (int i = 6; i >= 0; i--) {
        
        NSDate *date = [NSDate dateWithTimeInterval:i * -(60 * 60 * 24) sinceDate:[EventsHelper currentDateLocalTimeZone]];
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
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Oh No", ni
                                                                                                         ) message:NSLocalizedString(@"We have no acess to your calendar", ni
                                                                                                                          ) preferredStyle:UIAlertControllerStyleAlert];
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
    if (self.view.bounds.size.width == 320) {
        self.graphConstr.constant = 135;
    }
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

-(void)tapTimeline:(UITapGestureRecognizer *)tap{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showTimeline" sender:nil];
    });
}
-(void)tapGraph:(UITapGestureRecognizer *)tap{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showGraph" sender:nil];
    });
}

-(void)setupGestures{
    
    UITapGestureRecognizer *tapTimeline = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTimeline:)];
    UITapGestureRecognizer *tapGraph = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGraph:)];
    [self.masterView addGestureRecognizer:tapTimeline];
    [self.graphView addGestureRecognizer:tapGraph];
}

-(void)syncWithExtension{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    [sharedDefaults setObject:[EventsHelper convertAllObjecttoArray] forKey:@"idAllItems"];
    [sharedDefaults synchronize];
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
    return [[@[@2, @1.5] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    result = [Events allObjects];
    allEvents = [EventsHelper findTodayNotCompletedEvents:result];
    collectionViewArray = [self timePeriodsinTimeline];
    self.ApplicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self syncWithExtension];
    [self setUpview];
    [self setupGestures];
    [self setUpCollectionView];
    [self updateAuthorizationStatusToAccessEventStore];
    
    //YOU SHOULDN'T DO THIS. Call the -setUpGraph function in a dispatch block with system low level timer. However, there is no easy workaround. We have to wait until the layout is full loaded and setup before calling -setUpGraph function.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.graphView reset];
        [self setUpGraphData];
    });
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpUserInterface];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
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
