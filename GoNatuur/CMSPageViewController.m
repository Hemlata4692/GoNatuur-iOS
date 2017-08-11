//
//  CMSPageViewController.m
//  GoNatuur
//
//  Created by Ranosys on 09/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CMSPageViewController.h"
#import "LoginModel.h"

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
    if (isPrivacyPolicy) {
        [self performSelector:@selector(CMSPageService:) withObject:[NSNumber numberWithInt:4] afterDelay:.1];
    }
    else {
        [self performSelector:@selector(CMSPageService:) withObject:[NSNumber numberWithInt:6] afterDelay:.1];
    }
}
#pragma mark - end

#pragma mark - Back button and side bar button
- (void)addLeftBarButtonWithImage {
    CGRect sideBarButtonFrame = CGRectMake(0, 0, 22, 22);
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
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [myDelegate stopIndicator];
}
#pragma mark - end

#pragma mark - Webservices
- (void)CMSPageService:(NSNumber *)cmsPageType {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.cmsPageType=cmsPageType;
    [userLogin CMSPageService:^(LoginModel *userData) {
        self.navigationItem.title=userData.cmsTitle;
        [self.webView loadHTMLString:userData.cmsContent baseURL: nil];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
