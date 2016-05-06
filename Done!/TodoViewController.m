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
    
    cell.delegate = self;
    return cell;
    
}

#pragma EventCell Delegate

-(void)ClickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    Events *update = [EventsHelper findEventWithTitle:cell.titleLabel.text withRealm:self.project.events];
    update.completed = YES;
    [realm commitWriteTransaction];
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - CreateNew Delegate

-(void)addProject:(Projects *)project{}

-(void)addNewEventToProject:(Events *)event{
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [self.project.events addObject:event];
    [realm commitWriteTransaction];
    
    NSLog(@"added a new event %@ to project %@", event, self.project.title);
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    [self.table reloadData];
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

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    [shared setObject:[EventsHelper convertToArray:[Events allObjects]] forKey:@"RealmResult"];
    [shared synchronize];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    self.naviTitle.title = self.project.title;
    allEvents = [EventsHelper findNotCompletedEvents:self.project.events];
    
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
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
        vc.delegate = self;
        vc.sender = @"event";
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
