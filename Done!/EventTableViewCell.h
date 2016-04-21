//
//  EventTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 4/18/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, assign) id delegate;
- (IBAction)done:(id)sender;

@end

@protocol EventCellDelegate <NSObject>

-(void)ClickedDone:(EventTableViewCell *)cell;

@end