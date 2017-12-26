//
//  TimelineTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 8/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "List.h"
#import "EventsHelper.h"
#import "EventManager.h"
#import "EventTableViewCell.h"
#import "MDTabBar.h"

@interface DatePickerTableViewCell : UITableViewCell{
    NSArray *collectionViewArray;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *setButton;

@property (nonatomic, retain) id delegate;

@end

@protocol DatePickerTableViewCell <NSObject>

-(void)dateWasSelected:(NSDate *)selectedDate;

@end

