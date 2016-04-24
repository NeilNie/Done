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
        Events *event = [result objectAtIndex:indexPath.row];
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        [realm deleteObject:event];
        [realm commitWriteTransaction];
        [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return result.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idEventCell" forIndexPath:indexPath];
    Events *event = [result objectAtIndex:indexPath.row];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateStyle = NSDateFormatterLongStyle;
    cell.titleLabel.text = event.title;
    cell.dateLabel.text = [formate stringFromDate:event.date];
    
    cell.delegate = self;
    return cell;
}

#pragma mark - Private
- (IBAction)addNewEvent:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *NewEventView = [storyboard instantiateViewControllerWithIdentifier:@"AddView"];
    [self presentViewController:NewEventView animated:YES completion:nil];
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

-(void)syncEventsWithExtensions{
    
    NSMutableArray *arry = [NSMutableArray array];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateStyle = NSDateFormatterLongStyle;
    
    for (int i = 1; i < result.count; i++) {
        
        Events *event = [result objectAtIndex:i];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setValue:event.title forKey:@"title"];
        [dictionary setValue:[formate stringFromDate:event.date] forKey:@"date"];
        
        [arry addObject:dictionary];
    }
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.done.com.yongyang"];
    [shared setObject:arry forKey:@"RealmResult"];
    [shared synchronize];
}

#pragma EventCell Delegate

-(void)ClickedDone:(EventTableViewCell *)cell{
    
    NSIndexPath *index = [self.table indexPathForCell:cell];
    Events *event = [result objectAtIndex:index.row];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:event];
    [realm commitWriteTransaction];
    
    [self.table deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)syncDataWithWatch:(id)data{
    NSLog(@"realms synced");
    [wormhole passMessageObject:data identifier:@"idWatchSync"];
}


#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [self.table reloadData];
    [self syncEventsWithExtensions];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    result = [Events allObjects];
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    [self setUpView];
    
    wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.done.com.watch" optionalDirectory:@"wormhole"];
    [wormhole listenForMessageWithIdentifier:@"idRequestUpdate" listener:^(id  _Nullable messageObject) {
        NSLog(@"update request received");
        [self syncDataWithWatch:result];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncDataWithWatch:) name:@"ndUpdateWatch" object:result];
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
