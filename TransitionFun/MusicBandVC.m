//
//  MusicBandVC.m
//  TransitionFun
//
//  Created by AnjDenny on 22/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "MusicBandVC.h"

@interface MusicBandVC (){
    
    NSMutableDictionary *dataSource;
}

@end

@implementation MusicBandVC

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
    label.text = self.infoDic[@"name"];
    [label sizeToFit];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    tempImageView.image = [UIImage imageNamed:@"main_bg.png"];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    
    // Create a UIBarButtonItem
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:self action:@selector(backFromView)];
    
    // Associate the barButtonItem to the previous view
    [self.navigationController.navigationItem setBackBarButtonItem:barButtonItem];
    
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    dataSource = [[NSMutableDictionary alloc] initWithObjects:@[@"SubHeader",@"Monday",@"Tuesday",@"Wednesday",@"Friday"] forKeys:@[@"Description",@"Man United vs Liverpul",@"Jason",@"Liverpul vs Arsenal",@"Anson"]];
}

-(void)backFromView{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return ((NSDictionary *)self.infoDic[@"list"]).count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReuseCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.backgroundColor = [UIColor colorWithRed:22.0/255.0f green:19.f/255.0f blue:6.0f/255.0f alpha:1];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    
    UILabel *dayLBL = (UILabel*)[cell viewWithTag:100];
    dayLBL.textColor = [UIColor whiteColor];
    
    UILabel *descriptionLBL = (UILabel*)[cell viewWithTag:200];
    descriptionLBL.textColor = [UIColor whiteColor];
    
    if(indexPath.row == 0)
    {
        dayLBL.text = @"SubHeader";
        descriptionLBL.text = @"Description";
    }
    else
    {
        dayLBL.text = [self.infoDic[@"list"] objectAtIndex:indexPath.row-1][@"name"];
        descriptionLBL.text = [self.infoDic[@"list"] objectAtIndex:indexPath.row-1][@"desc"];
    }
    
    return cell;
}

@end
