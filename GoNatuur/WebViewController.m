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
    productDetaiData=@"<html><head><title>bvjeger erheru her rhre uh</title></head><body><p>hewufhreureu eru r r rerherh fer</p<img src='https://images.pexels.com/photos/34950/pexels-photo.jpg?h=350&auto=compress&cs=tinysrgb' /></body></html>";

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
    [_productDetailWebView loadHTMLString:productDetaiData baseURL: nil];
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
