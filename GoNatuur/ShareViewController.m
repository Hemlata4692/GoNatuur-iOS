//
//  ShareViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareDataModel.h"
@import SafariServices;

static NSString *JSHandler;
#define CocoaJSHandler          @"mpajaxHandler"

@interface ShareViewController ()<SFSafariViewControllerDelegate> {
    @private
    NSString *loadURL;
}
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UILabel *shareTextLabel;
@property (weak, nonatomic) IBOutlet UIWebView *shareWebView;
@end

@implementation ShareViewController
@synthesize shareURL;
@synthesize mediaURL;
@synthesize name;
@synthesize productDescription;
@synthesize shareType;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainView.hidden=YES;
    [_shareView setCornerRadius:2.0];
    _shareTextLabel.text=NSLocalizedText(@"shareText");
    self.view.backgroundColor=[UIColor whiteColor];

    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(dismissNewsView:)];
    [_mainView addGestureRecognizer:singleFingerTap];
     JSHandler = [NSString stringWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"ajax_handler" withExtension:@"js"] encoding:NSUTF8StringEncoding error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"shareText");
    [self addLeftBarButtonWithImage:true];
    [self loadShareRequestURL];
}

- (void)loadShareRequestURL {
    [myDelegate showIndicator];
    NSString *customerToken=[UserDefaultManager getValue:@"Authorization"];
    if ([[UserDefaultManager getValue:@"Authorization"] isEqualToString:@""] || [UserDefaultManager getValue:@"Authorization"]==nil || [UserDefaultManager getValue:@"Authorization"]==NULL) {
        customerToken=@"";
    }
    NSString *webViewString=[NSString stringWithFormat:@"%@%@/%@url=%@&media=%@&name=%@&description=%@&token=%@&sharedpoint-nap=%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"socailsharing/product/share/?",shareURL,mediaURL,name,productDescription,customerToken,shareType];
//   // NSString *webViewString=@"https://in.pinterest.com/pin/create/button/?url=https%3A%2F%2Fdev.gonatuur.com%2Fen%2Fhappy-yak-milk.html%3Fproduct_id%3D26&media=https%3A%2F%2Fdev.gonatuur.com%2Fmedia%2Fcatalog%2Fproduct%2Fy%2Fa%2Fyak-milk_1.jpg&description=Protein%20rich";
    NSString *encodedString = [webViewString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *webViewURL = [NSURL URLWithString:encodedString];
    NSURLRequest *shareRequest=[NSURLRequest requestWithURL:webViewURL];
   [_shareWebView loadRequest: shareRequest];
   
//        SFSafariViewController *safariVC = [[SFSafariViewController alloc]initWithURL:webViewURL entersReaderIfAvailable:YES];
//        safariVC.delegate = self;
//        [self presentViewController:safariVC animated:NO completion:nil];
}
#pragma mark - end

#pragma mark - Webview delegates
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:JSHandler];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //https://service.t.sina.com.cn/widget/jssdk/aj_addmblog.php - weibo error url
    NSLog(@"%@",request);
    NSLog(@"%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    loadURL=[request.URL absoluteString];
    NSLog(@"loadURL %@",loadURL);
    
    
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    //NSLog(requestString);
    
    if ([requestString hasPrefix:@"ios-log:"]) {
        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
    
    
    if ([loadURL containsString:@"weixin://"]) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:loadURL]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loadURL]];
        }
        else {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:@"Please install wechat app to share"  closeButtonTitle:nil duration:0.0f];
        }
    }
    else if ([loadURL containsString:@"resource/BoardResource/get/"]) {
        [self loadShareRequestURL];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"loading comleted");
    if (webView.isLoading)
        return;
    else {
        [myDelegate stopIndicator];
        if ([loadURL isEqualToString:@"https://m.facebook.com/v2.10/dialog/share/submit"] || [loadURL containsString:@"https://twitter.com/intent/tweet/complete"] || [loadURL containsString:@"resource/BoardResource/get/"]) {
            [self loadShareRequestURL];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error----- %@",error.localizedDescription);
    if ([error code] != NSURLErrorCancelled) {
        //show error alert, etc.
        [myDelegate stopIndicator];
//        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:error.localizedDescription  closeButtonTitle:nil duration:0.0f];
    }
}
#pragma mark - end

#pragma mark - Dismiss view
//The event handling method
- (void)dismissNewsView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - end
@end
