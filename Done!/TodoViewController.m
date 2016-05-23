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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

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
    }
}

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
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [formate stringFromDate:event.date];
    if (event.important == YES) {
        cell.importantIcon.hidden = NO;
    }else{
        cell.importantIcon.hidden = YES;
    }
    
    cell.delegate = self;
    return cell;
    
}

#pragma EventCell Delegate

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
}

#pragma mark - Private

- (IBAction)addNewEvent:(id)sender {
    
    [self performSegueWithIdentifier:@"newEvent" sender:nil];
    [self performSelector:@selector(function) withObject:nil afterDelay:5];
    
}
-(void)function{
    [refresh endRefreshing];
}
-(void)setUpView{
    
    refresh = [[UIRefreshControl alloc] init];
    refresh.backgroundColor = [UIColor colorWithRed:49.0/225.0 green:116.0/225.0 blue:250.0/225.0 alpha:1.0];
    refresh.tintColor = [UIColor whiteColor];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Add a New Event" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Helvetica Neue" size:20]}];
    [refresh addTarget:self action:@selector(addNewEvent:) forControlEvents:UIControlEventValueChanged];
    [self.table addSubview:refresh];
}

-(void)gestureAction:(UILongPressGestureRecognizer *)press{
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        //self.view.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.view.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.view addSubview:blurEffectView];
        }];
    }
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
    [self.table reloadData];
    [self syncDataWithExtension];
    
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
    
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    press.minimumPressDuration = 1.0;
    [self.view addGestureRecognizer:press];
    
    areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved2"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!areAdsRemoved) {
        self.banner.adUnitID = @"ca-app-pub-7942613644553368/9252365932";
        self.banner.rootViewController = self;
        [self.banner loadRequest:[GADRequest request]];
    }else{
        self.banner.hidden = YES;
    }
    
    [self setUpView];
    
    NSLog(@"current project %@", _project);
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
