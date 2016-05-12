//
//  EventTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSUILib/MDTableViewCell.h"

@interface EventTableViewCell : MDTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constr;
@property (weak, nonatomic) IBOutlet UIButton *markButton;
@property (weak, nonatomic) IBOutlet UIImageView *importantIcon;
@property (nonatomic, assign) id delegate;
- (IBAction)done:(id)sender;

@end

@protocol EventCellDelegate <NSObject>

-(void)clickedDone:(EventTableViewCell *)cell;
-(void)markImportant:(EventTableViewCell *)cell;

@end