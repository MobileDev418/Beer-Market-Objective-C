//
//  BMReservation.h
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMReservation : NSObject
{
    
}
@property(strong, nonatomic) NSString       *reservation_id;
@property(strong, nonatomic) NSString       *name;
@property(strong, nonatomic) NSString       *contactNumber;
@property(strong, nonatomic) NSString       *email;
@property(strong, nonatomic) NSString       *time;
@property(assign, nonatomic) int             pax_quantity;
@property(strong, nonatomic) NSString       *date;
@property(strong, nonatomic) NSString       *location;
@property(strong, nonatomic) NSString       *remarks;

+ (BMReservation *) sharedReservation;

@end
