//
//  LocationView.m
//  TransitionFun
//
//  Created by AnjDenny on 21/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "LocationView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import <MapKit/MapKit.h>
#import "BMAnnotation.h"

@interface LocationView ()
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@end

@implementation LocationView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]])
    {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture)
        {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    }
    else
    {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    }
    else
    {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    [self loadLocationData];
}

#pragma mark - BMServer
- (void) loadLocationData
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    [[BMServer sharedInstance] getLocation:^(NSDictionary *response){
        
        NSLog(@"------------로케션 얻기응답----------\n%@", response);
        [[BMUtility sharedUtility] hideMBProgress];
        if([response[@"status"] isEqualToString:@"200"])
        {
            mapAnnotationArr = [NSArray arrayWithArray:response[@"items"]];
            [self initializeMap];
        }
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
        [[BMUtility sharedUtility] showAlert:@"Location" message:operation.error.description];
    }];
}

#pragma mark - Map
- (void) initializeMap
{
    self.mapView.mapType = MKMapTypeStandard;
    annotations = [[NSMutableArray alloc] init];
    
    // annotation for the City of San Francisco
    
    for(NSDictionary *dic in mapAnnotationArr)
    {
        float longitude = ((NSString *)dic[@"long"]).floatValue;
        float latitude = ((NSString *)dic[@"lati"]).floatValue;
        NSString *tip = (NSString *)dic[@"tip"];

        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude = latitude;
        theCoordinate.longitude = longitude;
        
        BMAnnotation *anno = [[BMAnnotation alloc] initAnnotation:theCoordinate title:tip subTitle:@""];
        [annotations addObject:anno];
    }
    
    
    [self gotoLocation];
}

- (void)gotoLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 42.8323;
    newRegion.center.longitude = -98.4352;
    newRegion.span.latitudeDelta = 0.112872;
    newRegion.span.longitudeDelta = 0.109863;
    
    [self.mapView setRegion:newRegion animated:YES];
    for(BMAnnotation *anno in annotations)
    {
        [self.mapView addAnnotation:anno];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle our two custom annotations
    //
    if ([annotation isKindOfClass:[BMAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString* BridgeAnnotationIdentifier = @"bmAnnotationIdentifier";
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorRed;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: you can assign a specific call out accessory view, or as MKMapViewDelegate you can implement:
            //  - (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
            //
            
            /*detail info
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
             */
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    
    return nil;
}

- (void)showDetails:(id)sender
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
