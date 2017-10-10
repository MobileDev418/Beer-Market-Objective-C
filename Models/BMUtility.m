//
//  BMUtility.m
//  BeerMarket
//
//  Created by Admin on 28/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "BMUtility.h"

#define TMP NSTemporaryDirectory()

@implementation BMUtility

static id instance = nil;

+(BMUtility *) sharedUtility
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [BMUtility new];
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

- (void) showAlert:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil, nil];
    [alert show];
    alert = nil;
}

- (void) showMBProgress:(UIView *)view message:(NSString *)message
{
    mbProgress = [[MBProgressHUD alloc] initWithView:view];
    mbProgress.detailsLabelText = message;
    [view addSubview:mbProgress];
    [mbProgress show:YES];
}

- (void) hideMBProgress
{
    if(mbProgress)
       [mbProgress hide:YES];
}

- (void) showMBAlert:(UIView *)view message:(NSString *)message
{
    mbAlert = [[MBProgressHUD alloc] initWithView:view];
    mbAlert.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    mbAlert.mode = MBProgressHUDModeCustomView;
    mbAlert.labelText = message;
    [mbAlert show:YES];
    [mbAlert hide:YES afterDelay:1.2];
    [view addSubview:mbAlert];
}

- (BOOL) isFourInchiScreen
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return screenBounds.size.height == 568;
}

#pragma mark - Sequence
- (void) printTimeStamp
{
    NSLog(@"timestamp-----------%@-------------", [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]);
}

#pragma mark - Image download
+ (UIImage *) getCachedImageFromPath:(NSString *)PathURL withName:(NSString *)filename
{
    // Generate a unique path to a resource representing the image you want
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
    }
    else
    {
        // get a new one
        [self cacheImageFromPath:PathURL withName:filename];
        image = [UIImage imageWithContentsOfFile: uniquePath];
    }
    
    return image;
}

+ (void)cacheImageFromPath:(NSString *)PathURL withName:(NSString *)filename
{
    NSString *ImageURLString = [PathURL stringByAppendingString:filename];
    NSURL *ImageURL = [NSURL URLWithString:ImageURLString];
    
    // Generate a unique path to a resource representing the image you want
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        
        // Fetch image
        NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
        UIImage *image = [[UIImage alloc] initWithData: data];
        
        
        // Is it PNG or JPG/JPEG?
        // Running the image representation function writes the data from the image to a file
        if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
        }
        else if(
                [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
                [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
                )
        {
            [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
        }
    }
}

+ (NSString *) getFileName:(NSString *)strUrl
{
    NSArray *parts = [strUrl componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    return filename;
}

+ (NSString *) getFilePath:(NSString *)strUrl
{
    NSArray *parts = [strUrl componentsSeparatedByString:@"/"];
    NSString *filename = [parts objectAtIndex:[parts count]-1];
    int pathLength = (int)(strUrl.length - filename.length);
    NSString *strPath = [strUrl substringWithRange:NSMakeRange(0, pathLength)];
    return strPath;
}


@end
