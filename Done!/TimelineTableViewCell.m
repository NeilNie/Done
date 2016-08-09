//
//  TimelineTableViewCell.m
//  Done!
//
//  Created by Yongyang Nie on 8/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "TimelineTableViewCell.h"

@implementation TimelineTableViewCell

@synthesize delegate;

NSString * const MSCSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSCSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSCSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return collectionViewArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSCSEventCellReuseIdentifier forIndexPath:indexPath];
    Events *currentEvent = [collectionViewArray objectAtIndex:indexPath.row];
    if (![currentEvent.title isEqualToString:@"Free time"]) {
        [cell setEventColor:[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.65]];
    }else{
        [cell setEventColor:[UIColor colorWithRed:91.0/255.0 green:175.0/255.0 blue:236.0/255.0 alpha:0.2]];
    }
    cell.event = [collectionViewArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSCSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        dayColumnHeader.hidden = YES;
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSCSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    return [NSDate date];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *time = [collectionViewArray objectAtIndex:indexPath.row];
    return time.date;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Events *time = [collectionViewArray objectAtIndex:indexPath.row];
    if (time.endDate) {
        return time.endDate;
    }else{
        return [time.date dateByAddingTimeInterval:60*30];
    }
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout{
    return [NSDate date];
}

-(void)setUpCollectionView{
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSCSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSCSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSCSTimeRowHeaderReuseIdentifier];

    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    [self.collectionView setCollectionViewLayout:self.collectionViewCalendarLayout];
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionView reloadData];
}

#pragma mark - MSEventCell Delegate

-(void)collectionViewCell:(UICollectionViewCell *)collectionViewCell didSelectEvent:(Events *)event{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:event.date];
    self.timeLabel.text = dateString;
    [delegate dateWasSelected:event.date];
    self.datePicker.date = event.date;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.pickerWidth.constant = self.frame.size.width;
        [self layoutIfNeeded];
        [self layoutSubviews];
    }];
    self.setButton.hidden = NO;
}

#pragma mark - Private

-(IBAction)setDate:(id)sender{
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:self.datePicker.date];
    self.timeLabel.text = dateString;
    [delegate dateWasSelected:self.datePicker.date];
}

-(NSArray<Events *> *)setUpEventArray{
    
    EventManager *manager = [[EventManager alloc] init];
    NSArray *calendarEvents = [manager getTodayEventCalendars];
    
    NSMutableArray *events = [NSMutableArray array];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd"];
    
    for (int i = 0; i < calendarEvents.count; i++) {
        Events *event = [[Events alloc] init];
        EKEvent *calendar = [calendarEvents objectAtIndex:i];
        if ([[formate stringFromDate:calendar.startDate] isEqualToString:[formate stringFromDate:calendar.endDate]]) {
            event.title = calendar.title;
            event.date = calendar.startDate;
            event.endDate = calendar.endDate;
            [events addObject:event];
        }
    }
    
    [events addObjectsFromArray:[EventsHelper findTodayNotCompletedEvents:[Events allObjects]]];
    [events addObjectsFromArray:[self convertPeriodsToEvents:[[[EventManager alloc] init] freeTimesToday]]];
    return events;
}

-(NSMutableArray <Events *> *)convertPeriodsToEvents:(NSArray *)periods{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (int i = 0; i < periods.count; i++) {
        NYTimePeriod *period = [periods objectAtIndex:i];
        Events *event = [[Events alloc] init];
        event.date = period.startDate;
        event.endDate = period.endDate;
        event.title = NSLocalizedString(@"Free time", nil);
        [returnArray addObject:event];
    }
    return returnArray;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *datePickerSubviews = [self.datePicker subviews];
        
        for (UIView *subview in datePickerSubviews) {
            [subview sizeToFit];
        }
    });
}

-(void)gestureRecognizersAction:(UISwipeGestureRecognizer *)gesture{
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerWidth.constant = self.frame.size.width;
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.pickerWidth.constant = 0;
        }];
    }
}

#pragma mark - Life Cycle

- (void)awakeFromNib {
    
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:[NSDate date]];
    self.timeLabel.text = dateString;
    collectionViewArray = [self setUpEventArray];
    [self setUpCollectionView];
    self.setButton.hidden = YES;
    
    UISwipeGestureRecognizer *RightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizersAction:)];
    RightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *LeftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizersAction:)];
    LeftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.collectionView addGestureRecognizer:LeftSwipe];
    [self.collectionView addGestureRecognizer:RightSwipe];
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:YES];
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
