//
//  ScanReceiptView.h
//  TransitionFun
//
//  Created by AnjDenny on 21/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "ZBarSDK.h"

@interface ScanReceiptView : UIViewController <UINavigationControllerDelegate,ECSlidingViewControllerDelegate, ZBarReaderViewDelegate>
- (IBAction)menuButtonTapped:(id)sender;
@end
