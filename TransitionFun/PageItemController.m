//
//  PageItemController.m
//  HandOff_ObjC
//
//  Created by Olga Dalton on 23/10/14.
//  Copyright (c) 2014 Olga Dalton. All rights reserved.
//

#import "PageItemController.h"

@interface PageItemController ()

@end

@implementation PageItemController
@synthesize itemIndex;
@synthesize imageName;
@synthesize contentImageView;

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentImageView.image = [UIImage imageNamed: imageName];
}

#pragma mark -
#pragma mark Content

- (void) setImageName: (NSString *) name
{
    imageName = name;
    contentImageView.image = [UIImage imageNamed: imageName];
}

- (void) setImageFromServer:(NSString *)url
{
    NSLog(@"----------url-------%@", url);
    contentImageView.image = [UIImage imageNamed:@"home-page.png"];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^(void) {
        
        UIImage *image = [BMUtility getCachedImageFromPath:[BMUtility getFilePath:url] withName:[BMUtility getFileName:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image)
            {
                NSLog(@"-------HERE-------");
                [contentImageView setImage:image];
            }
        });
    });
}

- (void) setUpImage:(UIImage *)img
{
    contentImageView.image = img;
}

@end
