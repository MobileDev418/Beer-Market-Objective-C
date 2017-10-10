//
//  TradingDetail.m
//  TransitionFun
//
//  Created by AnjDenny on 24/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "TradingDetail.h"
#define TAG_QUANTITY        100

@interface TradingDetail ()

@end

@implementation TradingDetail

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
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    //Set Title
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Lato-Light" size:14];
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = self.name;
    [label sizeToFit];
    
    [self getUserBalancePoint];
    tfPrice.text = [NSString stringWithFormat:@"%f", self.marketPrice];
    tfSession.text = [NSString stringWithFormat:@"%d", self.session+1];
}

#pragma mark - BMServer
- (void) getUserBalancePoint
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    [[BMServer sharedInstance] getUserBMPoints:[BMUser sharedUser].user_id success:^(NSDictionary *response){
       
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"------- 사용자 BM포인트 얻기응답 -------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            [BMUser sharedUser].point = ((NSString *)response[@"point"]).intValue;
            [BMUser sharedUser].bm = ((NSString *)response[@"bm"]).intValue;
            
            NSLog(@"------user point and bm ----%d, %d", [BMUser sharedUser].point, [BMUser sharedUser].bm);
            tfBalancePoint.text = [NSString stringWithFormat:@"%d", [BMUser sharedUser].point];
        }
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
        [[BMUtility sharedUtility] showAlert:@"User Point" message:operation.error.description];
    }];
}

- (IBAction)submit:(id)sender
{
    if(totalPrice > [BMUser sharedUser].point)
    {
        [[BMUtility sharedUtility] showAlert:@"Trading" message:@"Total price can't be greater than user point"];
        return;
    }
    if(tfTraderPrice.text.floatValue < self.marketPrice)
    {
        [[BMUtility sharedUtility] showAlert:@"Trading" message:@"Trader price can't smaller than market price"];
        return;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    NSString *date =[NSString stringWithFormat:@"%@",[format stringFromDate:[NSDate date]]];
    
    NSDictionary *params = @{
                             @"user_id":[BMUser sharedUser].user_id,
                             @"product_id":self.product_id,
                             @"user_balance":@([BMUser sharedUser].point),
                             @"quantity":tfQuantity.text,
                             @"market_price":@(self.marketPrice),
                             @"total_price":@(totalPrice),
                             @"trader_price":tfTraderPrice.text,
                             @"session":@(self.session),
                             @"date":date
                             };
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    [[BMServer sharedInstance] makeTrading:params success:^(NSDictionary *response){
    
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"---------- Trading 만들기 응답 ----------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            [[BMUtility sharedUtility] showMBAlert:self.view message:@"Success"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
        [[BMUtility sharedUtility] showAlert:@"Trading" message:operation.error.description];
    }];
    
}

#pragma mark - UITextField
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == TAG_QUANTITY)
    {
        totalPrice = self.marketPrice * tfQuantity.text.intValue;
        tfTotalPrice.text = [NSString stringWithFormat:@"%f", totalPrice];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
