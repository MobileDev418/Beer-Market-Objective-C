//
//  ReservationView.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "ReservationView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "BMDropDownMenu.h"
#import "VSDropdown.h"
#import "BMReservation.h"

#define TAG_DATE_BTN        10
#define TAG_PRODUCT         11

@interface ReservationView ()<UITextFieldDelegate,VSDropdownDelegate>
{
    
    NSMutableArray *dataSource;
    NSMutableArray *imageArr;
    
    UIDatePicker *dtPicker;
    UIToolbar *pickerToolbar;
    
    UITextField *locationInput;
    
    BMDropDownMenu *dropDownMenu;
    
    VSDropdown *_dropdown;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation ReservationView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    dropDownMenu = [[BMDropDownMenu alloc] init];
    
    _dropdown = [[VSDropdown alloc] initWithDelegate:self];
    _dropdown.backgroundColor = [UIColor darkTextColor];
    [_dropdown setAdoptParentTheme:YES];
    [_dropdown setShouldSortItems:NO];
    

    paxArray = [[NSMutableArray alloc] init];
    productList = [[NSMutableArray alloc] init];
    
    for(int i=0; i<30; i++)
    {
        [paxArray addObject:[NSString stringWithFormat:@"%d", i+1]];
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tempImageView.image = [UIImage imageNamed:@"main_bg.png"];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    dataSource = [[NSMutableArray alloc] initWithObjects:@"Name",@"Contact No",@"Email",@"Time",@"No. of Pax",@"Date",@"Show Products", @"Location",@"Remark", nil];
    imageArr = [[NSMutableArray alloc] initWithObjects:@"rUserName.png",@"rMobile.png",@"remail.png",@"rTime.png",@"rno_of_pax.png",@"rDate.png",@"rRemark.png", @"rLocation.png",@"rRemark.png", nil];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    }
    else
    {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
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
    label.text = NSLocalizedString(@"Reservations", @"");
    [label sizeToFit];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"DONE" forState:UIControlStateNormal];
    if (IS_IPAD)
    {
        doneBtn.frame = CGRectMake(20, 644, self.view.frame.size.width - 40 , 50);
    }
    else if (IS_IPHONE_5)
    {
        doneBtn.frame = CGRectMake(20, 444, self.view.frame.size.width - 40 , 50);
    }
    else
    {
        doneBtn.frame = CGRectMake(20, 420, self.view.frame.size.width - 40 , 50);
    }
    
    doneBtn.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:12.0f/255.0f blue:7.0f/255.0f alpha:1];
    [doneBtn addTarget:self action:@selector(requestReservation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, 444);
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
- (void) loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [[BMServer sharedInstance] getTimeSlots:^(NSDictionary *response){
            
            NSLog(@"------- 타임 슬롯 -------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                timeArray = [NSArray arrayWithArray:response[@"times"]];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
        }];
        
        [[BMServer sharedInstance] getDateSlots:^(NSDictionary *response){
            
            NSLog(@"------- 날자 슬롯 -------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                dateArray = [NSArray arrayWithArray:response[@"dates"]];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
        }];
        
        
        [[BMServer sharedInstance] getLocation:^(NSDictionary *response){
            
            [[BMUtility sharedUtility] hideMBProgress];
            NSLog(@"------- 로케션 슬롯 -------\n%@", response);
            if([response[@"status"] isEqualToString:@"success"])
            {
                locationArray = [NSArray arrayWithArray:response[@"items"]];
            }
        }failure:^(AFHTTPRequestOperation *operation){
            
        }];
        
    });
}

- (void) loadProductBalance
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:2 inSection:1];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    UITextField *textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_date = textV.text;
    
    if(r_date.length == 0)
        return;
    
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    [[BMServer sharedInstance] getAvailableProducts:r_date
                                            success:^(NSDictionary *response){
                                                
                                                [[BMUtility sharedUtility] hideMBProgress];
                                                NSLog(@"----------가능한 제품목록앋기 응답---------\n%@", response);
                                                if([response[@"status"] isEqualToString:@"success"])
                                                {
                                                    if(productArray)
                                                        productArray = nil;
                                                    productArray = [NSArray arrayWithArray:response[@"items"]];
                                                    for(NSDictionary *item in response[@"items"])
                                                    {
                                                        NSString *productName = item[@"name"];
                                                        NSString *productQuantity = item[@"quantity"];
                                                        
                                                        NSString *listItem = [NSString stringWithFormat:@"%@%@%@", productName, [self getBlankString:(25-(int)productName.length)], productQuantity];
                                                        
                                                        [productList addObject:listItem];
                                                    }
                                                }
                                                
                                            }failure:^(AFHTTPRequestOperation *operation){
                                                [[BMUtility sharedUtility] hideMBProgress];
                                                [[BMUtility sharedUtility] showAlert:@"Reservation" message:operation.error.description];
    
    }];
}

- (void) requestReservation
{
    NSIndexPath *index = nil;
    UITableViewCell *cell = nil;
    UITextField *textV = nil;
    
    index = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_name = textV.text;
    
    index = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_contactNo = textV.text;

    index = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_email = textV.text;

    index = [NSIndexPath indexPathForRow:0 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_time = textV.text;
    
    index = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_pax = textV.text;

    index = [NSIndexPath indexPathForRow:2 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_date = textV.text;

    index = [NSIndexPath indexPathForRow:4 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_location = textV.text;

    index = [NSIndexPath indexPathForRow:5 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *r_remark = textV.text;
    
    if(r_name.length == 0)
    {
       [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter name"];
        return;
    }
    if(r_contactNo.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter contact no"];
        return;
    }
    if(r_email.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter email"];
        return;
    }
    if(r_time.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter time"];
        return;
    }
    if(r_pax.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter pax"];
        return;
    }
    if(r_date.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter date"];
        return;
    }
    if(r_location.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter location"];
        return;
    }
    if(r_remark.length == 0)
    {
        [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"please enter remark"];
        return;
    }

    if(![self isAvailablePax:r_pax.intValue])
    {
       [[BMUtility sharedUtility] showAlert:@"Reservation" message:@"No.of Pax can't be greater than available products quantity"];
        return;
    }
    
    NSDictionary *req_dict = @{
                               @"user_id":[BMUser sharedUser].user_id,
                               @"name":r_name,
                               @"contact_no":r_contactNo,
                               @"email":r_email,
                               @"time":r_time,
                               @"pax_quantity":r_pax,
                               @"date":r_date,
                               @"location":r_location,
                               @"remarks":r_remark
                               };
    
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading..."];
    
    [[BMServer sharedInstance] makeReservation:req_dict
      success:^(NSDictionary *response){
          
          [[BMUtility sharedUtility] hideMBProgress];
          
          NSLog(@"------------Reservation 만들기 응답-------------\n%@", response);
          if([response[@"status"] isEqualToString:@"success"])
          {
              [[BMUtility sharedUtility] showMBAlert:self.view message:@"Success"];
              [self removeTextField];
              /*
              BMReservation *reservation = [BMReservation sharedReservation];
              reservation.reservation_id = response[@"reservation_id"];
              reservation.name = response[@"name"];
              reservation.contactNumber = response[@"contact_no"];
              reservation.email = response[@"email"];
              reservation.time = response[@"time"];
              reservation.pax_quantity = ((NSString *)response[@"pax_quantity"]).intValue;
              reservation.date = response[@"date"];
              reservation.location = response[@"location"];
              reservation.remarks = response[@"remarks"];
               */
          }
      }failure:^(AFHTTPRequestOperation *operation){
          
          [[BMUtility sharedUtility] hideMBProgress];
          [[BMUtility sharedUtility] showAlert:@"Reservation" message:operation.error.description];
    }];
    
}

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return 6;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:14];
    if (section == 0)
    {
        myLabel.text = @"USER INFO";
    }
    else
    {
        myLabel.text = @"RESERVATION";
    }
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor clearColor];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCell" forIndexPath:indexPath];
        
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:100];
    if (indexPath.section == 0)
    {
        imgView.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]];
    }
    else
    {
        imgView.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row + 3]];
    }
    
    
    UITextField *dateLBL = (UITextField*)[cell viewWithTag:200];
    dateLBL.delegate = self;
    dateLBL.textColor = [UIColor darkTextColor];
    if (indexPath.section == 0)
    {
        dateLBL.placeholder = [dataSource objectAtIndex:indexPath.row];
    }
    else
    {
        if (indexPath.row == 2)//date
        {
            UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dateButton addTarget:self action:@selector(dateDropDown:) forControlEvents:UIControlEventTouchUpInside];
            dateButton.frame = dateLBL.frame;
            dateButton.titleLabel.textColor = [UIColor whiteColor];
            dateButton.tag = TAG_DATE_BTN;
            [cell.contentView addSubview:dateButton];
        }
        
        if (indexPath.row == 1)//pax
        {
            UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dateButton addTarget:self action:@selector(paxDropDown:) forControlEvents:UIControlEventTouchUpInside];
            dateButton.frame = dateLBL.frame;
            dateButton.titleLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:dateButton];
        }
        
        if (indexPath.row == 0)//time
        {
            UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dateButton addTarget:self action:@selector(timeDropDown:) forControlEvents:UIControlEventTouchUpInside];
            dateButton.frame = dateLBL.frame;
            dateButton.titleLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:dateButton];
        }
        
        if (indexPath.row == 3)//products
        {
            UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dateButton addTarget:self action:@selector(productsDropDown:) forControlEvents:UIControlEventTouchUpInside];
            dateButton.frame = dateLBL.frame;
            dateButton.titleLabel.textColor = [UIColor whiteColor];
            dateButton.tag = TAG_PRODUCT;
            [cell.contentView addSubview:dateButton];
        }
        
        if (indexPath.row == 4)//location
        {
            UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dateButton addTarget:self action:@selector(locationDropDown:) forControlEvents:UIControlEventTouchUpInside];
            dateButton.frame = dateLBL.frame;
            dateButton.titleLabel.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:dateButton];
        }
        
        dateLBL.placeholder = [dataSource objectAtIndex:indexPath.row + 3];
        
        
    }
    [self.tableView setContentSize:CGSizeMake(self.view.frame.size.width, 480)];
    
    return cell;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void)showDropDownForButton:(UIButton *)sender adContents:(NSArray *)contents
{
    [_dropdown setDrodownAnimation:rand()%2];
    
    [_dropdown setupDropdownForView:sender];
    
    [_dropdown reloadDropdownWithContents:contents andSelectedString:((UITextField *)[sender.superview viewWithTag:200]).text];
}


- (void)dropdown:(VSDropdown *)dropDown didSelectValue:(NSString *)str atIndex:(NSUInteger)index
{
    if ([dropDown.dropDownView isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)dropDown.dropDownView;
        if(btn.tag != TAG_PRODUCT)
        {
            UITextField *tf = (UITextField *)[btn.superview viewWithTag:200];
            tf.text = str;
        }
        
        if(btn.tag == TAG_DATE_BTN)
        {
            [self loadProductBalance];
        }
    }
    
}

- (void)dateDropDown:(id)sender
{
    [self showDropDownForButton:sender adContents:dateArray];
    
}

- (void)paxDropDown:(id)sender
{
    [self showDropDownForButton:sender adContents:paxArray];
    
}

- (void)timeDropDown:(id)sender
{
    [self showDropDownForButton:sender adContents:timeArray];
    
}

- (void)locationDropDown:(id)sender
{
    [self showDropDownForButton:sender adContents:@[@"USA",@"AUS",@"NZ",@"IND",@"SA",@"SWD"]];
    
}

- (void)productsDropDown:(id)sender
{
    [self showDropDownForButton:sender adContents:productList];
}

#pragma mark - Utility
- (NSString *)getBlankString:(int)length
{
    NSMutableString *value = [[NSMutableString alloc] init];
    for(int i = 0;i<length;i++)
    {
        [value appendString:@" "];
    }
    
    return value;
}

- (BOOL) isAvailablePax:(int)count
{
    BOOL value = YES;
    
    for(NSDictionary *item in productArray)
    {
        int quantity = ((NSString *)(item[@"quantity"])).intValue;
        if(count > quantity)
            value = NO;
    }
    
    return value;
}

- (void) removeTextField
{
    
}

@end
