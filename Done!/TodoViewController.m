//
//  TodoViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TodoViewController.h"

@interface TodoViewController ()

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
    NSIndexPath *indexPath = [self.table indexPathForCell:cell];
    switch (index) {
        case 0:
            [EventsHelper deleteEvent:[allEvents objectAtIndex:indexPath.row]];
            [allEvents removeObjectAtIndex:indexPath.row];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            NSLog(@"deleted");
            if(WCSession.isSupported){
                NSLog(@"sent request");
                WCSession *session = [WCSession defaultSession];
                session.delegate = self;
                [session activateSession];
                [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
                NSLog(@"updated context");
            }
            break;
        case 1:
            [self clickedDone:(EventTableViewCell *)cell];
            break;
        default:
            break;
    }
}

#pragma mark - EventCell Delegate

-(void)addNewEventFromCell:(addEventCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *event = [EventsHelper createEventWithDate:[NSDate date] title:cell.textfield.text otherInfo:nil];
    [self.project.events addObject:event];
    [realm commitWriteTransaction];
    
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    //[self syncDataWithExtension];
    [allEvents addObject:@""];
    [self.table reloadData];
}

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
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
    [allEvents addObject:@""];
}

-(void)starEvent:(EventTableViewCell *)cell{
    
}
-(void)setReminder:(EventTableViewCell *)cell{
    
}
-(void)moveEvent:(EventTableViewCell *)cell{
    
}
-(void)attachments:(EventTableViewCell *)cell{
    
}

#pragma mark - CreateNew Delegate

-(void)addProject:(Projects *)project{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:project];
    [realm commitWriteTransaction];
    NSLog(@"new project added %@", project);
}

-(void)addNewEventToProject:(Events *)event{}

#pragma mark - Private

- (IBAction)addNewEvent:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *view = [storyboard instantiateViewControllerWithIdentifier:@"createNew"];
    ((CreateNewVC *)view.topViewController).delegate = self;
    
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
    switch (self.tabBar.selectedIndex) {
        case 0:
            allEvents = [EventsHelper findImportantEvents:[NSDate date] withRealm:result];
            [allEvents addObject:@""];
            [self.table reloadData];
            return;
            break;
        case 1:
            allEvents = [EventsHelper findTodayCompletedEvents:result];
            [allEvents addObject:@""];
            [self.table reloadData];
            return;
            break;
        case 2:
            allEvents = [EventsHelper convertEventsToArray:result];
            [allEvents addObject:@""];
            [self.table reloadData];
            return;
            break;
            
        default:
            break;
    }
    
    if (self.tabBar.selectedIndex == tabBarArray.count) {
        
    }else{
        self.project = [EventsHelper findProjectWithName:[tabBarArray objectAtIndex:self.tabBar.selectedIndex]];
        allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
        [allEvents addObject:@""];
        [self.table reloadData];
    }
}

-(void)setUpTabBar{
    
    _tabBar.delegate = self;
    
    tabBarArray = [[NSMutableArray alloc] initWithObjects:@"Important", @"Completed", @"All", nil];
    RLMResults *allProjects = [Projects allObjects];
    for (int i = 0; i < allProjects.count; i++) {
        Projects *currentProject = [allProjects objectAtIndex:i];
        [tabBarArray addObject:currentProject.title];
    }
    [tabBarArray addObject:@"+"];
    [_tabBar setItems:tabBarArray];

    self.tabBar.textFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [self setUpTabBar];
    [self loadViewBasedonTabBar];
    //[self syncDataWithExtension];
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
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
