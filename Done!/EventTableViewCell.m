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

-(void)gestureAction:(UISwipeGestureRecognizer *)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self animateShowButton];
    }else if (swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        [self animateHideButton];
    }
}

- (IBAction)markImportant:(id)sender {
    
    [self animateHideButton];
    self.importantIcon.hidden = NO;
    [self circleAnimation];
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
-(void)circleAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        const CGFloat scale = 8;
        [self.importantIcon setTransform:CGAffineTransformMakeScale(scale, scale)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            const CGFloat scale = 1;
            [self.importantIcon setTransform:CGAffineTransformMakeScale(scale, scale)];
        }];
    }];
}

- (IBAction)done:(id)sender
{
    [_button setImage:[UIImage imageNamed:@"circle-f.png"] forState:UIControlStateNormal];
    if (delegate != nil) {
        [delegate clickedDone:self];
    }
}
@end
