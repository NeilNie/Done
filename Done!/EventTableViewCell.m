//
//  EventTableViewCell.m
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)done:(id)sender {
    
    [_button setImage:[UIImage imageNamed:@"circle-f.png"] forState:UIControlStateNormal];
    if (delegate != nil) {
        [delegate ClickedDone:self];
    }
}
@end
