//
//  PTProfileView.m
//  TransitionFun
//
//  Created by AnjDenny on 25/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "PTProfileView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "RadioButton.h"


@interface PTProfileView ()<UITextFieldDelegate>{
    
    NSMutableArray *dataSource;
    NSMutableArray *genderArr;
    
    UIDatePicker *birthPicker;
    UIPickerView *genderPicker;
    UIToolbar *pickerToolBar;
    
    BOOL isLoaded;
    
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;


@end

@implementation PTProfileView

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
    
    [[BMUtility sharedUtility] printTimeStamp];
    isLoaded = NO;
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"main_bg.png"]];
    
    dataSource = [[NSMutableArray alloc] initWithObjects:@"User ID",@"First Name",@"Last Name",@"Address",@"Email",@"Mobile No",@"Date of birth",@"Gender",@"Old Password",@"New Password",@"Confirm", nil];
    
    genderArr = [[NSMutableArray alloc] initWithObjects:@"Male",@"Female", nil];
    
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
    label.text = NSLocalizedString(@"My Profile", @"");
    [label sizeToFit];
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"LOG OUT" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(20, self.view.frame.size.height + 75, self.view.frame.size.width - 40 , 50);
    doneBtn.backgroundColor = [UIColor colorWithRed:15.0f/255.0f green:12.0f/255.0f blue:7.0f/255.0f alpha:1];
    [doneBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];
    
    [self loadUserProfile];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
    else
    {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
}

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void) logOut
{
    [[BMUser sharedUser] forgetUser];
    self.slidingViewController.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PTLoginSignup"];
}

#pragma mark - BMServer
- (void) loadUserProfile
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Get profile.."];
    
    [[BMServer sharedInstance] getUserProfile:[BMUser sharedUser].user_id
                                      success:^(NSDictionary *response){
                                          
                                          [[BMUtility sharedUtility] hideMBProgress];
                                          NSLog(@"----------사용자 프로필 얻기--------\n%@", response);
                                          [[BMUser sharedUser] updateUser:response success:^(bool isSuccess)
                                           {
                                               [self.tableView reloadData];
                                           }];
                                          m_pUser = [BMUser sharedUser];
                                          
                                      }failure:^(AFHTTPRequestOperation *operation){
                                          [[BMUtility sharedUtility] hideMBProgress];
                                      }
     ];
}

- (IBAction)onUpdateProfile:(id)sender
{
    NSIndexPath *index = nil;
    UITableViewCell *cell = nil;
    UITextField *textV = nil;
    
    index = [NSIndexPath indexPathForRow:8 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *oldPassword = textV.text;
    
    index = [NSIndexPath indexPathForRow:9 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *newPassword = textV.text;
    
    index = [NSIndexPath indexPathForRow:10 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *confirm = textV.text;
    
    index = [NSIndexPath indexPathForRow:0 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_userName = textV.text;
    
    index = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_firstName = textV.text;
    
    index = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_lastName = textV.text;
    
    index = [NSIndexPath indexPathForRow:3 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_address = textV.text;
    
    index = [NSIndexPath indexPathForRow:4 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_email = textV.text;
    
    index = [NSIndexPath indexPathForRow:5 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_mobileNumber = textV.text;
    
    index = [NSIndexPath indexPathForRow:6 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    textV = (UITextField*)[cell viewWithTag:200];
    NSString *t_birthday = textV.text;
    
    index = [NSIndexPath indexPathForRow:7 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:index];
    RadioButton *gender = (RadioButton*)[cell viewWithTag:200];
    BMGender t_gender = (gender.selected) ? kMale : kFemale;
    
    
    NSLog(@"-----password: %@", [BMUser sharedUser].password);
    
    if(![oldPassword isEqualToString:[BMUser sharedUser].password])
    {
        [[BMUtility sharedUtility] showAlert:@"Profile" message:@"Old password is wrong"];
        return;
    }
    if(![newPassword isEqualToString:confirm])
    {
        [[BMUtility sharedUtility] showAlert:@"Profile" message:@"Password is not match with confirming"];
        return;
    }
    
    if([t_userName isEqualToString:@""] || [t_firstName isEqualToString:@""] || [t_lastName isEqualToString:@""] || [t_address isEqualToString:@""] || [t_email isEqualToString:@""] || [t_mobileNumber isEqualToString:@""] || [t_birthday isEqualToString:@""] || [oldPassword isEqualToString:@""] || [newPassword isEqualToString:@""] || [confirm isEqualToString:@""])
    {
        [[BMUtility sharedUtility] showAlert:@"Profile" message:@"Please fill all data field"];
    }
    
    BMUser *user = [BMUser sharedUser];
    user.userName = t_userName;
    user.firstName = t_firstName;
    user.lastName = t_lastName;
    user.address = t_address;
    user.email = t_email;
    user.mobileNumber = t_mobileNumber;
    user.birthday = t_birthday;
    user.gender = t_gender;
    user.password = newPassword;
    
    [[BMServer sharedInstance] modifyProfile:user
                                     success:^(NSDictionary *response){
                                         
                                         NSLog(@"------- 사용자 프로필 갱신 응답 ------%@", response);
                                         
                                     }failure:^(AFHTTPRequestOperation *operation){
                                         
                                     }
     ];
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
    return dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if(indexPath.row == 7)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GenderCell" forIndexPath:indexPath];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCell" forIndexPath:indexPath];
    }
    
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *labelV = (UILabel*)[cell viewWithTag:100];
    labelV.textColor = [UIColor lightTextColor];
    labelV.text = [dataSource objectAtIndex:indexPath.row];
    
    if(indexPath.row == 7)
    {
        RadioButton *gender = (RadioButton *)[cell viewWithTag:200];
        gender.selected = ([BMUser sharedUser].gender == kMale) ? YES : NO;
    }
    else
    {
        UITextField *textV = (UITextField*)[cell viewWithTag:200];
        textV.delegate = self;
        textV.textColor = [UIColor darkTextColor];
        //textV.text = [dataSource objectAtIndex:indexPath.row];
        if(indexPath.row == 0)
        {
            textV.text = m_pUser.userName;
        }
        else if(indexPath.row == 1)
        {
            textV.text = m_pUser.firstName;
        }
        else if(indexPath.row == 2)
        {
            textV.text = m_pUser.lastName;
        }
        else if(indexPath.row == 3)
        {
            textV.text = m_pUser.address;
        }
        else if(indexPath.row == 4)
        {
            textV.text = m_pUser.email;
        }
        else if(indexPath.row == 5)
        {
            textV.text = m_pUser.mobileNumber;
        }
        else if(indexPath.row == 6)
        {
            textV.text = m_pUser.birthday;
        }
        else if(indexPath.row == 8)
        {
            textV.text = @"";
            textV.secureTextEntry = YES;
        }
        else if(indexPath.row == 9)
        {
            textV.text = @"";
            textV.secureTextEntry = YES;
        }
        else if(indexPath.row == 10)
        {
            textV.text = @"";
            textV.secureTextEntry = YES;
        }
    }
    
    [self.tableView setContentSize:CGSizeMake(self.view.frame.size.width, 700)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
//    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row)
//    {
//        [[BMUtility sharedUtility] printTimeStamp];//쎌의 마지막 display사건을 잡습니다.
//        if(!isLoaded)
//        {
//            [self loadUserProfile];
//            isLoaded = YES;
//        }
//    }
}

#pragma mark - TextField Delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if(indexPath.row == 6)//birthday
    {
        [self showBirthdayPicker];
    }
}

- (void) showBirthdayPicker
{
    //Datepicker
    birthPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300 +20, self.view.frame.size.width, 300)];
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    // if (dateStatus==0) {
    birthPicker.datePickerMode = UIDatePickerModeDate;
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    birthPicker.maximumDate = [NSDate date];
    birthPicker.backgroundColor = [UIColor lightTextColor];
    birthPicker.date = [NSDate date];
    
    //[birthPicker addTarget:self action:@selector(LabelChange:) forControlEvents:UIControlEventValueChanged];
    
    pickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 330 + 20, self.view.frame.size.width, 30)];
    pickerToolBar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolBar sizeToFit];
    pickerToolBar.hidden = YES;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *btnCancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(birthdayCancelButtonPressed:)];
    [barItems addObject:btnCancel];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(birthdayDoneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd-MM-yyyy";
    
    [pickerToolBar setItems:barItems animated:YES];
    
    [self.view addSubview:pickerToolBar];
    [self.view addSubview:birthPicker];
    
    pickerToolBar.hidden = NO;
    birthPicker.hidden = NO;
}

- (void) birthdayCancelButtonPressed:(id)sender
{
    
}

- (void) birthdayDoneButtonPressed:(id)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:6 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
    UITextField *textV = (UITextField*)[cell viewWithTag:200];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    textV.text=[NSString stringWithFormat:@"%@",[format stringFromDate:birthPicker.date]];
    
    pickerToolBar.hidden = YES;
    birthPicker.hidden = YES;
}

@end
