//
//  ProjectCollectionViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 4/27/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProjectCellDelegate <NSObject>

-(void)DownSwipeGestureTriggered;

@end

@interface ProjectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *color;
@property (weak, nonatomic) IBOutlet UIImageView *frontFolder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontFolderConstr;
@property (retain, nonatomic) id <ProjectCellDelegate> delegate;

@end
