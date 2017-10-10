//
//  BMAnnotation.h
//  BeerMarket
//
//  Created by Admin on 31/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface BMAnnotation : NSObject<MKAnnotation>
{

}
- (id) initAnnotation:(CLLocationCoordinate2D)location title:(NSString *) title subTitle:(NSString *)subTitle;
@property(nonatomic, readwrite) CLLocationCoordinate2D location;
@property(nonatomic, retain) NSString *customTitle;
@property(nonatomic, retain) NSString *customSubTitile;

@end
