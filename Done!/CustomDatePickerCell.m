//
//  CustomDatePickerCell.m
//  Done!
//
//  Created by Yongyang Nie on 6/15/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "CustomDatePickerCell.h"

@implementation CustomDatePickerCell

@synthesize delegate;

- (IBAction)setDate:(id)sender {

    [delegate dateWasSelected:self.datePicker.date];
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
@end
