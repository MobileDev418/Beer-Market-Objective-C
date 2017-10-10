//
//  BMAnnotation.m
//  BeerMarket
//
//  Created by Admin on 31/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMAnnotation.h"

@implementation BMAnnotation

@synthesize customSubTitile;
@synthesize customTitle;
@synthesize location;


- (id) initAnnotation:(CLLocationCoordinate2D)location title:(NSString *) title subTitle:(NSString *)subTitle
{
    if(self = [super init])
    {
        self.location = location;
        self.customTitle = title;
        self.customSubTitile = subTitle;
    }
    
    return self;
}
- (CLLocationCoordinate2D)coordinate;
{
    return self.location;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title
{
    return self.customTitle;
}

// optional
- (NSString *)subtitle
{
    return self.customSubTitile;
}

- (void)dealloc
{
    
}


@end
