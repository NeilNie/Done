//
//  addEventCell.h
//  Done!
//
//  Created by Yongyang Nie on 6/13/16.
//  Copyright © 2016 Yongyang Nie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaterialControls/MaterialControls.h>

@interface AddEventCell : UITableViewCell <MDTextFieldDelegate>

@property (weak, nonatomic) IBOutlet MDTextField *textfield;
@property (nonatomic, assign) id delegate;

@end

@protocol AddEventCellDelegate <NSObject>

-(void)textFieldBeginEditing;
-(void)textFieldEndEditing;
-(void)addNewEventFromCell:(AddEventCell *)cell;

@end

