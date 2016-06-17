//
//  addEventCell.m
//  Done!
//
//  Created by Yongyang Nie on 6/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "addEventCell.h"

@implementation addEventCell

@synthesize delegate;

-(BOOL)textFieldShouldReturn:(MDTextField *)textField
{
    NSLog(@"textfield returned");
    if (delegate != nil) {
        [delegate addNewEventFromCell:self];
    }
    return NO;
}

- (void)awakeFromNib {

    _textfield.delegate = self;
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
