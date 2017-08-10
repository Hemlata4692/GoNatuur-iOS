//
//  CMSPageViewController.m
//  GoNatuur
//
//  Created by Ranosys on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CMSPageViewController.h"

@interface CMSPageViewController ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CMSPageViewController
@synthesize isPrivacyPolicy;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializedView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View initialization
- (void)initializedView {
    
    self.navigationController.navigationBarHidden=false;
    //Set clear background color
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque=NO;
    //Set navigationBar background image
    UIImage *image = [UIImage imageNamed:@"navigation.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    //Set navigation back button
    [self addLeftBarButtonWithImage];
    [myDelegate showIndicator];
    
    NSString *htmlString;
    if (isPrivacyPolicy) {
        self.navigationItem.title=@"Privacy Policy";
        htmlString = @"<html><head></head><body><p>1. You agree that you will be the technician servicing this work order?.<br>2. You are comfortable with the scope of work on this work order?.<br>3. You understand that if you go to site and fail to do quality repair for  any reason, you will not be paid?.<br>4. You must dress business casual when going on the work order.</p></body></html>";
    }
    else {
        self.navigationItem.title=@"Terms & Conditions";
        htmlString = @"<html><head></head><body><p>1. You agree that you will be the technician servicing this work order?.<br>2. You are comfortable with the scope of work on this work order?.<br>3. You understand that if you go to site and fail to do quality repair for  any reason, you will not be paid?.<br>4. You must dress business casual when going on the work order.</p></body></html>";
    }
    [self.webView loadHTMLString: htmlString baseURL: nil];
}
#pragma mark - end

#pragma mark - Back button and side bar button
- (void)addLeftBarButtonWithImage {
    CGRect sideBarButtonFrame = CGRectMake(0, 0, 26, 26);
    UIButton *leftButton = [[UIButton alloc] initWithFrame:sideBarButtonFrame];
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems=[NSArray arrayWithObjects:leftBarButton, nil];
    [[leftButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - end

#pragma mark - IBActions
- (void)backButtonAction :(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    DLog(@"start value: %@",request.URL);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [myDelegate stopIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [myDelegate stopIndicator];
}
#pragma mark - end
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
