//
//  PrivateEvent.m
//  TransitionFun
//
//  Created by AnjDenny on 25/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "PrivateEvent.h"
#import <MessageUI/MessageUI.h>
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"

#import "DACollectionViewCell.h"
#import "DAPageControlView.h"

@interface PrivateEvent ()<DAPageControlViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UIView *topView;
    IBOutlet UIView *bottomView;
    
    IBOutlet UILabel *Phonelabel;
    IBOutlet UILabel *maillabel;
}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

//For Paging
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) DAPageControlView *pageControlView;
@property (assign, nonatomic) NSUInteger pagesCount;
@property (assign, nonatomic) BOOL loading;

@end

@implementation PrivateEvent

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
    } else {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:94.0/255.0 green:79.0/255.0 blue:47.0/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    
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
    label.text = NSLocalizedString(@"Private Events", @"");
    [label sizeToFit];
    
    //topView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.7];
    bottomView.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:166.0f/255.0f blue:121.0f/255.0f alpha:1];
    
    //Paging
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionViewLayout.minimumInteritemSpacing = collectionViewLayout.minimumLineSpacing = 0.;
    if (IS_IPAD) {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 761) collectionViewLayout:collectionViewLayout];
    }else{
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400) collectionViewLayout:collectionViewLayout];
    }
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.view sendSubviewToBack:self.collectionView];
    if (IS_IPAD) {
        [self.collectionView registerNib:[UINib nibWithNibName:@"DACollectionViewCell-iPad" bundle:nil] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    }else{
        [self.collectionView registerNib:[UINib nibWithNibName:@"DACollectionViewCell" bundle:nil] forCellWithReuseIdentifier:DACollectionViewCellIdentifier];
    }
    
    
    [self.view insertSubview:self.collectionView belowSubview:topView];
    [self.collectionView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    [self.collectionView reloadData];
    
    self.pagesCount = 7;
    if (IS_IPAD) {
        self.pageControlView = [[DAPageControlView alloc] initWithFrame:CGRectMake(280., 600., 240., 15.)];
    }else{
        self.pageControlView = [[DAPageControlView alloc] initWithFrame:CGRectMake(40., 300., 240., 15.)];
    }
    
    self.pageControlView.numberOfPages = self.pagesCount;
    self.pageControlView.currentPage = 0;
    self.pageControlView.delegate = self;
    [self.view addSubview:self.pageControlView];
    
    self.loading = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callDial)];
    [Phonelabel addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapMail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendMail)];
    [maillabel addGestureRecognizer:tapMail];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
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
}

- (void)callDial
{   
    
}

- (void)sendMail
{
    
}

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (IBAction)calling:(id)sender
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+(86)131-8083-6958"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (IBAction)emailing:(id)sender
{
    NSString *emailTitle = @"Beer Market";
    // Email Content
    NSString *messageBody = @"Dear, Beer Market Support.\n How are you?\n";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"hanschan1116@hotmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

#pragma mark - MFMailViewController
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            [[BMUtility sharedUtility] showMBAlert:self.view message:@"Mail Sent"];
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DACollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DACollectionViewCellIdentifier forIndexPath:indexPath];
    
    
    cell.itemImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", indexPath.row % 16]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.bounds.size;
}

#pragma mark - DAPageControlView Delegate

- (void)pageControlViewDidChangeCurrentPage:(DAPageControlView *)pageControlView
{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageControlView.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.pageControlView updateForScrollViewContentOffset:self.collectionView.contentOffset.x pageSize:CGRectGetWidth(self.collectionView.frame)];
}

@end
