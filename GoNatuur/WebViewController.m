//
//  WebViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *productDetailWebView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@end

@implementation WebViewController
@synthesize navigationTitle;
@synthesize productDetaiData;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=navigationTitle;
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    _productDetailWebView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
    _productDetailWebView.opaque=NO;
    if ([productDetaiData isEqualToString:@""] || productDetaiData==nil) {
        _noDataLabel.hidden=NO;
        _productDetailWebView.hidden=YES;
    }
    else {
        _noDataLabel.hidden=YES;
        [myDelegate showIndicator];
        if ([navigationTitle isEqualToString:NSLocalizedText(@"Where to buy")]) {
            [_productDetailWebView loadHTMLString:[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; color:'#000000' text-align:'%@' font-size:15'>%@</body></html>",@"left", productDetaiData] baseURL: nil];
        }
        else {
            [_productDetailWebView loadHTMLString:[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; color:'#000000' text-align:'%@' font-size:15'>%@</body></html>",@"justify", productDetaiData] baseURL: nil];
        }
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
@end
