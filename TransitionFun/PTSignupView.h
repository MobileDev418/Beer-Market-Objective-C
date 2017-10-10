//
//  PTSignupView.h
//  TransitionFun
//
//  Created by AnjDenny on 19/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface PTSignupView : UIViewController
{
    IBOutlet UITextField *tfUserName;
    IBOutlet UITextField *tfFirstName;
    IBOutlet UITextField *tfLastName;
    IBOutlet UITextField *tfAddress;
    IBOutlet UITextField *tfEmail;
    IBOutlet UITextField *tfMobileNumber;
    IBOutlet UILabel     *lblBirthday;
    IBOutlet UITextField *tfPassword;
    IBOutlet UITextField *tfConfirmPassword;
    IBOutlet RadioButton *gender;
}

- (IBAction)onSignUp:(id)sender;

@end
