//
//  TodayViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/26/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodayViewController.h"

@interface TodayViewController (){
    NSMutableArray *allEvents;
    RLMResults *result;
}
@property (nonatomic, strong) AppDelegate *ApplicationDelegate;

@end

@implementation TodayViewController

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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TodayTableViewHeaderView *header = [self.table dequeueReusableHeaderFooterViewWithIdentifier:@"TableSectionHeader"];
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd"];
    header.dateLabel.text = [dateFormatter stringFromDate:currentDateTime];

    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    
    Task *event = [allEvents objectAtIndex:indexPath.row];
    cell.event = event;
    cell.titleLabel.textColor = [UIColor whiteColor];
    [cell setUpCell];
    cell.delegate = self;
    return cell;
}

- (NSArray *)rightButtons{
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0] title:@"Done"];
    [rightUtilityButtons sw_addUtilityButtonWithColor: [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f] title:@"Delete"];
    
    return rightUtilityButtons;
}

- (NSArray *)leftButtons{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    [leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor orangeColor] title:@"Important"];
    [leftUtilityButtons sw_addUtilityButtonWithColor: [UIColor blueColor] title:@"Hide"];;
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
    
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    switch (index) {
        case 0:
            [self clickedDone:(EventTableViewCell *)cell];
            break;
        case 1:
            [EventsHelper deleteEvent:[allEvents objectAtIndex:indexPath.row]];
            [allEvents removeObjectAtIndex:indexPath.row];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
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
    Task *update = cell.event;
    update.important = YES;
    [realm commitWriteTransaction];
}

-(void)clickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Task *update = cell.event;
    update.completed = YES;
    [realm commitWriteTransaction];
    allEvents = [EventsHelper findTodayNotCompletedEvents:[Task allObjects]];
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Privates

-(IBAction)refreshData:(id)sender{
    
    result = [Task allObjects];
    allEvents = [EventsHelper findTodayNotCompletedEvents:result];
    self.ApplicationDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setUpview];
    [self setUpUserInterface];
    [self.table reloadData];
    
}

-(IBAction)addNewEvent:(id)sender{
    
    
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
    
    //set up views with data
    NSUInteger totalEts = allEvents.count;
    NSUInteger compleEts = [EventsHelper findCompletedEventsWithArrayOfEvents:allEvents withDate:[EventsHelper currentDateLocalTimeZone]].count;
    self.completedLabel.text = [NSString stringWithFormat:@"%lu/%lu", (unsigned long)compleEts, (unsigned long)totalEts];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formate setDateFormat:@"MMMM"];
    self.yearLabel.text = [NSString stringWithFormat:@"%@", [formate stringFromDate:date]];
    [formate setDateFormat:@"dd"];
    self.dateLabel.text = [formate stringFromDate:date];
    [formate setDateFormat:@"EEEE"];
    self.weekLabel.text = [formate stringFromDate:[NSDate date]];
    [self.table reloadData];

}

- (void)updateAuthorizationStatusToAccessEventStore {
    
    // 2
    EKAuthorizationStatus authorizationStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    
    switch (authorizationStatus) {
            // 3
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted: {
            
            self.ApplicationDelegate.eventManager.eventsAccessGranted = NO;
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Oh No", nil) message:NSLocalizedString(@"We have no acess to your calendar", nil) preferredStyle:UIAlertControllerStyleAlert];
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

    self.todayConstr.constant = (self.view.frame.size.width - 10) / 3;
    
    //set up shadows in view
    for (UIButton *view in self.buttons) {
        [self setShadowforView:view];
    }
    [self setShadowforView:self.todayView];
    [self setShadowforView:self.masterView];
    [self setShadowforView:self.graphView];
    
    //set up for animation
}

-(void)syncWithExtension{
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    [sharedDefaults setObject:[EventsHelper convertAllObjecttoArray] forKey:@"idAllItems"];
    [sharedDefaults synchronize];
}

#pragma mark - Gesture

-(void)tapMasterView:(UITapGestureRecognizer *)tap{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"idShowTasks" sender:nil];
    });
}

-(void)setupGestures{
    UITapGestureRecognizer *tapTimeline = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMasterView:)];
    [self.masterView addGestureRecognizer:tapTimeline];
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self refreshData:nil];
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    [self setupGestures];
    [self updateAuthorizationStatusToAccessEventStore];
    
    self.table.sectionHeaderHeight = 115;
    UINib *nib = [UINib nibWithNibName:@"TodayTableViewHeaderView" bundle:nil];
    [self.table registerNib:nib forHeaderFooterViewReuseIdentifier:@"TableSectionHeader"];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self setUpUserInterface];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([[segue destinationViewController] isKindOfClass:[CreateNewVC class]]) {
//        CreateNewVC *vc = [segue destinationViewController];
//        vc.sender = @"event";
//    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
