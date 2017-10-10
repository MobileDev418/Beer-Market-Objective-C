//
//  BMUser.h
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum BMGender
{
    kMale = 1,
    kFemale
} BMGender;

@interface BMUser : NSObject
{
    
}
@property(strong, nonatomic) NSString       *user_id;
@property(strong, nonatomic) NSString       *userName;
@property(strong, nonatomic) NSString       *firstName;
@property(strong, nonatomic) NSString       *lastName;
@property(assign, nonatomic) BMGender        gender;
@property(strong, nonatomic) NSString       *birthday;
@property(strong, nonatomic) NSString       *address;
@property(strong, nonatomic) NSString       *email;
@property(strong, nonatomic) NSString       *mobileNumber;
@property(strong, nonatomic) NSString       *password;
@property(assign, nonatomic) int            point;
@property(assign, nonatomic) int            bm;

+ (BMUser *) sharedUser;
- (void) saveUser;
- (void) rememberUser;
- (void) forgetUser;
- (BOOL) isRememberUser;
- (void) updateUser:(NSDictionary *)userInfo success:(void(^)(bool success))successBlock;
@end
