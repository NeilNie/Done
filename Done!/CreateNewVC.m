//
//  NewEventViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CreateNewVC.h"

@interface CreateNewVC ()

@end

@implementation CreateNewVC

@synthesize delegate;

- (IBAction)addEvent:(id)sender {
    
    if (reminder) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = date;
        notification.alertTitle = @"You have a new reminder";
        notification.alertBody = title;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

    if ([self.sender isEqualToString:@"event"]) {
        self.addedEvent = [[Events alloc] init];
        self.addedEvent.title = title;
        self.addedEvent.date = date;
        self.addedEvent.completed = NO;
        [delegate addNewEventToProject:self.addedEvent];
        NSLog(@"delegate method called");
        
    }else if ([self.sender isEqualToString:@"project"]){
        
        self.addedProject = [[Projects alloc] init];
        self.addedProject.title = title;
        self.addedProject.date = date;
        
        [delegate addProject:self.addedProject];
        NSLog(@"delegate method called");
    }
    
    if(WCSession.isSupported){
        NSLog(@"sent request");
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
        NSLog(@"updated context");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpView{
    
    self.table.delegate = self;
    self.table.dataSource = self;
    
    [self.table registerNib:[UINib nibWithNibName:@"NormalCell" bundle:nil] forCellReuseIdentifier:@"idCellNormal"];
    [self.table registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"idCellTextfield"];
    [self.table registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:@"idCellDatePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"ValuePickerCell" bundle:nil] forCellReuseIdentifier:@"idCellValuePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"idCellSwitch"];
    
}

-(void)loadCellDiscriptors{
    
    NSString *path;
    if ([self.sender isEqualToString:@"event"]) {
        path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"];
    }else if ([self.sender isEqualToString:@"project"]){
        path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor2" ofType:@"plist"];
    }
    
    cellDescriptors = [NSMutableArray arrayWithContentsOfFile:path];
    [self getIndicesOfVisible];
    [self.table reloadData];
}

-(void)getIndicesOfVisible{
    
    [visibleRowsPerSection removeAllObjects];
    
    for (NSMutableArray *currentCells in cellDescriptors) {
        
        NSMutableArray *visibleRows = [NSMutableArray array];
    
        for (int rows = 0; rows < currentCells.count; rows++) {
            
            if ([[[currentCells objectAtIndex:rows] objectForKey:@"isVisible"] intValue] == 1) {
                [visibleRows addObject:[NSNumber numberWithInt:rows]];
            }
        }
        [visibleRowsPerSection addObject:visibleRows];
    }
}

-(NSDictionary *)getCellDescriptorForIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *indexOfVisibleRow = [[visibleRowsPerSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    NSDictionary *cellDescriptor = [[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfVisibleRow.integerValue];
    return cellDescriptor;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSNumber *indexOfTappedRow = [[visibleRowsPerSection objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    NSNumber *number = [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfTappedRow.integerValue] objectForKey:@"isExpandable"];
    if (number.intValue == 1) {
        
        BOOL shouldExpandAndShowSubRows = NO;
        NSLog(@"shouldExpandAndShowSubRows %@", [NSNumber numberWithBool:shouldExpandAndShowSubRows]);
        NSNumber *Int = [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfTappedRow.integerValue] objectForKey:@"isExpanded"];
        if (Int.intValue == 0) {

            NSLog(@"should expand = yes");
            // In this case the cell should expand.
            shouldExpandAndShowSubRows = YES;
        }
        [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfTappedRow.integerValue] setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isExpanded"];
        
        NSNumber *x = [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfTappedRow.integerValue] objectForKey:@"additionalRows"];
        NSLog(@"X value %@ i value %i", x, indexOfTappedRow.intValue + 1);
        for (int i = indexOfTappedRow.intValue + 1; i <= x.intValue + indexOfTappedRow.intValue; i ++) {
            [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:i] setValue:[NSNumber numberWithBool:shouldExpandAndShowSubRows] forKey:@"isVisible"];
            NSLog(@"set visiblity");
        }
        
    }
    else {
        NSString *string = [[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfTappedRow.integerValue] objectForKey:@"cellIdentifier"];
        if ([string isEqualToString:@"idCellValuePicker"]) {
            
            int indexOfParentCell = 0;
            
            for (int i = indexOfTappedRow.intValue - 1; i >= 0; i -= 1) {
                if ((bool)cellDescriptors[indexPath.section][i][@"isExpandable"] == true) {
                    indexOfParentCell = i;
                    break;
                }
            }
            CustomCell *cell = (CustomCell *)[self tableView:self.table cellForRowAtIndexPath:indexPath];
            [cellDescriptors[indexPath.section][indexOfParentCell] setValue:cell.textLabel.text forKey:@"primaryTitle"];
            [cellDescriptors[indexPath.section][indexOfParentCell] setValue:[NSNumber numberWithBool:NO] forKey:@"isExpanded"];
            

            for (int i = 0; i > indexOfParentCell + 1 && i < indexOfParentCell + (int)cellDescriptors[indexPath.section][indexOfParentCell][@"additionalRows"]; i++) {
                [cellDescriptors[indexPath.section][i] setValue:[NSNumber numberWithBool:NO] forKey:@"isVisible"];
            }
        }
    }
    
    [self getIndicesOfVisible];
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *A = [NSArray arrayWithArray:[visibleRowsPerSection objectAtIndex:section]];
    return A.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return cellDescriptors.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *currentDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellNormal"]) {
        return 60;
    }else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellDatePicker"]){
        return 270;
    }else{
        return 53;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *currentDescriptor = [self getCellDescriptorForIndexPath:indexPath];
    
    //[self setUpView];
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:currentDescriptor[@"cellIdentifier"] forIndexPath:indexPath];
    
    if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellNormal"]) {
        
        if (currentDescriptor[@"primaryTitle"]) {
            cell.textLabel.text = currentDescriptor[@"primaryTitle"];
        }
        if (currentDescriptor[@"secondaryTitle"]) {
            cell.detailTextLabel.text = currentDescriptor[@"secondaryTitle"];
        }
        
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellTextfield"]) {
        self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.textField.hint = currentDescriptor[@"primaryTitle"];
        cell.textField.floatingLabel = currentDescriptor[@"primaryTitle"];
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellSwitch"]) {
        cell.SwitchLabel.text = currentDescriptor[@"primaryTitle"];
        
        NSString *value = currentDescriptor[@"value"];
        cell.Switch.on = ([value isEqualToString:@"true"]) ? YES : NO;
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellValuePicker"]) {
        cell.textLabel.text = currentDescriptor[@"primaryTitle"];
    }
    cell.rippleColor = [UIColor colorWithRed:10.0f/255.0f green:96.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
    cell.delegate = self;
    return cell;
}

#pragma mark - CustomCell Delegate

-(void)dateWasSelected:(NSDate *)selectedDate{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formate stringFromDate:selectedDate];
    
    if ([self.sender isEqualToString:@"event"]) {
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:3] setValue:dateString forKey:@"primaryTitle"];
    }else if ([self.sender isEqualToString:@"project"]){
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:2] setValue:dateString forKey:@"primaryTitle"];    }
    
    [self.table reloadData];
    
    date = selectedDate;
}

-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell{
    
    NSIndexPath *parentCellIndex = [self.table indexPathForCell:parentCell];
    if (parentCellIndex.row == 1) {
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:0] setValue:newText forKey:@"primaryTitle"];
        title = newText;
    }
    else if ([self.sender isEqualToString:@"project"] && parentCellIndex.row == 5){
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:4] setValue:newText forKey:@"primaryTitle"];
        title = newText;
    }
    else{
        subTitle = newText;
    }
    [self.table reloadData];
    NSLog(@"new text %@", newText);
}

-(void)switchHasChanged:(BOOL)isOn{
    
    NSString *bo = isOn? @"Yes" : @"No";
    [[[cellDescriptors objectAtIndex:0] objectAtIndex:6] setValue:bo forKey:@"primaryTitle"];
    reminder = isOn;
    NSLog(@"%i", isOn);
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{
    
    visibleRowsPerSection = [NSMutableArray array];
    [self setUpView];
    [self loadCellDiscriptors];
    self.table.hidden = NO;
    NSLog(@"delegate %@", self.delegate);
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {

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
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
