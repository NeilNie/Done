//
//  CustomCell.m
//  
//
//  Created by Yongyang Nie on 4/19/16.
//
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize delegate;

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self.delegate pickerViewValueSelected:row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 25.0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.pickerViewData.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [self.pickerViewData objectAtIndex:row];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(IBAction)switchHasChanged:(BOOL)isOn{
    
    if (delegate != nil) {
        [delegate switchHasChanged:!_Switch.isOn];
    }
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (delegate != nil) {
        [delegate textFieldChanged:textField.text withCell:self];
        NSLog(@"Textfield return called");
    }
    return YES;
}

- (void)awakeFromNib {

    _textField.delegate = self;
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
