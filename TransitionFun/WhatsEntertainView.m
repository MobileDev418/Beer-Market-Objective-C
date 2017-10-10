//
//  WhatsEntertainView.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "WhatsEntertainView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MusicBandVC.h"

@interface WhatsEntertainView (){
    
    NSArray *dataSource;
    NSArray *entertainmentData;
    int selectedRow;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation WhatsEntertainView

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
    
    dataSource = [[NSArray alloc] initWithObjects:@"Music Band",@"EPL", nil];
    
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
    label.text = NSLocalizedString(@"What's Entertains ?", @"");
    [label sizeToFit];
    
    //[self loadEntertainmentData];
    
    entertainmentData = @[
                          @{
                              @"name": @"entertainment_1",
                              @"list":@[
                                      @{
                                          @"name":@"Monday",
                                          @"desc":@"enjoy_monday"
                                          },
                                      @{
                                          @"name":@"Testing",
                                          @"desc":@"Hans"
                                          },
                                      @{
                                          @"name":@"Owner",
                                          @"desc":@"Graythong"
                                          }
                                      ]
                              },
                          @{
                              @"name": @"entertainment_2",
                              @"list":@[
                                      @{
                                          @"name":@"Tuesday",
                                          @"desc":@"enjoy_tuesday"
                                          }
                                      ]
                              },
                          @{
                              @"name": @"entertainment_3",
                              @"list":@[
                                      @{
                                          @"name":@"Wensday",
                                          @"desc":@"enjoy_wensday"
                                          }
                                      ]
                              },
                          @{
                              @"name": @"entertainment_4",
                              @"list":@[
                                      @{
                                          @"name":@"Thursday",
                                          @"desc":@"enjoy_thursday"
                                          }
                                      ]
                              }
                          ];
}

# pragma mark - BMServer
- (void) loadEntertainmentData
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading"];
    
    [[BMServer sharedInstance] getEntertainmentList:[BMUser sharedUser].user_id
                                success:^(NSDictionary *response){
                                    
                                    
                                    NSLog(@"----------Entertainment응답-----------%@", response);
                                    if([response[@"status"] isEqualToString:@"success"])
                                    {
                                       // entertainmentData = [NSArray arrayWithArray:response[@"items"]];
                                        
                                        [self.tableView reloadData];
                                    }
                                    
                                }failure:^(AFHTTPRequestOperation *operation){
                                    [[BMUtility sharedUtility] hideMBProgress];
                                    [[BMUtility sharedUtility] showAlert:@"Entertainment" message:operation.error.description];
    }];
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
    } else {
        [self.navigationController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
        [self.navigationController.view addGestureRecognizer:self.slidingViewController.panGesture];
    }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return entertainmentData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCell" forIndexPath:indexPath];
    
    
    // Configure the cell...
    cell.textLabel.text = [entertainmentData objectAtIndex:indexPath.row][@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:23.0f/255.0f green:21.0f/255.0f blue:15.0f/255.0f alpha:1];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = (int)indexPath.row;
    [self performSegueWithIdentifier:@"SubEntertainment" sender:self];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SubEntertainment"])
    {
        MusicBandVC *vc = (MusicBandVC *)segue.destinationViewController;
        vc.infoDic = [NSDictionary dictionaryWithDictionary:[entertainmentData objectAtIndex:selectedRow]];
    }
}

@end
