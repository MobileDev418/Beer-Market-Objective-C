//
//  RedemptionView.h
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stepper.h"

@interface RedemptionView : UIViewController<BMStepperDelegate>
{
    int rate_bm10;
    int rate_bm50;
    int quantity_bm10;
    int quantity_bm50;
    
    int total_redeem_point;
    int total_available_point;
    int balance_point;
    int total_bm_point;
    
    UILabel *lblPoints_bm10;
    UILabel *lblPoints_bm50;
    UILabel *lblTotalRedeemPoint;
    UILabel *lblTotalAvailablePoint;
    UILabel *lblBalancePoint;
    UILabel *lblTotalBM;
    
    Stepper *stepper_bm10;
    Stepper *stepper_bm50;
}

- (IBAction)menuButtonTapped:(id)sender;
@end
