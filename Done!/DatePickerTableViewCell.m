//
//  TimelineTableViewCell.m
//  Done!
//
//  Created by Yongyang Nie on 8/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "DatePickerTableViewCell.h"

@implementation DatePickerTableViewCell

@synthesize delegate;

#pragma mark - MSEventCell Delegate

-(void)collectionViewCell:(UICollectionViewCell *)collectionViewCell didSelectEvent:(Events *)event{

    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:event.date];
    self.timeLabel.text = dateString;
    [delegate dateWasSelected:event.date];
    self.datePicker.date = event.date;

    [UIView animateWithDuration:0.5 animations:^{
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
    NSArray *calendarEvents = [manager getTodayLocalEvent];

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
    [events addObjectsFromArray:[self convertPeriodsToEvents:[[[EventManager alloc] init] findFreePeriodsToday]]];
    return events;
}

-(NSMutableArray <Events *> *)convertPeriodsToEvents:(NSArray *)periods{
    NSMutableArray *returnArray = [NSMutableArray array];

    for (int i = 0; i < periods.count; i++) {
        TimePeriod *period = [periods objectAtIndex:i];
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

#pragma mark - Life Cycle

- (void)awakeFromNib {

    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateString = [formate stringFromDate:[NSDate date]];
    self.timeLabel.text = dateString;
    collectionViewArray = [self setUpEventArray];

    self.setButton.hidden = YES;

    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

