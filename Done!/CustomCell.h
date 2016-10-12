//
//  CustomCell.h
//  
//  (c) Yongyang Nie
//  Created by Yongyang Nie on 4/19/16.
//  All Rights Reserved
//

#import <UIKit/UIKit.h>
#import "iOSUILib/MDTableViewCell.h"
#import "iOSUILib/MDTextField.h"
#import "iOSUILib/MDSwitch.h"
#import "UIFontHelper.h"
#import "Events.h"

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
