//
//  CustomCell.h
//  
//  (c) Yongyang Nie
//  Created by Yongyang Nie on 4/19/16.
//  All Rights Reserved
//

#import <UIKit/UIKit.h>
#import <MaterialControls/MaterialControls.h>
#import "UIFontHelper.h"
#import "Task.h"

@interface CustomCell : UITableViewCell <UITextFieldDelegate, MDTextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *pickerViewData;
@property (weak, nonatomic) IBOutlet UIPickerView *PickerView;
@property (weak, nonatomic) IBOutlet MDTextField *textField;
@property (weak, nonatomic) IBOutlet MDSwitch *Switch;
@property (weak, nonatomic) IBOutlet UILabel *SwitchLabel;
@property (nonatomic, assign) id delegate;

@end

@protocol CustomCellDelegates <NSObject>

-(void)textFieldBeginEditing;
-(void)textFieldEndEditing;
-(void)switchHasChanged:(BOOL)isOn atCell:(CustomCell *)cell;
-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell;
-(void)pickerViewValueSelected:(NSString *)string;

@end
