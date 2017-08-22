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
@property (weak, nonatomic) IBOutlet UIView *shadowView;

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

    [_shadowView addShadow:_shadowView color:[UIColor darkGrayColor]];
    [myDelegate showIndicator];
   // [_productDetailWebView loadHTMLString:productDetaiData baseURL: nil];
    [_productDetailWebView loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#FFEDF1\" text=\"#5E5E5E\" align='justify' face=\"Montserrat-Medium\" size=\"5\">%@</body></html>", productDetaiData] baseURL: nil];
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
@end
