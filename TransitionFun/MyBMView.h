//
//  MyBMView.h
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTUtil.h"

@interface MyBMView : UITableViewController
{
    NSArray *scanHistoryArray;
    NSArray *redemHistoryArray;
    NSArray *tradingHistoryArray;
    
    int selectedIndex;
}
- (IBAction)menuButtonTapped:(id)sender;
@end
