//
//  LocationView.h
//  TransitionFun
//
//  Created by AnjDenny on 21/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <MapKit/MapKit.h>

@interface LocationView : UIViewController <ECSlidingViewControllerDelegate, MKMapViewDelegate>
{
    NSArray *mapAnnotationArr;
    NSMutableArray *annotations;
}
- (IBAction)menuButtonTapped:(id)sender;
@end
