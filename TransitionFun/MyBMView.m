//
//  MyBMView.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "MyBMView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

#define TAG_SCAN_DATE           100
#define TAG_SCAN_CODE           200
#define TAG_SCAN_POINT          300

#define TAG_REDEM_DATE          100
#define TAG_REDEM_BM10          200
#define TAG_REDEM_BM50          300

#define TAG_TRADING_DATE        100
#define TAG_TRADING_NAME        200
#define TAG_TRADING_PRICE       300
#define TAG_TRADING_QUANTITY    400

@interface MyBMView (){
    NSMutableArray *dates;
    NSMutableArray *amounts;
    NSMutableArray *points;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation MyBMView

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
    
    dates = [[NSMutableArray alloc] initWithObjects:@"Date",@"01/30/2015",@"02/30/2015", nil];
    amounts = [[NSMutableArray alloc] initWithObjects:@"Amount",@"100",@"200", nil];
    points = [[NSMutableArray alloc] initWithObjects:@"Point",@"30",@"60", nil];
    
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
    label.text = NSLocalizedString(@"MY BM", @"");
    [label sizeToFit];
    
    UIView *headerView;
    if (IS_IPAD) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, 90)];
    }else{
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, self.view.frame.size.width, 60)];
    }
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView;
    if (IS_IPAD) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 10, 70, 70)];
    }else{
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 10, 40, 40)];
    }
    
    
    imageView.image = [PTUtil imageWithImage:[UIImage imageNamed:@"login_logo.png"] scaledToSize:CGSizeMake(40, 40)];
    [headerView addSubview:imageView];
    
    UILabel *labelView;
    if (IS_IPAD) {
        labelView = [[UILabel alloc] initWithFrame:CGRectMake(120, headerView.frame.size.height/2 - 25, self.view.frame.size.width - 70, 50)];
    }else{
        labelView = [[UILabel alloc] initWithFrame:CGRectMake(60, headerView.frame.size.height/2 - 15, self.view.frame.size.width - 70, 30)];
    }
    
    labelView.text = @"Balanee Point Will be";
    labelView.font = [UIFont fontWithName:@"Lato-Light" size:14];
    [headerView addSubview:labelView];
    self.tableView.tableHeaderView = headerView;
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Scan", @"Trading", @"Redemption", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    if (IS_IPAD) {
        segmentedControl.frame = CGRectMake(20, self.view.frame.size.height - 64 - 50 - 10, self.view.frame.size.width - 40, 50);
    }else{
        segmentedControl.frame = CGRectMake(20, self.view.frame.size.height - 64 - 50 - 10, self.view.frame.size.width - 40, 30);
    }
    
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segmentedControl addTarget:self action:@selector(SegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:segmentedControl];
    selectedIndex = 0;
    
    [self loadHistoryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]])
    {
        MEDynamicTransition *dynamicTransition = (MEDynamicTransition *)self.slidingViewController.delegate;
        if (!self.dynamicTransitionPanGesture)
        {
            self.dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:dynamicTransition action:@selector(handlePanGesture:)];
        }
        
        [self.navigationController.view removeGestureRecognizer:self.slidingViewController.panGesture];
        [self.navigationController.view addGestureRecognizer:self.dynamicTransitionPanGesture];
    }
    else
    {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

#pragma mark - BMServer
- (void) loadHistoryData
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [[BMServer sharedInstance] getScanHistory:[BMUser sharedUser].user_id success:^(NSDictionary *response){
            
            NSLog(@"--------- 스캔히스토리 응답 ---------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                scanHistoryArray = [NSArray arrayWithArray:response[@"items"]];
                [self.tableView reloadData];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
            [[BMUtility sharedUtility] showAlert:@"My BM" message:operation.error.description];
        }];

        [[BMServer sharedInstance] getRedemptionHistory:[BMUser sharedUser].user_id success:^(NSDictionary *response){
            
            NSLog(@"--------- 리딤히스토리 응답 ---------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                redemHistoryArray = [NSArray arrayWithArray:response[@"items"]];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
            [[BMUtility sharedUtility] showAlert:@"My BM" message:operation.error.description];
        }];
        
        [[BMServer sharedInstance] getTradingHitory:[BMUser sharedUser].user_id success:^(NSDictionary *response){
            
            NSLog(@"--------- Trading 히스토리 응답 ---------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                tradingHistoryArray = [NSArray arrayWithArray:response[@"items"]];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
            [[BMUtility sharedUtility] showAlert:@"My BM" message:operation.error.description];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            NSLog(@"------- 응답이 끝났습니다 --------");
            [[BMUtility sharedUtility] hideMBProgress];
        });
        
    });
    
}

- (IBAction)menuButtonTapped:(id)sender
{
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rowCount = 1;
    if(selectedIndex == 0)
        rowCount = (int)scanHistoryArray.count+1;
    else if(selectedIndex == 1)
        rowCount = (int)tradingHistoryArray.count+1;
    else if(selectedIndex == 2)
        rowCount = (int)redemHistoryArray.count+1;
    
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(selectedIndex == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ScanCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:19.f/255.0f blue:6.0f/255.0f alpha:1];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        
        UILabel *dateLBL = (UILabel*)[cell viewWithTag:TAG_SCAN_DATE];
        dateLBL.textColor = [UIColor darkGrayColor];
        
        
        UILabel *codeLBL = (UILabel*)[cell viewWithTag:TAG_SCAN_CODE];
        codeLBL.textColor = [UIColor darkGrayColor];
        
        UILabel *pointLBL = (UILabel*)[cell viewWithTag:TAG_SCAN_POINT];
        pointLBL.textColor = [UIColor darkGrayColor];
        
        if(indexPath.row == 0)
        {
            dateLBL.text = @"Date";
            codeLBL.text = @"Code";
            pointLBL.text = @"Point";
        }
        else
        {
            dateLBL.text = (NSString *)[scanHistoryArray objectAtIndex:indexPath.row-1][@"date"];
            codeLBL.text = (NSString *)[scanHistoryArray objectAtIndex:indexPath.row-1][@"code"];
            pointLBL.text = (NSString *)[scanHistoryArray objectAtIndex:indexPath.row-1][@"code"];
        }

    }
    else if(selectedIndex == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TradingCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:19.f/255.0f blue:6.0f/255.0f alpha:1];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        
        UILabel *dateLBL = (UILabel*)[cell viewWithTag:TAG_TRADING_DATE];
        dateLBL.textColor = [UIColor darkGrayColor];
        
        
        UILabel *nameLBL = (UILabel*)[cell viewWithTag:TAG_TRADING_NAME];
        nameLBL.textColor = [UIColor darkGrayColor];
        
        UILabel *priceLBL = (UILabel*)[cell viewWithTag:TAG_TRADING_PRICE];
        priceLBL.textColor = [UIColor darkGrayColor];
        
        UILabel *quantityLBL = (UILabel*)[cell viewWithTag:TAG_TRADING_QUANTITY];
        quantityLBL.textColor = [UIColor darkGrayColor];
        
        if(indexPath.row == 0)
        {
            dateLBL.text = @"Date";
            nameLBL.text = @"Name";
            priceLBL.text = @"Price";
            quantityLBL.text = @"Quantity";
        }
        else
        {
            dateLBL.text = [tradingHistoryArray objectAtIndex:indexPath.row-1][@"date"];
            nameLBL.text = [tradingHistoryArray objectAtIndex:indexPath.row-1][@"name"];
            priceLBL.text = [tradingHistoryArray objectAtIndex:indexPath.row-1][@"market_price"];
            quantityLBL.text = [tradingHistoryArray objectAtIndex:indexPath.row-1][@"quantity"];
        }
    }
    else if(selectedIndex == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"RedemCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:19.f/255.0f blue:6.0f/255.0f alpha:1];
        }else{
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        
        
        UILabel *dateLBL = (UILabel*)[cell viewWithTag:TAG_REDEM_DATE];
        dateLBL.textColor = [UIColor darkGrayColor];
        
        
        UILabel *bm10LBL = (UILabel*)[cell viewWithTag:TAG_REDEM_BM10];
        bm10LBL.textColor = [UIColor darkGrayColor];
        
        UILabel *bm50LBL = (UILabel*)[cell viewWithTag:TAG_REDEM_BM50];
        bm50LBL.textColor = [UIColor darkGrayColor];
        
        if(indexPath.row == 0)
        {
            dateLBL.text = @"Date";
            bm10LBL.text = @"BM-10";
            bm50LBL.text = @"BM-50";
        }
        else
        {
            dateLBL.text = [redemHistoryArray objectAtIndex:indexPath.row-1][@"date"];
            bm10LBL.text = [redemHistoryArray objectAtIndex:indexPath.row-1][@"quantity_bm10"];
            bm50LBL.text = [redemHistoryArray objectAtIndex:indexPath.row-1][@"quantity_bm50"];
        }
    }
    
    return cell;
}

- (void)SegmentControlAction:(id)sender
{
    if(((UISegmentedControl *)sender).selectedSegmentIndex == 0)
    {
        NSLog(@"scan");
        selectedIndex = 0;
    }
    else if(((UISegmentedControl *)sender).selectedSegmentIndex == 1)
    {
        NSLog(@"Trading");
        selectedIndex = 1;
    }
    else if(((UISegmentedControl *)sender).selectedSegmentIndex == 2)
    {
        NSLog(@"Redemption");
        selectedIndex = 2;
    }
    [self.tableView reloadData];
}
@end
