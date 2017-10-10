//
//  TradingView.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "TradingView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "TradingDetail.h"

#define PRODUCT_LOCK        @"LOCK"
#define PRODUCT_UNLOCK      @"UNLOCK"

@interface TradingView (){
    
    NSMutableArray *products;
    NSMutableArray *prices;
    NSMutableArray *status;
    
    NSArray *productArray;
    int session;
    IBOutlet UILabel *lblSession;
    int selectedItem;

}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation TradingView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tempImageView.image = [UIImage imageNamed:@"main_bg.png"];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    products = [[NSMutableArray alloc] initWithObjects:@"Product",@"Tiger",@"Cpke",@"Fruit Tea", nil];
    prices = [[NSMutableArray alloc] initWithObjects:@"Price",@"10.20",@"4.0",@"5.60", nil];
    status = [[NSMutableArray alloc] initWithObjects:@"Status",@"-",@"-",@"-", nil];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Set Title
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Lato-Light" size:14];
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Trading", @"");
    [label sizeToFit];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]])
    {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture) {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    } else {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
    
    [self loadData];
}

#pragma mark - BMServer
- (void)loadData
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    [[BMServer sharedInstance] getTradingList:[BMUser sharedUser].user_id success:^(NSDictionary *response){
        
        [[BMUtility sharedUtility] hideMBProgress];
        NSLog(@"------- TradingList얻기 응답입니다. --------\n%@", response);
        if([response[@"status"] isEqualToString:@"success"])
        {
            productArray = [NSArray arrayWithArray:response[@"items"]];
            session = ((NSString *)response[@"session"]).intValue;
            lblSession.text = [NSString stringWithFormat:@"Session : %d",session];
        }
        [self.tableView reloadData];
    }failure:^(AFHTTPRequestOperation *operation){
        
        [[BMUtility sharedUtility] hideMBProgress];
    }];
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (int)productArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:19.f/255.0f blue:6.0f/255.0f alpha:1];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    
    UILabel *dateLBL = (UILabel*)[cell viewWithTag:100];
    dateLBL.textColor = [UIColor whiteColor];
    
    UILabel *amountLBL = (UILabel*)[cell viewWithTag:200];
    amountLBL.textColor = [UIColor whiteColor];
    
    UILabel *pointLBL = (UILabel*)[cell viewWithTag:300];
    pointLBL.textColor = [UIColor whiteColor];
    
    if(indexPath.row == 0)
    {
        dateLBL.text = @"Name";
        amountLBL.text = @"Price";
        pointLBL.text = @"Status";
    }
    else
    {
        dateLBL.text = [productArray objectAtIndex:indexPath.row-1][@"name"];
        amountLBL.text = [productArray objectAtIndex:indexPath.row-1][@"price"];
        pointLBL.text = [productArray objectAtIndex:indexPath.row-1][@"available"];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return;
    if([[productArray objectAtIndex:indexPath.row-1][@"available"] isEqualToString:PRODUCT_LOCK])
        return;
    
    selectedItem = (int)indexPath.row - 1;
    [self performSegueWithIdentifier:@"SubTrading" sender:self];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SubTrading"])
    {
        TradingDetail *vc = (TradingDetail *)segue.destinationViewController;
        vc.product_id = [productArray objectAtIndex:selectedItem][@"product_id"];
        vc.name = [productArray objectAtIndex:selectedItem][@"name"];
        vc.session = session;
        vc.marketPrice = /*((NSString *)[productArray objectAtIndex:selectedItem][@"price"]).floatValue*/12.3;
    }
}


@end
