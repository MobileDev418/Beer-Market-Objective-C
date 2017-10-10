//
//  BMServer.m
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMServer.h"


@implementation BMServer

#pragma mark - Initialization
+(BMServer *) sharedInstance
{
    static id instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BMServer new];
    });
    
    return instance;
}

- (id) init
{
    if(self == [super init])
    {
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:SERVER_URL]];
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        //self.operationManager.responseSerializer = [AFJSONRequestSerializer serializer];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    
    return self;
}

#pragma mark - LogIn/SignUp
- (void) signupUser:(BMUser*)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                                @"user_name":user.userName,
                                @"first_name":user.firstName,
                                @"last_name":user.lastName,
                                @"gender":@(user.gender),
                                @"birthday":user.birthday,
                                @"address":user.address,
                                @"email":user.email,
                                @"mobile_no":user.mobileNumber,
                                @"password":user.password
                            };
    
    [self.operationManager POST:@"user/signup"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id response){
                            
                            successBlock(response);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        failureBlock(operation);
    }];
}

- (void) signinUser:(BMUser*)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSLog(@"------userName: %@, password: %@", user.userName, user.password);
    NSDictionary *params = @{
                                 @"user_name":user.userName,
                                 @"password":user.password
                             };
    [self.operationManager  POST:@"user/signin"
                      parameters:params
                         success:^(AFHTTPRequestOperation *operation, id response){

                             successBlock(response);
                         }
                         failure:^(AFHTTPRequestOperation *operation, NSError *error){
                             
                             failureBlock(operation);
                         }];
}

#pragma mark - User Profile
- (void) getUserProfile:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                                @"user_id":user_id
                            };
    [self.operationManager GET:@"user/getprofile"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
         
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) modifyProfile:(BMUser *)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user.user_id,
                             @"user_name":user.userName,
                             @"first_name":user.firstName,
                             @"last_name":user.lastName,
                             @"gender":@(user.gender),
                             @"birthday":user.birthday,
                             @"address":user.address,
                             @"email":user.email,
                             @"mobile_no":user.mobileNumber,
                             @"password":user.password
                             };
    
    [self.operationManager PUT:@"user/modifyprofile"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - UserBMPoints
- (void) getUserBMPoints:(NSString *) user_id success:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"user/getpoint"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
    
                           failureBlock(operation);
                       }];
}

#pragma mark - Home
- (void) getPromotionImages:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock
{
    [self.operationManager GET:@"home/promotion"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - Reservation
- (void) getAvailableProducts:(NSString *)date success:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock
{
    NSDictionary *params = @{
                             @"date":date
                             };
    
    [self.operationManager POST:@"reservation/products"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) getTimeSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock
{
    [self.operationManager GET:@"reservation/gettime"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) getDateSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock
{
    [self.operationManager GET:@"reservation/getdate"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) getLocationSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock
{
    [self.operationManager GET:@"reservation/location"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) makeReservation:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager POST:@"reservation/create"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - Location
- (void) getLocation:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager GET:@"location/getlocation"
                    parameters:nil
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - Entertainment
- (void) getEntertainmentList:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"entertainment/getlist"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id response){
                            
                            successBlock(response);
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                            
                            failureBlock(operation);
                        }];
}

#pragma mark - Scan
- (void) scanQRCode:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager POST:@"scan/getscan"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id response){
                            
                            successBlock(response);
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                            
                            failureBlock(operation);
                        }];
}

#pragma mark - Trading
- (void) getTradingList:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"trading/getlist"
                     parameters:params
                        success:^(AFHTTPRequestOperation *operation, id response){
                            
                            successBlock(response);
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                            
                            failureBlock(operation);
                        }];
}

- (void) makeTrading:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager POST:@"trading/make"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - Redemption
- (void) getConvertRate:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager GET:@"redemption/rate"
                     parameters:nil
                        success:^(AFHTTPRequestOperation *operation, id response){
                            
                            successBlock(response);
                        }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                            
                            failureBlock(operation);
                        }];
}

- (void) makeRedemption:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    [self.operationManager POST:@"redemption/make"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

#pragma mark - MY BM$
- (void) getScanHistory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"mybm/scan"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) getTradingHitory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"mybm/trading"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

- (void) getRedemptionHistory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock
{
    NSDictionary *params = @{
                             @"user_id":user_id
                             };
    
    [self.operationManager GET:@"mybm/redemption"
                    parameters:params
                       success:^(AFHTTPRequestOperation *operation, id response){
                           
                           successBlock(response);
                       }failure:^(AFHTTPRequestOperation *operation, NSError *error){
                           
                           failureBlock(operation);
                       }];
}

@end
