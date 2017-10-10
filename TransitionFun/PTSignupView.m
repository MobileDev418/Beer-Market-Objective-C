//
//  PTSignupView.m
//  TransitionFun
//
//  Created by AnjDenny on 19/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "PTSignupView.h"

@interface PTSignupView (){
    
    
    UIDatePicker *dtPicker;
    UIToolbar *pickerToolbar;
    
    IBOutlet UIButton *signup;
}

@property (nonatomic, strong) IBOutlet RadioButton* maleButton;

@end

@implementation PTSignupView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"LOG In" style:UIBarButtonItemStyleBordered target:self action:@selector(yourSelector)];
    
    [self.navigationController.navigationItem setBackBarButtonItem:barButtonItem];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]]];
    
    signup.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:12.0f/255.0f blue:7.0f/255.0f alpha:1];
    
    lblBirthday.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectDOB:)];
    [lblBirthday addGestureRecognizer:tapGesture];
    
    //Datepicker
    dtPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300 +20, self.view.frame.size.width, 300)];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    // if (dateStatus==0) {
    dtPicker.datePickerMode = UIDatePickerModeDate;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dtPicker.maximumDate = [NSDate date];
    dtPicker.backgroundColor = [UIColor lightTextColor];
    
    dtPicker.hidden = YES;
    dtPicker.date = [NSDate date];
    
    [dtPicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 330 + 20, self.view.frame.size.width, 30)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    pickerToolbar.hidden = YES;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(btncancelPressed:)];
    [barItems addObject:btnCancel];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    lblBirthday.text=[NSString stringWithFormat:@"%@",[format stringFromDate:dtPicker.date]];
    
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [self.view addSubview:pickerToolbar];
    [self.view addSubview:dtPicker];
    
}

- (void)btncancelPressed:(id)sender
{
    lblBirthday.text= @"";
    dtPicker.hidden = YES;
    pickerToolbar.hidden = YES;
}
- (void)doneButtonPressed:(id)sender
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    lblBirthday.text=[NSString stringWithFormat:@"%@",[format stringFromDate:dtPicker.date]];
    dtPicker.hidden = YES;
    pickerToolbar.hidden = YES;
}

-(void)LabelChange:(id)sender
{
    
    NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    lblBirthday.text=[NSString stringWithFormat:@"%@",[format stringFromDate:dtPicker.date]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    if(sender.selected)
    {
        NSLog(@"Selected color: %@", sender.titleLabel.text);
    }
}

- (void)selectDOB:(id)sender
{
    dtPicker.hidden = NO;
    pickerToolbar.hidden = NO;
}

- (IBAction)onSignUp:(id)sender
{
    if([tfUserName.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter user name"];
    }
    if([tfFirstName.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter first name"];
    }
    if([tfLastName.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter last name"];
    }
    if([tfAddress.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter address"];
    }
    if([tfEmail.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter email"];
    }
    if([tfMobileNumber.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter mobile number"];
    }
    if([lblBirthday.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter birthday"];
    }
    if([tfPassword.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please enter password"];
    }
    if([tfConfirmPassword.text isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Please confirm password"];
    }
    if(![tfPassword.text isEqualToString:tfConfirmPassword.text])
    {
        [[BMUtility sharedUtility] showAlert:@"SignUp" message:@"Confirm password is not match with password"];
    }
    
    BMUser *user = [BMUser sharedUser];
    user.userName = tfUserName.text;
    user.firstName = tfFirstName.text;
    user.lastName = tfLastName.text;
    user.address = tfAddress.text;
    user.email = tfEmail.text;
    user.mobileNumber = tfMobileNumber.text;
    user.birthday = lblBirthday.text;
    user.gender = (gender.selected) ? kMale : kFemale;
    user.password = tfPassword.text;
    
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Sign Up"];
    [[BMServer sharedInstance] signupUser:user success:^(NSDictionary *response)
     {
         NSLog(@"----------사용자 등록 응답----------\n%@", response);
         if([response[@"status"] isEqualToString:@"success"])
         {
             [[BMUtility sharedUtility] hideMBProgress];
             user.user_id = response[@"user_id"];
             [user saveUser];
             [user rememberUser];
             [self.navigationController popToRootViewControllerAnimated:YES];
         }
     }failure:^(AFHTTPRequestOperation *operation)
     {
         [[BMUtility sharedUtility] hideMBProgress];
         [[BMUtility sharedUtility] showAlert:@"SignUp" message:operation.error.description];
     }
     ];
}

@end
