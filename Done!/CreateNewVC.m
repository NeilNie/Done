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
    
    [self scheduleReminder:reminder];
    
    if ([self checkData] == NO) {
        [RKDropdownAlert title:@"Opps" message:@"You have to set a date and a title for your project/event."];
    
    }else{
        if ([self.sender isEqualToString:@"project"]){
            Projects *p = [EventsHelper createProjectWithDate:date title:title];
            [self addProjectToFirebase:p];
            [delegate addProject:p];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            if (self.addedToProject == nil) {
                [RKDropdownAlert title:@"Opps" message:@"You have to select a project that this event will be added to."];
            }else{
                RLMRealm *realm = [RLMRealm defaultRealm];
                [realm beginWriteTransaction];
                Events *event = [EventsHelper createEventWithDate:date title:title otherInfo:nil];
                [self.addedToProject.events addObject:event];
                [FBHelper addEventToFirebase:event addedToProject:self.addedToProject];
                [realm commitWriteTransaction];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        [self syncWithWatch];
    }
}

-(void)addEventToFirebase:(Events *)event{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *eventID = [self uuid];
    [[[_ref child:@"events"] child:eventID] setValue:@{@"event_title": event.title,
                                                       @"event_date": [[self dateFormatter] stringFromDate:event.date],
                                                       @"owner": user.displayName
                                                       }];
    [[[[_ref child:@"projects"] child:user.displayName] child:self.addedToProject.title] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        __block NSMutableArray *UpdateArray;
        if ([snapshot.value objectForKey:@"events"] == nil) {
            UpdateArray = [NSMutableArray array];
        }else{
            UpdateArray = [snapshot.value objectForKey:@"events"];
        }
        [UpdateArray addObject:eventID];
        NSDictionary *updateDic = @{[NSString stringWithFormat:@"projects/%@/%@/events", user.displayName, self.addedToProject.title]:UpdateArray};
        [_ref updateChildValues:updateDic];
    }];
}

-(void)addProjectToFirebase:(Projects *)project{
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSLog(@"username %@", user.displayName);
    NSString *projectID = [self uuid];
    [[[[_ref child:@"projects"] child:user.displayName] child:project.title] setValue:@{@"project_title": project.title,
                                                                                        @"project_id":projectID,
                                                                                        @"project_date": [[self dateFormatter] stringFromDate:project.date],
                                                                                        @"events":[NSMutableArray array]}];
}

- (NSString *)uuid
{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd/MM/yyyy HH:MM";
    }
    
    return dateFormatter;
}

-(void)syncWithWatch{
    
    NSLog(@"sent request");
    WCSession *session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    [session updateApplicationContext:@{@"needSync": @"YES"} error:nil];
    NSLog(@"updated context");
}

-(BOOL)checkData{
    
    if (title != nil && date != nil) {
        return YES;
    }else{
        return NO;
    }
}

-(void)scheduleReminder:(BOOL)yes{
    if (yes) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = date;
        notification.alertTitle = @"You have a new reminder";
        notification.alertBody = title;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([self.sender isEqualToString:@"project"]){
        path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor2" ofType:@"plist"];
    }else{
        path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"];
    }
    
    cellDescriptors = [NSMutableArray arrayWithContentsOfFile:path];
    
    if (![self.sender isEqualToString:@"project"]) {
        NSMutableArray *array2 = [cellDescriptors objectAtIndex:0];
        RLMResults *result = [Projects allObjects];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:[NSNumber numberWithInteger:result.count] forKey:@"additionalRows"];
        [dict setObject:@"idCellNormal" forKey:@"cellIdentifier"];
        [dict setObject:@1 forKey:@"isExpandable"];
        [dict setObject:@0 forKey:@"isExpanded"];
        [dict setObject:@1 forKey:@"isVisible"];
        if (self.addedToProject) {
            [dict setObject:self.addedToProject.title forKey:@"primaryTitle"];
        }else{
            [dict setObject:@"" forKey:@"primaryTitle"];
        }
        
        [dict setObject:@"Add this this project" forKey:@"secondaryTitle"];
        [dict setObject:@"" forKey:@"value"];
        
        [array2 addObject:dict];
        for (int i = 0; i < result.count; i++) {
            Projects *cPro = [result objectAtIndex:i];
            
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@0 forKey:@"additionalRows"];
            [dic setObject:@"idCellValuePicker" forKey:@"cellIdentifier"];
            [dic setObject:@0 forKey:@"isExpandable"];
            [dic setObject:@0 forKey:@"isExpanded"];
            [dic setObject:@0 forKey:@"isVisible"];
            [dic setObject:cPro.title forKey:@"primaryTitle"];
            [dic setObject:@"" forKey:@"secondaryTitle"];
            [dic setObject:@"" forKey:@"value"];
            
            [array2 addObject:dic];
        }
        [cellDescriptors removeAllObjects];
        [cellDescriptors addObject:array2];
    }
    
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
            int indexOfParentCell;
            
            for (int i = indexOfTappedRow.intValue - 1; i >= 0; i --) {
                NSNumber *x = [[[cellDescriptors objectAtIndex:0] objectAtIndex:i] objectForKey:@"isExpandable"];
                if (x.intValue == 1) {
                    indexOfParentCell = i;
                    break;
                }
            }
            CustomCell *cell = (CustomCell *)[self tableView:self.table cellForRowAtIndexPath:indexPath];
            [cellDescriptors[indexPath.section][indexOfParentCell] setValue:cell.valuePickerText.text forKey:@"primaryTitle"];
            [cellDescriptors[indexPath.section][indexOfParentCell] setValue:@0 forKey:@"isExpanded"];
            
            if (self.addedToProject == nil) {
                self.addedToProject = [EventsHelper findProjectWithName:cell.valuePickerText.text];
            }
            for (int i = 0; i > indexOfParentCell + 1 && i < [[[[cellDescriptors objectAtIndex:indexPath.section] objectAtIndex:indexOfParentCell] objectForKey:@"additionalRows"] intValue]; i++) {
                [cellDescriptors[indexPath.section][i] setValue:@0 forKey:@"isVisible"];
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
        //cell.textField.floatingLabel = currentDescriptor[@"primaryTitle"];
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellSwitch"]) {
        cell.SwitchLabel.text = currentDescriptor[@"primaryTitle"];
        
        NSString *value = currentDescriptor[@"value"];
        cell.Switch.on = ([value isEqualToString:@"true"]) ? YES : NO;
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellValuePicker"]) {
        cell.valuePickerText.text = currentDescriptor[@"primaryTitle"];
    }
    cell.rippleColor = [UIColor colorWithRed:10.0f/255.0f green:96.0f/255.0f blue:254.0f/255.0f alpha:1.0f];
    cell.delegate = self;
    return cell;
}

#pragma mark - CustomCell Delegate

-(void)dateWasSelected:(NSDate *)selectedDate{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy HH:MM"];
    NSString *dateString = [formate stringFromDate:selectedDate];
    
    if ([self.sender isEqualToString:@"project"]) {
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:2] setValue:dateString forKey:@"primaryTitle"];
    }else{
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:3] setValue:dateString forKey:@"primaryTitle"];
    }
    
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
    //self.ref = [[FIRDatabase database] reference];
    FBHelper = [[FirebaseHelper alloc] init];
    [self setUpView];
    [self loadCellDiscriptors];
    self.table.hidden = NO;
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
