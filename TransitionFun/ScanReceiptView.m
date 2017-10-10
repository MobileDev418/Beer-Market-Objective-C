//
//  ScanReceiptView.m
//  TransitionFun
//
//  Created by AnjDenny on 21/03/15.
//  Copyright (c) 2015 Mike Enriquez. All rights reserved.
//

#import "ScanReceiptView.h"
#import "MEDynamicTransition.h"
#import "UIViewController+ECSlidingViewController.h"
#import "ZBarSDK.h"

#define kSuccess        @"SUCCESS"
#define kNot            @"NOT"
#define kUsed           @"USED"

@interface ScanReceiptView ()
{
    ZBarImageScanner    *scanner;
    ZBarReaderView      *qrview;

}
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) IBOutlet UIImageView      *qrFrameImageView;
@property (nonatomic, strong) IBOutlet UITextField      *tfQRCode;
@property (nonatomic, strong) IBOutlet UIView           *qrCodeView;
@end

@implementation ScanReceiptView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

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

    [self createScanner];
    [self createQRView];
    //[self setupPositionAndSize];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([(NSObject *)self.slidingViewController.delegate isKindOfClass:[MEDynamicTransition class]]) {
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
    
    [qrview start];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [qrview stop];
    [super viewWillDisappear:animated];
}

#pragma mark - ZBarReaderViewDelegate
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols)
        break;
    
    
    self.qrFrameImageView.image = [UIImage imageNamed:@"qr_code_frame_select.png"];
    
    NSString *qrcodeText = symbol.data;

    NSLog(@"------qr 코드 스캔 결과입니다.------\n%@", qrcodeText);
    self.tfQRCode.text = qrcodeText;
    [qrview stop];
    [self requestScanResult];
    
    //self.qrFrameImageView.image = [UIImage imageNamed:@"qr_code_frame"];
}



#pragma mark - QRView
- (void)createScanner
{
    scanner = [ZBarImageScanner new];
    [scanner setSymbology:0 config:ZBAR_CFG_X_DENSITY to:3];
    [scanner setSymbology:0 config:ZBAR_CFG_Y_DENSITY to:3];
    
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
}

- (void)createQRView
{
    qrview = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    qrview.readerDelegate = self;
    qrview.scanCrop = CGRectMake(0, 0, 1, 1);
    qrview.previewTransform = CGAffineTransformIdentity;
    qrview.tracksSymbols = YES;
    qrview.enableCache = YES;
    qrview.torchMode = 0; // 플래쉬를 사용하지 않는다.
    qrview.allowsPinchZoom = NO;
    qrview.frame = self.qrCodeView.frame;
    
    
    
    //    [self.view addSubview:_qrview];
    [self.qrCodeView insertSubview:qrview belowSubview:self.qrFrameImageView];
}

-(void)setupPositionAndSize
{
    if ([[BMUtility sharedUtility] isFourInchiScreen] == YES)
    {
    }
    else
    {
        [self moveToPositionYPixel:90 + 115 Control:self.qrFrameImageView];
    }
}

-(void)moveToPositionYPixel:(CGFloat)moveY Control:(UIView*)control
{
    CGRect frame = control.frame;
    frame.origin.y = moveY/2;
    control.frame = frame;
}



#pragma mark - IBActions

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - BMServer
- (void) requestScanResult
{
    [[BMUtility sharedUtility] showMBProgress:self.view message:@"Loading.."];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"MM/dd/yyyy";
    NSString *date =[NSString stringWithFormat:@"%@",[format stringFromDate:[NSDate date]]];
    
    NSString *user_id = [BMUser sharedUser].user_id;
    
    NSString * code = self.tfQRCode.text;
    
    NSDictionary *req_dict = @{
                               @"user_id":user_id,
                               @"code":code,
                               @"date":date
                               };
    [[BMServer sharedInstance] scanQRCode:req_dict
                                  success:^(NSDictionary *response){
                                      
                                      [[BMUtility sharedUtility] hideMBProgress];
                                      NSLog(@"--------QR스캔 응답입니다.----------\n%@",response);
                                      if([response[@"status"] isEqualToString:@"success"])
                                      {
                                          if([response[@"result"] isEqualToString:kSuccess])
                                          {
                                              [[BMUtility sharedUtility] showMBAlert:self.view message:@"Success"];
                                          }
                                          else if([response[@"result"] isEqualToString:kNot])
                                          {
                                              [[BMUtility sharedUtility] showMBAlert:self.view message:@"Not"];
                                          }
                                          else if([response[@"result"] isEqualToString:kUsed])
                                          {
                                              [[BMUtility sharedUtility] showMBAlert:self.view message:@"Used"];
                                          }
                                          
                                          self.qrFrameImageView.image = [UIImage imageNamed:@"qr_code_frame"];
                                          [qrview start];
                                      }
                                  }failure:^(AFHTTPRequestOperation *operation){
    
    }];
    
}

@end
