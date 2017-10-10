//
//  PTForgotPassword.m
//  TransitionFun
//
//  Created by AnjDenny on 20/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "PTForgotPassword.h"

@interface PTForgotPassword (){
    IBOutlet UIButton *submitBtn;
}

@end

@implementation PTForgotPassword

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]]];
    
    submitBtn.backgroundColor = [UIColor colorWithRed:16.0f/255.0f green:14.0f/255.0f blue:8.0f/255.0f alpha:1];
    submitBtn.layer.cornerRadius = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitBtnClick:(id)sender{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
