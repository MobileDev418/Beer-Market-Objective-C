//
//  BMServer.h
//  BeerMarket
//
//  Created by Admin on 27/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMServer : NSObject
{
    
}
@property(strong, nonatomic) AFHTTPRequestOperationManager *operationManager;

+(BMServer *) sharedInstance;

#pragma mark - User Login/SignUp
- (void) signupUser:(BMUser*)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) signinUser:(BMUser*)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - User Profile
- (void) getUserProfile:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) modifyProfile:(BMUser *)user success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - User BMPoints
- (void) getUserBMPoints:(NSString *)user_id success:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Home
- (void) getPromotionImages:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock;

#pragma mark - Reservation
- (void) getAvailableProducts:(NSString *)date success:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock;
- (void) getTimeSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock;
- (void) getDateSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock;
- (void) getLocationSlots:(void(^)(NSDictionary *))successBlock failure:(void(^)(AFHTTPRequestOperation *))failureBlock;
- (void) makeReservation:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Location
- (void) getLocation:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Entertainment
- (void) getEntertainmentList:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Scan
- (void) scanQRCode:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Trading
- (void) getTradingList:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) makeTrading:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - Redemption
- (void) getConvertRate:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) makeRedemption:(NSDictionary *)params success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;

#pragma mark - MY BM$
- (void) getScanHistory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) getTradingHitory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
- (void) getRedemptionHistory:(NSString *)user_id success:(void(^)(NSDictionary *response))successBlock failure:(void(^)(AFHTTPRequestOperation *operation))failureBlock;
@end
