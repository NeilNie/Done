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
        cell.delegate = self;
        return cell;
    }else{
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
        cell.leftUtilityButtons = [self leftButtons];
        cell.rightUtilityButtons = [self rightButtons];
        Events *event = [allEvents objectAtIndex:indexPath.row];
        NSDateFormatter *formate = [[NSDateFormatter alloc] init];
        [formate setDateFormat:@"dd/MM/yyyy HH:MM"];
        cell.titleLabel.text = event.title;
        cell.dateLabel.text = [formate stringFromDate:event.date];
        if (event.important == YES) {
            [cell.starButton setImage:[UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
        }else{
            [cell.starButton setImage:[UIImage imageNamed:@"star.png"] forState:UIControlStateNormal];
        }
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

#pragma EventCell Delegate

-(void)addNewEventFromCell:(addEventCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *event = [EventsHelper createEventWithDate:[NSDate date] title:cell.textfield.text otherInfo:nil];
    [realm addObject:event];
    [realm commitWriteTransaction];
    
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [self syncDataWithExtension];
    [allEvents addObject:@""];
    [self.table reloadData];
    
}

-(void)markImportant:(EventTableViewCell *)cell{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = [EventsHelper findEventWithTitle:cell.titleLabel.text withRealm:self.project.events];
    update.important = YES;
    [realm commitWriteTransaction];
}

-(void)clickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = [EventsHelper findEventWithTitle:cell.titleLabel.text withRealm:self.project.events];
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

#pragma mark - Private

- (IBAction)addNewEvent:(id)sender{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"createNew"];
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

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [self syncDataWithExtension];
    [allEvents addObject:@""];
    
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!areAdsRemoved) {
        self.banner.adUnitID = @"ca-app-pub-7942613644553368/9252365932";
        self.banner.rootViewController = self;
        [self.banner loadRequest:[GADRequest request]];
    }else{
        self.banner.hidden = YES;
    }
    
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    self.naviTitle.title = self.project.title;
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [allEvents addObject:@""];
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    [self.table registerNib:[UINib nibWithNibName:@"addEventCell" bundle:nil] forCellReuseIdentifier:@"addEventCell"];
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!areAdsRemoved) {
        self.banner.adUnitID = @"ca-app-pub-7942613644553368/9252365932";
        self.banner.rootViewController = self;
        [self.banner loadRequest:[GADRequest request]];
    }else{
        self.banner.hidden = YES;
    }
    
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
