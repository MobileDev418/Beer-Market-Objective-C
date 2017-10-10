//
//  MyProfileCell.h
//  TransitionFun
//
//  Created by AnjDenny on 21/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyProfileCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *bodyLabel;
@property (strong, nonatomic)  IBOutlet UIImageView *bgImageView;
@end
