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

-(void)setUpCell{
    
    self.titleLabel.text = self.event.title;
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"dd/MM/yyyy HH:MM"];
    self.dateLabel.text = [formate stringFromDate:self.event.date];
    if (self.event.important == YES) {
        self.importantIcon.hidden = NO;
    }else{
        self.importantIcon.hidden = YES;
    }
}

- (void)awakeFromNib {

    self.importantIcon.backgroundColor = [UIColor orangeColor];
    [self cropImagetoRound:self.importantIcon];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


-(void)cropImagetoRound:(UIImageView *)image{
    
    CALayer *imageLayer = image.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:0];
    [imageLayer setMasksToBounds:YES];
    [image.layer setCornerRadius:image.frame.size.width/2];
    [image.layer setMasksToBounds:YES];
}

- (IBAction)done:(id)sender
{
    [_button setImage:[UIImage imageNamed:@"circle-f.png"] forState:UIControlStateNormal];
    if (delegate != nil) {
        [delegate clickedDone:self];
    }
}

@end
