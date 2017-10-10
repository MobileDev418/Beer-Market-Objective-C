//
//  ReservationView.h
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationView : UITableViewController
{
    NSArray *timeArray;
    NSArray *dateArray;
    NSArray *locationArray;
    NSMutableArray *paxArray;
    NSArray *productArray;
    NSMutableArray *productList;
    
}
- (IBAction)menuButtonTapped:(id)sender;
@end
