//
//  addEventCell.h
//  Done!
//
//  Created by Yongyang Nie on 6/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSUILib/MDTextField.h"

@interface addEventCell : UITableViewCell <MDTextFieldDelegate>

@property (weak, nonatomic) IBOutlet MDTextField *textfield;
@property (nonatomic, assign) id delegate;

@end

@protocol addEventCellDelegate <NSObject>

-(void)textFieldBeginEditing;
-(void)addNewEventFromCell:(addEventCell *)cell;

@end

