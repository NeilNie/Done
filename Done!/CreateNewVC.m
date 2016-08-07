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
    
    if ([self checkData] == NO) {
        [RKDropdownAlert title:@"Opps" message:@"You have to set a date and a title for your project/event."];
        
    }else{
        
        if (self.reminder == [NSNumber numberWithBool:YES]) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = date;
            notification.alertTitle = NSLocalizedString(@"You have a new reminder", nil);
            notification.alertBody = title;
            notification.soundName = UILocalNotificationDefaultSoundName;
            notification.timeZone = [NSTimeZone localTimeZone];
            notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        if (self.addedToProject != nil){
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            Events *event = [EventsHelper createEventWithDate:date title:title otherInfo:nil];
            [self.addedToProject.events addObject:event];
            [realm commitWriteTransaction];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [RKDropdownAlert title:@"Opps" message:@"You have to select a project that this event will be added to."];
        }
        [self syncWithWatch];
    }
    [self dismissViewControllerAnimated:YES
                             completion:nil];
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableArray *)getPickerViewData{
    
    RLMResults *result = [Projects allObjects];
    NSMutableArray *Rarray = [NSMutableArray array];
    
    for (int i = 0; i < result.count; i ++) {
        Projects *project = [result objectAtIndex:i];
        [Rarray addObject:project.title];
    }
    if (result.count == 0) {
        [Rarray addObject:@"No Project"];
    }
    return Rarray;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            return 55;
            break;
        case 1:
            return 250;
            break;
        case 2:
            return 55;
            break;
        case 3:
            return 55;
            break;
        case 4:
            return 110;
            break;
            
        default:
            return 60;
            break;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CustomCell *cell = [[CustomCell alloc] init];
    cell.delegate = self;
    
    if (indexPath.row == 0) {
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellTextfield" forIndexPath:indexPath];
        cell.textField.floatingLabel = YES;
        return cell;
        
    }else if (indexPath.row == 1){
        TimelineTableViewCell *cell = (TimelineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"idTimelineCell" forIndexPath:indexPath];
        return cell;
        
    }else if (indexPath.row == 2){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellSwitch" forIndexPath:indexPath];
        cell.SwitchLabel.text = NSLocalizedString(@"Reminder", nil);
        return cell;
        
    }else if (indexPath.row == 3){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idCellSwitch" forIndexPath:indexPath];
        cell.SwitchLabel.text = NSLocalizedString(@"Important", nil);
        return cell;
    }
    else if (indexPath.row == 4){
        cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"idValuePicker" forIndexPath:indexPath];
        cell.pickerViewData = [self getPickerViewData];
        return cell;
        
    }else{
        return cell;
    }
}

#pragma mark - CustomCell Delegate

-(void)dateWasSelected:(NSDate *)selectedDate{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:selectedDate];
    NSLog(@"%@", dateString);
    
    
    [self.table reloadData];
    
    date = selectedDate;
}

-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell{

    [self.table reloadData];
}

-(void)switchHasChanged:(BOOL)isOn{
    
//    NSString *bo = isOn? @"Yes" : @"No";
//    
//    self.reminder = [NSNumber numberWithBool:isOn];
}

-(void)pickerViewValueSelected:(NSString *)title{
    
}

#pragma mark - Life Cycle

-(void)viewDidAppear:(BOOL)animated{

    self.table.hidden = NO;
    [super viewDidAppear:YES];
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.table registerNib:[UINib nibWithNibName:@"TextfieldCell" bundle:nil] forCellReuseIdentifier:@"idCellTextfield"];
    [self.table registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:@"idCellDatePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"idCellSwitch"];
    [self.table registerNib:[UINib nibWithNibName:@"ValuePickerCell" bundle:nil] forCellReuseIdentifier:@"idValuePicker"];
    [self.table registerNib:[UINib nibWithNibName:@"TimelineTableViewCell" bundle:nil] forCellReuseIdentifier:@"idTimelineCell"];
    
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
