//
//  BMUtility.h
//  BeerMarket
//
//  Created by Admin on 28/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol BMUtilityDelegate <NSObject>

@optional
- (void) pickerDoneButtonClicked;
- (void) pickerCancelButtonClicked;

@end

@interface BMUtility : NSObject
{
    MBProgressHUD *mbProgress;
    MBProgressHUD *mbAlert;
}
@property(strong, nonatomic) id<BMUtilityDelegate> delete;
@property(nonatomic, readwrite) BOOL isUserLogin;
+(BMUtility *) sharedUtility;

- (void) showAlert:(NSString *)title message:(NSString *)message;
- (void) showMBProgress:(UIView *)view message:(NSString *)message;
- (void) hideMBProgress;
- (void) showMBAlert:(UIView *)view message:(NSString *)message;
- (UIView *)customPicker;
- (BOOL) isFourInchiScreen;

#pragma mark - Sequence
- (void) printTimeStamp;

#pragma mark - Image download
+ (UIImage *) getCachedImageFromPath:(NSString *)PathURL withName:(NSString *)filename;
+ (NSString *) getFileName:(NSString *)strUrl;
+ (NSString *) getFilePath:(NSString *)strUrl;

@end
