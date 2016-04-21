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
    ;
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

#pragma EventCell Delegate

-(void)ClickedDone:(EventTableViewCell *)cell{
    
    NSLog(@"clicked done");
    NSIndexPath *index = [self.table indexPathForCell:cell];
    Events *event = [result objectAtIndex:index.row];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:event];
    [realm commitWriteTransaction];
    
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    [self.table reloadData];
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {
    
    result = [Events allObjects];
    [self.table registerNib:[UINib nibWithNibName:@"EventTableViewCell" bundle:nil] forCellReuseIdentifier:@"idEventCell"];
    [self setUpView];
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
