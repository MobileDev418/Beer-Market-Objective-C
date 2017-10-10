//
//  PTLoginSignup.m
//  TransitionFun
//
//  Created by AnjDenny on 19/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "PTLoginSignup.h"
#import "PTMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "METransitions.h"

@interface PTLoginSignup (){
    IBOutlet UIButton *loginbtn;
    IBOutlet UITextField *userName;
    IBOutlet UITextField *password;
    IBOutlet UIView *seperatorN;
    IBOutlet UIView *seperatorP;
    
    IBOutlet UIButton *forgotP;
    IBOutlet UIButton *signUp;
    
    IBOutlet UIScrollView *scrollView;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation PTLoginSignup

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
    
    loginbtn.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:12.0f/255.0f blue:7.0f/255.0f alpha:1];
    loginbtn.layer.cornerRadius = 2;
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    userName.textColor = [UIColor colorWithRed:114.0/255.0 green:100.0/255.0 blue:52.0/255.0 alpha:1];
    password.textColor = [UIColor colorWithRed:114.0/255.0 green:100.0/255.0 blue:52.0/255.0 alpha:1];
    
    [forgotP setTitleColor:[UIColor colorWithRed:114.0/255.0 green:100.0/255.0 blue:52.0/255.0 alpha:1] forState:UIControlStateNormal];
    [signUp setTitleColor:[UIColor colorWithRed:114.0/255.0 green:100.0/255.0 blue:52.0/255.0 alpha:1] forState:UIControlStateNormal];
    
     seperatorP.backgroundColor = [UIColor colorWithRed:148.0f/255.0f green:132.0f/255.0f blue:67.0f/255.0f alpha:1];
    
    seperatorN.backgroundColor = [UIColor colorWithRed:148.0f/255.0f green:132.0f/255.0f blue:67.0f/255.0f alpha:1];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    }
    else
    {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
        
        scrollView.contentSize = CGSizeMake(self.view.frame.size.width, signUp.frame.origin.y + 40);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
    
    //*---- auto login ------
    if([[BMUser sharedUser] isRememberUser])
    {
        NSUserDefaults *bmDefault = [NSUserDefaults standardUserDefaults];
        NSString *user_name = [bmDefault valueForKey:USER_NAME];
        NSString *user_password = [bmDefault valueForKey:USER_PASSWORD];
        
        userName.text = user_name;
        password.text = user_password;
        
        BMUser *user = [BMUser sharedUser];
        user.userName = user_name;
        user.password = user_password;
        
        [self userLogin:user];
    }
    // */
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]])
    {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture)
        {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    }
    else
    {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
     self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BMServer
- (void) userLogin:(BMUser *)user
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Sign In.."];
    
    [[BMServer sharedInstance] signinUser:user success:^(NSDictionary *response){
        
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"--------- 사용자 로그인 응답 ----------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            [BMUtility sharedUtility].isUserLogin = YES;
            [[PTMenuViewController sharedMenu] updateMenu];
            
            [[BMUser sharedUser] updateUser:response success:^(bool isSuccess){
                
            }];
            [[BMUser sharedUser] rememberUser];
            
            self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeID"];
        }
        
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
        [[BMUtility sharedUtility] showAlert:@"SignIn" message:operation.error.description];
    }
     ];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBActions
- (IBAction)btnLoginClick:(id)sender
{
    BMUser *user = [BMUser sharedUser];
    user.userName = userName.text;
    user.password = password.text;
    
    [self userLogin:user];
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
