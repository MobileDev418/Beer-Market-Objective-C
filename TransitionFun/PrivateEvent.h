//
//  PrivateEvent.h
//  TransitionFun
//
//  Created by AnjDenny on 25/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface PrivateEvent : UIViewController<MFMailComposeViewControllerDelegate>
- (IBAction)menuButtonTapped:(id)sender;
- (IBAction)calling:(id)sender;
- (IBAction)emailing:(id)sender;
@end
