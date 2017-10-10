//
//  TradingDetail.h
//  TransitionFun
//
//  Created by AnjDenny on 24/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TradingDetail : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *tfBalancePoint;
    IBOutlet UITextField *tfQuantity;
    IBOutlet UITextField *tfPrice;
    IBOutlet UITextField *tfTotalPrice;
    IBOutlet UITextField *tfTraderPrice;
    IBOutlet UITextField *tfSession;
    
    float totalPrice;
}
@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *product_id;
@property(readwrite, nonatomic) float  marketPrice;
@property(readwrite, nonatomic) int session;

- (IBAction)submit:(id)sender;

@end
