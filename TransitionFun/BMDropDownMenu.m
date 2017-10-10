//
//  BMDropDownMenu.m
//  TransitionFun
//
//  Created by AnjDenny on 28/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMDropDownMenu.h"

@implementation BMDropDownMenu


- (UIView*)datePickerDropDown:(UITextField*)textField{
    UIView *datePView = [[UIView alloc] initWithFrame:CGRectMake(textField.frame.origin.x, textField.frame.origin.y + textField.frame.size.height, textField.frame.size.width, 0)];
    datePView.layer.shadowColor = (__bridge CGColorRef)([UIColor darkGrayColor]);
    datePView.layer.shadowOffset = CGSizeMake(3, 3);
    datePView.layer.shadowRadius = 4;
    
    [UIView animateWithDuration:30.0
                          delay:0.0
                        options:UIViewAnimationCurveLinear | UIViewAnimationOptionRepeat | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         datePView.frame = CGRectMake(datePView.frame.origin.x, datePView.frame.origin.y, datePView.frame.size.width, 200);
                     }
                     completion:^(BOOL finished){
                         
                     }
     ];
    return datePView;
}

@end
