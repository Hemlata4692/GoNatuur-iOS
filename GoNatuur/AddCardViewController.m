//
//  AddCardViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "AddCardViewController.h"
#import "UITextField+Padding.h"
#import "BSKeyboardControls.h"

@interface AddCardViewController ()<BSKeyboardControlsDelegate> {
    UITextField *currentSelectedTextField;
}
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;
@property (weak, nonatomic) IBOutlet UITextField *cardholderName;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) BSKeyboardControls *keyboardControls;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIWebView *addCardWebview;

@end

@implementation AddCardViewController

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
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"AddCard");
    [self addLeftBarButtonWithImage:true];
    [myDelegate showIndicator];
    [self loadAddCardRequest];
}

- (void)loadAddCardRequest {
    NSString *webViewString=[NSString stringWithFormat:@"%@%@/%@token=%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"creditcard/index/add/?",[UserDefaultManager getValue:@"Authorization"]];
    NSString *encodedString = [webViewString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *webViewURL = [NSURL URLWithString:encodedString];
    NSURLRequest *shareRequest=[NSURLRequest requestWithURL:webViewURL];
    [_addCardWebview loadRequest: shareRequest];
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:[NSString stringWithFormat:@"%@%@/%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"magedelight_cybersource/cards/listing/"]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];
    NSString *padding = @"document.body.style.padding='1px 1px 1px 1px'";
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
