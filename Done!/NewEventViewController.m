//
//  NewEventViewController.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "NewEventViewController.h"

@interface NewEventViewController ()

@end

@implementation NewEventViewController

- (IBAction)addEvent:(id)sender {
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    Events *NewEvent = [[Events alloc] init];
    NewEvent.title = title;
    NewEvent.subTitle = subTitle;
    NewEvent.location = location;
    NewEvent.date = date;
    [realm addObject:NewEvent];
    [realm commitWriteTransaction];
    
    if (reminder) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = date;
        notification.alertTitle = @"You have a new reminder";
        notification.alertBody = title;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.applicationIconBadgeNumber = [[UIApplication sharedApplication]applicationIconBadgeNumber] + 1;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CellDescriptor" ofType:@"plist"];
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
    NSLog(@"Visible Rows %@", visibleRowsPerSection);
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
            
            int indexOfParentCell;
            
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
        return 50;
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
        cell.textField.placeholder = currentDescriptor[@"primaryTitle"];
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellSwitch"]) {
        cell.SwitchLabel.text = currentDescriptor[@"primaryTitle"];
        
        NSString *value = currentDescriptor[@"value"];
        cell.Switch.on = ([value isEqualToString:@"true"]) ? YES : NO;
    }
    else if ([currentDescriptor[@"cellIdentifier"] isEqualToString:@"idCellValuePicker"]) {
        cell.textLabel.text = currentDescriptor[@"primaryTitle"];
    }
    cell.delegate = self;
    return cell;
}

#pragma mark - CustomCell Delegate

-(void)dateWasSelected:(NSDate *)selectedDate{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    formate.dateStyle = NSDateFormatterLongStyle;
    NSString *dateString = [formate stringFromDate:selectedDate];
    [[[cellDescriptors objectAtIndex:0] objectAtIndex:3] setValue:dateString forKey:@"primaryTitle"];
    [self.table reloadData];
    
    date = selectedDate;
}

-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell{
    
    NSIndexPath *parentCellIndex = [self.table indexPathForCell:parentCell];
    if (parentCellIndex.row == 1) {
        [[[cellDescriptors objectAtIndex:0] objectAtIndex:0] setValue:newText forKey:@"primaryTitle"];
        title = newText;
    }else{
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
    NSLog(@"CellDiscriptors %@", cellDescriptors);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
