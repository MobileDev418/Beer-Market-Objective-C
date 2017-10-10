//
//  BMUser.m
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMUser.h"

@implementation BMUser

static id instance = nil;
+ (BMUser *) sharedUser
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [BMUser new];
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

- (void) saveUser
{
    NSUserDefaults *bmDefault = [NSUserDefaults standardUserDefaults];
    [bmDefault setValue:self.userName forKey:USER_NAME];
    [bmDefault setValue:self.password forKey:USER_PASSWORD];
    [bmDefault synchronize];
}

- (void) rememberUser
{
    NSUserDefaults *bmDefault = [NSUserDefaults standardUserDefaults];
    [bmDefault setValue:@"1" forKey:REMEMBER_USER];
    [bmDefault synchronize];
}

- (void) forgetUser
{
    NSUserDefaults *bmDefault = [NSUserDefaults standardUserDefaults];
    [bmDefault setValue:@"0" forKey:REMEMBER_USER];
    [bmDefault synchronize];
}

- (BOOL) isRememberUser
{
    BOOL isRemember = NO;
    NSUserDefaults *bmDefault = [NSUserDefaults standardUserDefaults];
    NSString *rememberFlag = [bmDefault valueForKey:REMEMBER_USER];
    
    if([rememberFlag isEqualToString:@"1"])
        isRemember = YES;
    return isRemember;
}

- (void) updateUser:(NSDictionary *)userInfo success:(void(^)(bool success))successBlock
{
    self.user_id = userInfo[@"user_id"];
    self.userName = userInfo[@"user_name"];
    self.firstName = userInfo[@"first_name"];
    self.lastName = userInfo[@"last_name"];
    self.gender = ([userInfo[@"gender"] isEqualToString:@"1"]) ? kMale : kFemale;
    self.birthday = userInfo[@"birthday"];
    self.address = userInfo[@"address"];
    self.email = userInfo[@"email"];
    self.mobileNumber = userInfo[@"mobile_no"];
    self.password = userInfo[@"password"];
    
    [self saveUser];
    successBlock(true);
}

@end
