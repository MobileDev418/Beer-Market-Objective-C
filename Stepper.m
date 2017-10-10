//
//  Stepper.m
//  TransitionFun
//
//  Created by AnjDenny on 29/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "Stepper.h"

@implementation Stepper
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 94, 30)];
    if (self) {
        // Initialization code
        UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
        plus.frame = CGRectMake(94/2 + 15, 0, 94/2 - 15, 30);
        [plus addTarget:self action:@selector(PlusClick:) forControlEvents:UIControlEventTouchUpInside];
        [plus setImage:[UIImage imageNamed:@"Plus"] forState:UIControlStateNormal];
        [self addSubview:plus];
        
        UIButton *minus = [UIButton buttonWithType:UIButtonTypeCustom];
        minus.frame = CGRectMake(0, 0, 94/2 - 15, 30);
        [minus addTarget:self action:@selector(MinusClick:) forControlEvents:UIControlEventTouchUpInside];
        [minus setImage:[UIImage imageNamed:@"minus"] forState:UIControlStateNormal];
        [self addSubview:minus];
        
        scoreLbl = [[UILabel alloc] initWithFrame:CGRectMake(94/2 - 15, 3, 30, 24)];
        scoreLbl.text = @"0";
        scoreLbl.layer.borderWidth = 1.0;
        scoreLbl.textAlignment = NSTextAlignmentCenter;
        scoreLbl.layer.cornerRadius = 2;
        scoreLbl.layer.borderColor = (__bridge CGColorRef)([UIColor blueColor]);
        [self addSubview:scoreLbl];
        
    }
    return self;
}

- (void)PlusClick:(id)sender
{
    scoreLbl.text = [NSString stringWithFormat:@"%ld",[scoreLbl.text integerValue] + 1];
    [self.delegate changeValue:self value:scoreLbl.text.intValue];
}

- (void)MinusClick:(id)sender
{
    if(scoreLbl.text.intValue <= 0)
        return;
    scoreLbl.text = [NSString stringWithFormat:@"%ld",[scoreLbl.text integerValue] - 1];
    [self.delegate changeValue:self value:scoreLbl.text.intValue];
}

@end
