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

-(IBAction)selectedDate:(id)sender{
    
    if (delegate != nil) {
        [delegate dateWasSelected:self.datePicker.date];
        NSLog(@"method called %@", self.datePicker.date);
    }
}

-(void)dateWasSelected:(NSString *)selectedDateString{
    
}
-(void)switchHasChanged:(BOOL)isOn{
    if (delegate != nil) {
        [delegate switchHasChanged:_Switch.on];
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
