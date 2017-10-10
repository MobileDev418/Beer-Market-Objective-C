//
//  PTProfileView.h
//  TransitionFun
//
//  Created by AnjDenny on 25/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTProfileView : UITableViewController
{
    BMUser *m_pUser;
}
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)onUpdateProfile:(id)sender;
@end
