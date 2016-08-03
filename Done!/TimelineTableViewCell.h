//
//  TimelineTableViewCell.h
//  Done!
//
//  Created by Yongyang Nie on 8/2/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Events.h"
#import "Projects.h"
#import "EventsHelper.h"
#import "EventManager.h"
#import "EventTableViewCell.h"

#import "MSCollectionViewCalendarLayout.h"
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

@interface TimelineTableViewCell : UITableViewCell <MSCollectionViewDelegateCalendarLayout>{
    NSArray *collectionViewArray;
}

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerWidth;
@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;
@property (nonatomic, retain) id delegate;

@end

@protocol TimelineTableViewCellDelegate <NSObject>

-(void)dateWasSelected:(NSDate *)selectedDate;

@end