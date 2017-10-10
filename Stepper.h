//
//  Stepper.h
//  TransitionFun
//
//  Created by AnjDenny on 29/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BMStepperDelegate <NSObject>

@optional

- (void) changeValue:(id)sender value:(int)value;

@end

@interface Stepper : UIView
{
    UILabel *scoreLbl;
}

@property(nonatomic, retain) id<BMStepperDelegate>delegate;

@end
