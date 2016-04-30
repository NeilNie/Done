//
//  CustomCell.h
//  
//
//  Created by Yongyang Nie on 4/19/16.
//
//

#import <UIKit/UIKit.h>


@interface CustomCell : UITableViewCell <UITextFieldDelegate>{

}

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *Switch;
@property (weak, nonatomic) IBOutlet UILabel *SwitchLabel;
@property (nonatomic, assign) id delegate;

@end

@protocol CustomCellDelegates <NSObject>

-(void)dateWasSelected:(NSDate *)selectedDate;
-(void)switchHasChanged:(BOOL)isOn;
-(void)textFieldChanged:(NSString *)newText withCell:(CustomCell *)parentCell;

@end