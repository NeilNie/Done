//
//  TodoViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodoViewController.h"

@interface TodoViewController ()

@property(nonatomic) CGPoint startPoint;

@end

@implementation TodoViewController

#pragma mark - MDTab Bar

- (void)tabBar:(MDTabBar *)tabBar didChangeSelectedIndex:(NSUInteger)selectedIndex {
    [self loadViewBasedonTabBar];
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    sameSelection = NO;
    if (selected == indexPath.row){
        sameSelection = YES;
    }else{
        selected = indexPath.row;
    }
    [self.table beginUpdates];
    [self.table endUpdates];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return allEvents.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (sameSelection) {
        return 70;
    }else if ([indexPath row] == selected){
        return 103;
    }else{
        return 70.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row + 1 == allEvents.count) {
        addEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addEventCell" forIndexPath:indexPath];
        cell.textfield.text = @"";
        cell.delegate = self;
        return cell;
    }else{
        EventTableViewCell *cell = (EventTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        
        Events *event = [allEvents objectAtIndex:indexPath.row];
        cell.event = event;
        [cell setUpCell];
        cell.delegate = self;
        return cell;
    }
}
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
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
    return leftUtilityButtons;
}

#pragma mark - SWTableViewCell Delegate

-(void)reloadTableView{
    [self.table reloadData];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {

    switch (index) {
        case 0:
            [self markImportant:(EventTableViewCell *)cell];
            break;
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    switch (index) {
        case 0:
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
    [cell hideUtilityButtonsAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
}

#pragma mark - AddEventCell Delegate

-(void)addNewEventFromCell:(addEventCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *event = [EventsHelper createEventWithDate:[NSDate date] title:cell.textfield.text otherInfo:nil];
    [self.project.events addObject:event];
    [realm commitWriteTransaction];
    
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [allEvents addObject:@""];
    [self.table reloadData];
    
    [self setReminder:[[NSDate date] dateByAddingTimeInterval:5 * 60] withText:cell.textfield.text];
}

-(void)textFieldBeginEditing{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tableButtom.constant = 270;
            [self.view layoutIfNeeded];
        }];
    });
}

-(void)textFieldEndEditing{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.tableButtom.constant = 0;
            [self.view layoutIfNeeded];
        }];
    });
}

#pragma mark - Private

-(void)markImportant:(EventTableViewCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = cell.event;
    update.important = YES;
    [realm commitWriteTransaction];
}

-(void)clickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = cell.event;
    update.completed = YES;
    [realm commitWriteTransaction];
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [allEvents addObject:@""];
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)setReminder:(NSDate *)date withText:(NSString *)text{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = date;
    notification.alertTitle = NSLocalizedString(@"You have a new reminder", nil);
    notification.alertBody = text;
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.timeZone = [NSTimeZone localTimeZone];
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNewEvent{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController __weak *view = [storyboard instantiateViewControllerWithIdentifier:@"createNew"];
    ((CreateNewVC *)view.topViewController).delegate = self;
    ((CreateNewVC *)view.topViewController).addedToProject = self.project;
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:view animated:YES completion:nil];
    });
}

-(void)addNewProject{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"New Project", nil)
                                                                    message:NSLocalizedString(@"Create a title for this project", nil)
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add", nil) style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if (((UITextField *)[alert.textFields objectAtIndex:0]).text) {
                                                                  RLMRealm *realm = [RLMRealm defaultRealm];
                                                                  [realm beginWriteTransaction];
                                                                  Projects *project = [[Projects alloc] init];
                                                                  project.title = ((UITextField *)[alert.textFields objectAtIndex:0]).text;
                                                                  [realm addObject:project];
                                                                  [realm commitWriteTransaction];
                                                                  [self setUpTabBar];
                                                                  [alert dismissViewControllerAnimated:YES completion:nil];
                                                              }
                                                          }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)editProjects{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *view = [storyboard instantiateViewControllerWithIdentifier:@"tableViewController"];
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:view animated:YES completion:nil];
    });
}

-(void)syncDataWithExtension{
    
    NSMutableArray *a = [EventsHelper findEventsForToday:[NSDate date] withRealm:[Events allObjects]];
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    [shared setObject:[NSNumber numberWithInteger:a.count] forKey:@"totalEvents"];
    [shared setObject:[NSNumber numberWithInteger:[EventsHelper findCompletedEventsWithArrayOfEvents:allEvents withDate:[NSDate date]].count] forKey:@"completedEvents"];
    Events *event = [EventsHelper findMostRecentEvent:[NSDate date] withArrayOfEvents:allEvents];
    [shared setObject:event.title forKey:@"title"];
    [shared setObject:event.date forKey:@"date"];
    [shared synchronize];
}

-(void)loadViewBasedonTabBar{
    
    allEvents = [NSMutableArray array];
    RLMResults *result = [Events allObjects];
    if (self.tabBar.selectedIndex == 0) {
        allEvents = [EventsHelper findImportantEvents:[NSDate date] withRealm:result];
        [allEvents addObject:@""];
        [self.table reloadData];

    }else if (self.tabBar.selectedIndex == tabBarArray.count - 1){
        allEvents = [EventsHelper findTodayCompletedEvents:result];
        [allEvents addObject:@""];
        [self.table reloadData];
    }else if (self.tabBar.selectedIndex == tabBarArray.count - 2){
        allEvents = [EventsHelper convertEventsToArray:result];
        [allEvents addObject:@""];
        [self.table reloadData];
    }else{
        self.project = [EventsHelper findProjectWithName:[tabBarArray objectAtIndex:self.tabBar.selectedIndex]];
        allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
        [allEvents addObject:@""];
        [self.table reloadData];
    }
}

-(void)setUpTabBar{
    
    self.tabBar.delegate = self;
    
    tabBarArray = [[NSMutableArray alloc] initWithObjects:@"Important", nil];
    RLMResults *allProjects = [Projects allObjects];
    for (int i = 0; i < allProjects.count; i++) {
        Projects *currentProject = [allProjects objectAtIndex:i];
        [tabBarArray addObject:currentProject.title];
    }
    [tabBarArray addObject:@"Completed"];
    [tabBarArray addObject:@"All"];
    [self.tabBar setItems:tabBarArray];

    self.tabBar.textFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}

-(void)setUpButtons{
    
    self.btMore.mdButtonDelegate = self;
    self.btMore.rotated = NO;
    
    //invisible all related buttons
    self.btEdit.alpha = 0.f;
    self.btAddEvent.alpha = 0.f;
    self.btAddProject.alpha = 0.f;
    
    _startPoint = CGPointMake(self.btMore.center.x, self.btMore.center.y - 100);
    self.btEdit.center = _startPoint;
    self.btAddEvent.center = _startPoint;
    self.btAddProject.center = _startPoint;
    [self.btMore setImageSize:25.0f];
}

- (IBAction)btnClicked:(id)sender {
    
    if (sender == self.btMore) {
        self.btMore.rotated = NO; //reset floating finging button
    }
    if (sender == self.btAddEvent) {
        [self addNewEvent];
    }
    if (sender == self.btAddProject) {
        [self addNewProject];
    }
    if (sender == self.btEdit) {
        [self editProjects];
    }
}

-(void)rotationStarted:(id)sender {
    
    if (self.btMore == sender){
        int padding = 90;
        CGFloat duration = 0.2f;
        if (!self.btMore.isRotated) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options: (UIViewAnimationOptionAllowUserInteraction|UIViewAnimationCurveEaseOut)
                             animations:^{
                                 self.btEdit.alpha = 1;
                                 self.btEdit.transform = CGAffineTransformMakeScale(1.0,.4);
                                 self.btEdit.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, +padding*3.5f), CGAffineTransformMakeScale(1.0, 1.0));
                                 
                                 self.btAddProject.alpha = 1;
                                 self.btAddProject.transform = CGAffineTransformMakeScale(1.0,.5);
                                 self.btAddProject.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, +padding*2.7f), CGAffineTransformMakeScale(1.0, 1.0));
                                 
                                 self.btAddEvent.alpha = 1;
                                 self.btAddEvent.transform = CGAffineTransformMakeScale(1.0,.6);
                                 self.btAddEvent.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation(0, +padding*2), CGAffineTransformMakeScale(1.0, 1.0));
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
       } else {
            [UIView animateWithDuration:duration/2
                                  delay:0.0
                                options: kNilOptions
                             animations:^{
                                 self.btEdit.alpha = 0;
                                 self.btEdit.transform = CGAffineTransformMakeTranslation(0, 0);
                                 
                                 self.btAddProject.alpha = 0;
                                 self.btAddProject.transform = CGAffineTransformMakeTranslation(0, 0);
                                 
                                 self.btAddEvent.alpha = 0;
                                 self.btAddEvent.transform = CGAffineTransformMakeTranslation(0, 0);
                                 
                             } completion:^(BOOL finished) {
                                 
                             }];
        }
    }
}
-(void)rotationCompleted:(id)sender{
    
    if (self.btMore == sender){
        //NSLog(@"btShare rotationCompleted %s", self.btMore.isRotated?"rotated":"normal");
    }
}

#pragma mark - Life Cycle

-(void)viewDidLayoutSubviews{
    
    _startPoint = CGPointMake(self.btMore.center.x, self.btMore.center.y - 100);
    self.btEdit.center = _startPoint;
    self.btAddEvent.center = _startPoint;
    self.btAddProject.center = _startPoint;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpTabBar];
    [self loadViewBasedonTabBar];
    //[self syncDataWithExtension];
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    [self setUpButtons];
    NSLog(@"%@", [RLMRealm defaultRealm].configuration.fileURL);
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    [self.table registerNib:[UINib nibWithNibName:@"addEventCell" bundle:nil] forCellReuseIdentifier:@"addEventCell"];
    
    sameSelection = YES;
    selected = 1;

    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        vc.addedToProject = self.project;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
