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
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self addGestureRecognizer:gesture];
    //[self.markButton addGestureRecognizer:gesture];
    self.importantIcon.backgroundColor = [UIColor orangeColor];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self animateShowButton];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [self animateHideButton];
    }
}

- (IBAction)markImportant:(id)sender {

    self.importantIcon.hidden = NO;
    [self.starButton setImage:[UIImage imageNamed:@"star_full.png"] forState:UIControlStateNormal];
    if (delegate != nil) {
        [delegate markImportant:self];
    }
}

-(void)animateShowButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.constr.constant = 170;
        self.importantIcon.hidden = YES;
        [self layoutIfNeeded];
    }];
}
-(void)animateHideButton
{
    [UIView animateWithDuration:0.3 animations:^{
        self.constr.constant = 0;
        [self layoutIfNeeded];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self animateHideButton];
}

- (IBAction)done:(id)sender
{
    [_button setImage:[UIImage imageNamed:@"circle-f.png"] forState:UIControlStateNormal];
    if (delegate != nil) {
        [delegate clickedDone:self];
    }
}
- (IBAction)moveEventToProject:(id)sender {
    if (delegate != nil) {
        [delegate moveEvent:self];
    }

}
- (IBAction)EventScheduleReminder:(id)sender {
    if (delegate != nil) {
        [delegate setReminder:self];
    }

}
- (IBAction)addAttachments:(id)sender {
    if (delegate != nil) {
        [delegate attachments:self];
    }

}

@end
