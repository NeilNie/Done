//
//  CustomDatePickerCell.h
//  Done!
//
//  Created by Yongyang Nie on 6/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CustomCell.h"

@interface CustomDatePickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) id delegate;

@end

@protocol CustomDatePickerCellDelegate <NSObject>

-(void)dateWasSelected:(NSDate *)selectedDate;

@end
