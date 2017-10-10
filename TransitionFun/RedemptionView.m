//
//  RedemptionView.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "RedemptionView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "SAStepperControl.h"
#import "Stepper.h"

#define TAG_STEPPER_BM10        10
#define TAG_STEPPER_BM50        50

@interface RedemptionView ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation RedemptionView

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
    label.text = NSLocalizedString(@"Redemption", @"");
    [label sizeToFit];
    
    UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 350)];
    mainView.backgroundColor = [UIColor colorWithWhite:255.0f/255.0f alpha:0.7];
    mainView.layer.cornerRadius = 2;
    [self.view addSubview:mainView];
    [mainView addSubview:[self createLineView:CGRectMake(10, 10, mainView.frame.size.width -20, 1)]];
    
    UILabel *voucher = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, mainView.frame.size.width/3, 30)];
    voucher.font = [UIFont fontWithName:@"Lato-Light" size:8];
    voucher.font = [UIFont systemFontOfSize:12];
    voucher.textAlignment = NSTextAlignmentCenter;
    voucher.text = @"Voucher";
    [mainView addSubview:voucher];
    
    UILabel *quality = [[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3, 10, mainView.frame.size.width/3, 30)];
    quality.font = [UIFont fontWithName:@"Lato-Light" size:8];
    quality.font = [UIFont systemFontOfSize:12];
    quality.textAlignment = NSTextAlignmentCenter;
    quality.text = @"Quantity";
    [mainView addSubview:quality];
    
    UILabel *pointsLBL = [[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2, 10, mainView.frame.size.width/3, 30)];
    pointsLBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    pointsLBL.font = [UIFont systemFontOfSize:12];
    pointsLBL.textAlignment = NSTextAlignmentCenter;
    pointsLBL.text = @"Points Required";
    [mainView addSubview:pointsLBL];
    
    [mainView addSubview:[self createLineView:CGRectMake(10, pointsLBL.frame.origin.y + pointsLBL.frame.size.height, mainView.frame.size.width -20, 1)]];
    
    UILabel *mb10LBL = [[UILabel alloc] initWithFrame:CGRectMake(0, pointsLBL.frame.origin.y + pointsLBL.frame.size.height , mainView.frame.size.width/3, 30)];
    mb10LBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    mb10LBL.font = [UIFont systemFontOfSize:12];
    mb10LBL.textAlignment = NSTextAlignmentCenter;
    mb10LBL.text = @"MB10";
    [mainView addSubview:mb10LBL];
    
    lblPoints_bm10 =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, pointsLBL.frame.origin.y + pointsLBL.frame.size.height + 5 , 30, 20)];
    lblPoints_bm10.layer.cornerRadius = 2;
    lblPoints_bm10.font = [UIFont systemFontOfSize:12];
    lblPoints_bm10.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblPoints_bm10.textAlignment = NSTextAlignmentCenter;
    lblPoints_bm10.text = @"0";
    [mainView addSubview:lblPoints_bm10];
    
    
    stepper_bm10 = [[Stepper alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3, pointsLBL.frame.origin.y + pointsLBL.frame.size.height + 21, mainView.frame.size.width/3, 30)];
    stepper_bm10.delegate = self;
    stepper_bm10.tag = TAG_STEPPER_BM10;
    [self.view addSubview:stepper_bm10];
    
    [mainView addSubview:[self createLineView:CGRectMake(10, mb10LBL.frame.origin.y + mb10LBL.frame.size.height, mainView.frame.size.width -20, 1)]];
    
    UILabel *mb101LBL = [[UILabel alloc] initWithFrame:CGRectMake(0, mb10LBL.frame.origin.y + pointsLBL.frame.size.height , mainView.frame.size.width/3, 30)];
    mb101LBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    mb101LBL.font = [UIFont systemFontOfSize:12];
    mb101LBL.textAlignment = NSTextAlignmentCenter;
    mb101LBL.text = @"MB50";
    [mainView addSubview:mb101LBL];
    
    
    stepper_bm50 = [[Stepper alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3, mb10LBL.frame.origin.y + mb10LBL.frame.size.height + 21, mainView.frame.size.width/3, 30)];
    stepper_bm50.delegate = self;
    stepper_bm50.tag = TAG_STEPPER_BM50;
    [self.view addSubview:stepper_bm50];

    
    lblPoints_bm50 =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, mb10LBL.frame.origin.y + mb10LBL.frame.size.height + 5 , 30, 20)];
    lblPoints_bm50.layer.cornerRadius = 2;
    lblPoints_bm50.font = [UIFont systemFontOfSize:12];
    lblPoints_bm50.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblPoints_bm50.textAlignment = NSTextAlignmentCenter;
    lblPoints_bm50.text = @"0";
    [mainView addSubview:lblPoints_bm50];
    
    [mainView addSubview:[self createLineView:CGRectMake(10, mb101LBL.frame.origin.y + mb101LBL.frame.size.height, mainView.frame.size.width -20, 1)]];
    
    
    UILabel *totalReemPointLBL = [[UILabel alloc] initWithFrame:CGRectMake(60, mb101LBL.frame.origin.y + mb101LBL.frame.size.height + 30, mainView.frame.size.width/2, 30)];
    totalReemPointLBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    totalReemPointLBL.font = [UIFont systemFontOfSize:12];
    totalReemPointLBL.textAlignment = NSTextAlignmentLeft;
    totalReemPointLBL.text = @"Total Redeem Point";
    [mainView addSubview:totalReemPointLBL];
    
    UILabel *totalAvailPointLBL = [[UILabel alloc] initWithFrame:CGRectMake(60, totalReemPointLBL.frame.origin.y + totalReemPointLBL.frame.size.height , mainView.frame.size.width/2, 30)];
    totalAvailPointLBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    totalAvailPointLBL.font = [UIFont systemFontOfSize:12];
    totalAvailPointLBL.textAlignment = NSTextAlignmentLeft;
    totalAvailPointLBL.text = @"Total Available Point";
    [mainView addSubview:totalAvailPointLBL];
    
    UILabel *balancePointLBL = [[UILabel alloc] initWithFrame:CGRectMake(60, totalAvailPointLBL.frame.origin.y + totalAvailPointLBL.frame.size.height , mainView.frame.size.width/2, 30)];
    balancePointLBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    balancePointLBL.font = [UIFont systemFontOfSize:12];
    balancePointLBL.textAlignment = NSTextAlignmentLeft;
    balancePointLBL.text = @"Balance Point";
    [mainView addSubview:balancePointLBL];
    
    UILabel *totalBMLBL = [[UILabel alloc] initWithFrame:CGRectMake(60, balancePointLBL.frame.origin.y + balancePointLBL.frame.size.height , mainView.frame.size.width/2, 30)];
    totalBMLBL.font = [UIFont fontWithName:@"Lato-Light" size:8];
    totalBMLBL.font = [UIFont systemFontOfSize:12];
    totalBMLBL.textAlignment = NSTextAlignmentLeft;
    totalBMLBL.text = @"Total BM$";
    [mainView addSubview:totalBMLBL];
    
    lblTotalRedeemPoint =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, mb101LBL.frame.origin.y + mb101LBL.frame.size.height + 34 , 30, 20)];
    lblTotalRedeemPoint.layer.cornerRadius = 2;
    lblTotalRedeemPoint.font = [UIFont systemFontOfSize:12];
    lblTotalRedeemPoint.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblTotalRedeemPoint.textAlignment = NSTextAlignmentCenter;
    lblTotalRedeemPoint.text = @"0";
    [mainView addSubview:lblTotalRedeemPoint];
    
    lblTotalAvailablePoint =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, lblTotalRedeemPoint.frame.origin.y + lblTotalRedeemPoint.frame.size.height + 10 , 30, 20)];
    lblTotalAvailablePoint.layer.cornerRadius = 2;
    lblTotalAvailablePoint.font = [UIFont systemFontOfSize:12];
    lblTotalAvailablePoint.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblTotalAvailablePoint.textAlignment = NSTextAlignmentCenter;
    lblTotalAvailablePoint.text = @"0";
    [mainView addSubview:lblTotalAvailablePoint];
    
    lblBalancePoint =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, lblTotalAvailablePoint.frame.origin.y + lblTotalAvailablePoint.frame.size.height + 10 , 30, 20)];
    lblBalancePoint.layer.cornerRadius = 2;
    lblBalancePoint.font = [UIFont systemFontOfSize:12];
    lblBalancePoint.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblBalancePoint.textAlignment = NSTextAlignmentCenter;
    lblBalancePoint.text = @"0";
    [mainView addSubview:lblBalancePoint];
    
   lblTotalBM =[[UILabel alloc] initWithFrame:CGRectMake(mainView.frame.size.width/3 * 2 + 20, lblBalancePoint.frame.origin.y + lblBalancePoint.frame.size.height + 10 , 30, 20)];
    lblTotalBM.layer.cornerRadius = 2;
    lblTotalBM.font = [UIFont systemFontOfSize:12];
    lblTotalBM.backgroundColor = [UIColor colorWithRed:175.0f/255.0f green:174.0f/255.0f blue:164.0/255.0f alpha:1];
    lblTotalBM.textAlignment = NSTextAlignmentCenter;
    lblTotalBM.text = @"0";
    [mainView addSubview:lblTotalBM];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setTitle:@"SUBMIT" forState:UIControlStateNormal];
    submit.titleLabel.textColor = [UIColor whiteColor];
    submit.frame = CGRectMake(20, lblTotalBM.frame.origin.y + lblTotalBM.frame.size.height + 20 , mainView.frame.size.width - 40, 40);
    submit.layer.cornerRadius = 2;
    submit.backgroundColor =[UIColor colorWithRed:15.0f/255.0f green:12.0f/255.0f blue:7.0f/255.0f alpha:1];
    [submit addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:submit];
    
    [self loadBMRate];
    [self loadUserPoint];
}

- (UIView*)createLineView:(CGRect)rect
{
    UIView *lineView = [[UIView alloc] initWithFrame:rect];
    lineView.backgroundColor = [UIColor lightGrayColor];
    return lineView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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

#pragma mark - BMServer
- (void) loadBMRate
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading..."];
    
    
    [[BMServer sharedInstance] getConvertRate:^(NSDictionary *response){
        
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"---------콘버트레이트 얻기응답----------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            rate_bm10 = ((NSString *)response[@"bm_10"]).intValue;
            rate_bm50 = ((NSString *)response[@"bm_50"]).intValue;
        }
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
        [[BMUtility sharedUtility] showAlert:@"Redemption" message:operation.error.description];
    }];
}

- (void) loadUserPoint
{
    [[BMServer sharedInstance] getUserBMPoints:[BMUser sharedUser].user_id success:^(NSDictionary *response){
        
        NSLog(@"---------사용자 포인트 얻기응답----------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            [BMUser sharedUser].point = ((NSString *)response[@"point"]).intValue;
            [BMUser sharedUser].bm = ((NSString *)response[@"bm"]).intValue;
            
            lblTotalAvailablePoint.text = [NSString stringWithFormat:@"%d", [BMUser sharedUser].point];
            lblBalancePoint.text = [NSString stringWithFormat:@"%d", [BMUser sharedUser].point];
            lblTotalBM.text = [NSString stringWithFormat:@"%d", [BMUser sharedUser].bm];
        }
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] showAlert:@"Redemption" message:operation.error.description];
    }];
}

- (void) submit
{
    if(balance_point < 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Redemption" message:@"Redemption Point can't be greater than total available point"];
        return;
    }
    
//    {
//        "user_id":"568",
//        "quantity_bm10":"8",
//        "quantity_bm50":"4",
//        "date":"03/24/2015"
//    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    NSString *date =[NSString stringWithFormat:@"%@",[format stringFromDate:[NSDate date]]];
    
    NSDictionary *dic = @{
                          @"user_id":[BMUser sharedUser].user_id,
                          @"quantity_bm10":@(quantity_bm10),
                          @"quantity_bm50":@(quantity_bm50),
                          @"date":date
                          };
    
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    [[BMServer sharedInstance] makeRedemption:dic success:^(NSDictionary *response){
       
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"---------- Redemption만들기 응답 ------------\n%@", response);
    }failure:^(AFHTTPRequestOperation *operation){

        [[BMUtility sharedUtility] hideMBProgress];
    }];
}

#pragma mark - BMStepper Delegate
- (void) changeValue:(id)sender value:(int)value
{
    if(((Stepper *)sender).tag == TAG_STEPPER_BM10)
    {
        quantity_bm10 = value;
    }
    else if(((Stepper *)sender).tag == TAG_STEPPER_BM50)
    {
        quantity_bm50 = value;
    }
    
    total_redeem_point = quantity_bm10 * rate_bm10 + quantity_bm50 * rate_bm50;
    total_available_point = [BMUser sharedUser].point;
    balance_point = total_available_point - total_redeem_point;
    total_bm_point = [BMUser sharedUser].bm + quantity_bm10 + quantity_bm50;
    
    lblPoints_bm10.text = [NSString stringWithFormat:@"%d", quantity_bm10 * rate_bm10];
    lblPoints_bm50.text = [NSString stringWithFormat:@"%d", quantity_bm50 * rate_bm50];
    lblTotalRedeemPoint.text = [NSString stringWithFormat:@"%d", total_redeem_point];
    lblTotalAvailablePoint.text = [NSString stringWithFormat:@"%d", total_available_point];
    lblBalancePoint.text = [NSString stringWithFormat:@"%d", balance_point];
    lblTotalBM.text = [NSString stringWithFormat:@"%d", total_bm_point];
}

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
