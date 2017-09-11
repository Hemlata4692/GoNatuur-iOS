//
//  WebPageViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 09/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "WebPageViewController.h"
#import "LoginModel.h"

@interface WebPageViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *aboutUsWebView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@end

@implementation WebPageViewController
@synthesize pageIdentifier;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _noDataLabel.hidden=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:false];
    _aboutUsWebView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
    _aboutUsWebView.opaque=NO;
    if ([pageIdentifier isEqualToString:@"AboutUs"]) {
        [myDelegate showIndicator];
        [self performSelector:@selector(CMSPageService:) withObject:@"about-us-block" afterDelay:.1];
    }
    else {
        [myDelegate showIndicator];
        [self performSelector:@selector(CMSPageService:) withObject:@"contact-us-block" afterDelay:.1];
    }
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
        _noDataLabel.text=NSLocalizedText(@"nodata");
        if ([userData.cmsContent isEqualToString:@""] || userData.cmsContent==nil) {
            _noDataLabel.hidden=NO;
            _aboutUsWebView.hidden=YES;
        }
        else {
            _noDataLabel.hidden=YES;
        [_aboutUsWebView loadHTMLString:[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; color:'#000000' text-align:'justify' font-size:15'>%@</body></html>", userData.cmsContent] baseURL: nil];
        }
        
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
