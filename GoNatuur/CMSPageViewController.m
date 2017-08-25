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

@property (weak, nonatomic) IBOutlet UIView *shadowView;

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
    
    [_shadowView addShadow:_shadowView color:[UIColor darkGrayColor]];
    //Set clear background color
    _webView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
    _webView.opaque=NO;
    //Set navigationBar background image
    [self setTransparentNavigtionBar];
    //Set navigation back button
    [self addLeftBarButtonWithImage];
    [myDelegate showIndicator];
    if (isPrivacyPolicy) {
        [self performSelector:@selector(CMSPageService:) withObject:@"privacy_policy" afterDelay:.1];
    }
    else {
        [self performSelector:@selector(CMSPageService:) withObject:@"terms_conditions" afterDelay:.1];
    }
}

//Make the navigation bar transparent and show only bar items.
- (void)setTransparentNavigtionBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
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
    NSString *padding = @"document.body.style.padding='5px 5px 5px 5px'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [myDelegate stopIndicator];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage")  closeButtonTitle:nil duration:0.0f];
}
#pragma mark - end

#pragma mark - Webservices
- (void)CMSPageService:(NSString *)cmsPageType {
    LoginModel *userLogin = [LoginModel sharedUser];
    userLogin.cmsPageType=cmsPageType;
    [userLogin CMSPageService:^(LoginModel *userData) {
        self.navigationItem.title=userData.cmsTitle;
     //   [_webView loadHTMLString:userData.cmsContent baseURL: nil];
        
        
        
//        userData.cmsContent = [NSString stringWithFormat:@"<span style=\"font-family: %@; background-color:\"#FDF4F6\" color:\"#000000\" text-align:\"justify\" font-size: %i\">%@</span>",@"Montserrat-Light", 15, userData.cmsContent];
        DLog(@"%@",[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; background-color:#FDF4F6 color:#000000 text-align:justify font-size:15'>%@</body></html>", userData.cmsContent]);
        [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; color:'#000000' text-align:'justify' font-size:15'>%@</body></html>", userData.cmsContent] baseURL: nil];
  
        
        
        
//        userData.cmsContent = [NSString stringWithFormat:@"<span style=\"font-family: %@; font-size: %i\">%@</span>",@"Montserrat-Light", 15, userData.cmsContent];
//        [_webView loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#FDF4F6\" text=\"#000000\" align='justify'>%@</body></html>", userData.cmsContent] baseURL: nil];
        } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
