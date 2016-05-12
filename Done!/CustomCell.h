//
//  CustomCell.h
//  
//
//  Created by Yongyang Nie on 4/19/16.
//
//

#import <UIKit/UIKit.h>
#import "iOSUILib/MDTableViewCell.h"
#import "iOSUILib/MDTextField.h"
#import "iOSUILib/MDButton.h"
#import "iOSUILib/MDSwitch.h"
#import "UIFontHelper.h"

@interface CustomCell : MDTableViewCell <UITextFieldDelegate, MDTextFieldDelegate>{

}

@property (weak, nonatomic) IBOutlet MDTextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet MDSwitch *Switch;
@property (weak, nonatomic) IBOutlet UILabel *SwitchLabel;
@property (weak, nonatomic) IBOutlet MDButton *button;
@property (nonatomic, assign) id delegate;

@end

@protocol CustomCellDelegates <NSObject>

-(void)dateWasSelected:(NSDate *)selectedDate;
-(void)switchHasChanged:(BOOL)isOn;
-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell;

@end