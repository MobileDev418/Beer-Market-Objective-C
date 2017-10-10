//
//  BMReservation.m
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMReservation.h"

@implementation BMReservation

static id instance = nil;

+ (BMReservation *) sharedReservation
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [BMReservation new];
    });
    
    return instance;
}

- (id) init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

@end
