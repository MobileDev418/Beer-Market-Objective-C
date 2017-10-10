// MEMenuViewController.m
// TransitionFun
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "PTMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface PTMenuViewController ()
{

}
@property (nonatomic, strong) NSArray *imageLeft;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@end

@implementation PTMenuViewController

static id instance = nil;

+(PTMenuViewController *) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [PTMenuViewController new];
    });
    
    return instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    if([BMUtility sharedUtility].isUserLogin)
    {
        self.imageLeft = [NSArray arrayWithObjects:@"MyProfile.png",@"Home.png",@"Reservation.png",@"location.png",@"Private_event.png",@"Entertain.png",@"Notification.png",@"myBm.png",@"Scan_Receipts.png",@"Trading.png",@"Redemption.png",@"Lets_Talk.png", nil];
        
        self.menuItems = [NSArray arrayWithObjects:@"My Profile",@"Home",@"Reservations",@"Location",@"Private Events",@"What Entertain ?",@"Notification",@"MY BM$",@"Scan Receipts",@"Trading",@"Redemption",@"Let's Talk", nil];
    }
    else
    {
        self.imageLeft = [NSArray arrayWithObjects:@"menu_user.png", @"Home.png", @"Entertain.png", @"location.png", @"Private_event.png", nil];
        self.menuItems = [NSArray arrayWithObjects:@"Login/Sign Up", @"Home", @"What Entertain ?", @"Location", @"Private Events", nil];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
}

- (void) updateMenu
{
    
    NSLog(@"--------------update menu-----------------");
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
   
}

- (void) viewDidAppear:(BOOL)animated
{
    if([BMUtility sharedUtility].isUserLogin)
    {
        self.imageLeft = [NSArray arrayWithObjects:@"MyProfile.png",@"Home.png",@"Reservation.png",@"location.png",@"Private_event.png",@"Entertain.png",@"Notification.png",@"myBm.png",@"Scan_Receipts.png",@"Trading.png",@"Redemption.png",@"Lets_Talk.png", nil];
        
        self.menuItems = [NSArray arrayWithObjects:@"My Profile",@"Home",@"Reservations",@"Location",@"Private Events",@"What Entertain ?",@"Notification",@"MY BM$",@"Scan Receipts",@"Trading",@"Redemption",@"Let's Talk", nil];
    }
    else
    {
        self.imageLeft = [NSArray arrayWithObjects:@"menu_user.png", @"Home.png", @"Entertain.png", @"location.png", @"Private_event.png", nil];
        self.menuItems = [NSArray arrayWithObjects:@"Login/Sign Up", @"Home", @"What Entertain ?", @"Location", @"Private Events", nil];
    }
    
    NSLog(@"-------view did appear-------");
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int section = 1;
    if([BMUtility sharedUtility].isUserLogin)
        section = 3;
    else
        section = 1;
    return section;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor lightTextColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0,0, 320 - 44, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (section) {
        case 0:
            label.text = NSLocalizedString(@"BEER MARKRT", @"BEER MARKRT");
            break;
            
        case 1:
            label.text = NSLocalizedString(@"MENU", @"MENU");
            break;
            
        case 2:
            label.text = NSLocalizedString(@"MY ACCOUNT", @"MY ACCOUNT");
            break;
            
        default:
            break;
    }
    
    [headerView addSubview:label];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = (int)self.menuItems.count;
    
    if([BMUtility sharedUtility].isUserLogin)
    {
        switch (section) {
            case 0:
                row = 2;
                break;
                
            case 1:
                row = 5;
                break;
                
            case 2:
                row = 5;
                break;
                
            default:
                break;
        }
    }
    else
    {
        row = (int)self.menuItems.count;
    }
    
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UILabel *titleLBL = (UILabel*)[cell viewWithTag:100];
    titleLBL.textColor = [UIColor darkGrayColor];
   
    titleLBL.textColor = [UIColor lightTextColor];
    
    UIImageView *icon = (UIImageView*)[cell viewWithTag:200];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.section == 0)
    {
        icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imageLeft objectAtIndex:indexPath.row]]];
        NSString *menuItem = [NSString stringWithFormat:@"%@",[self.menuItems objectAtIndex:indexPath.row]];
         titleLBL.text = menuItem;
    }
    else if (indexPath.section == 1)
    {
        icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imageLeft objectAtIndex:indexPath.row + 2]]];
        NSString *menuItem = [NSString stringWithFormat:@"%@",[self.menuItems objectAtIndex:indexPath.row + 2]];
        titleLBL.text = menuItem;
    }
    else if(indexPath.section == 2)
    {
        icon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[self.imageLeft objectAtIndex:indexPath.row + 7]]];
        NSString *menuItem = [NSString stringWithFormat:@"%@",[self.menuItems objectAtIndex:indexPath.row + 7]];
        titleLBL.text = menuItem;
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *menuItem;
    
    switch (indexPath.section)
    {
        case 0:
            menuItem = self.menuItems[indexPath.row];
            break;
            
        case 1:
            menuItem = self.menuItems[indexPath.row + 2];
            break;
            
        case 2:
            menuItem = self.menuItems[indexPath.row + 7];
            break;
            
        default:
            break;
    }
    
     self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    if ([menuItem isEqualToString:@"Transitions"])
    {
        self.slidingViewController.topViewController = self.transitionsNavigationController;
    }
    else if ([menuItem isEqualToString:@"Settings"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MESettingsNavigationController"];
    }
    else if ([menuItem isEqualToString:@"My Profile"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTMyProfile"];
    }
    else if ([menuItem isEqualToString:@"Home"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeID"];
    }
    else if ([menuItem isEqualToString:@"Login/Sign Up"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTLoginSignup"];
    }
    else if ([menuItem isEqualToString:@"Let's Talk"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTLetsTalkID"];
    }
    else if ([menuItem isEqualToString:@"Location"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTLocationID"];
    }
    else if ([menuItem isEqualToString:@"Scane Receipts"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ScanReceiptID"];
    }
    else if ([menuItem isEqualToString:@"Notification"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationID"];
    }
    else if ([menuItem isEqualToString:@"What Entertain ?"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WhatsEntertainmentID"];
    }
    else if ([menuItem isEqualToString:@"MY BM$"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyMBID"];
    }
    else if ([menuItem isEqualToString:@"Redemption"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RedemptionID"];
    }
    else if ([menuItem isEqualToString:@"Trading"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TradingID"];
    }
    else if ([menuItem isEqualToString:@"Reservations"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReservationID"];
    }
    else if ([menuItem isEqualToString:@"Private Events"])
    {
        self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PrivateEventsID"];
    }
    
        
    [self.slidingViewController resetTopViewAnimated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
