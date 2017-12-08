//
//  PaymentWebViewController.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 28/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "PaymentWebViewController.h"
#import "ThankYouViewController.h"

@interface PaymentWebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *paymentWebView;

@end

@implementation PaymentWebViewController
@synthesize paymentMethod,cartListDataArray,finalCheckoutPriceDict,isSubscriptionProduct;

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
    _paymentWebView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
    _paymentWebView.opaque=NO;
    self.navigationItem.title=NSLocalizedText(@"makePayment");
    [myDelegate showIndicator];
    NSString *paymentString;
    //paypal_subscription
    
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        if ([isSubscriptionProduct isEqualToString:@"1"]) {
            paymentMethod=@"paypal_subscription";
        }
        paymentString = [NSString stringWithFormat:@"%@en/paymentview?quoteid=%@&paywith=%@",BaseUrl,[UserDefaultManager getValue:@"quoteId"],paymentMethod];
    } else {
        if ([isSubscriptionProduct isEqualToString:@"1"]) {
            paymentMethod=@"paypal_subscription";
        }
        paymentString = [NSString stringWithFormat:@"%@en/paymentview?token=%@&paywith=%@",BaseUrl,[UserDefaultManager getValue:@"Authorization"],paymentMethod];
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:paymentString]];
    //Load the request in the UIWebView.
    [_paymentWebView loadRequest:requestObj];}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if ([[request.URL absoluteString] isEqualToString:@"https://dev.gonatuur.com/en/checkout/onepage/success/"]) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ThankYouViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
        nextView.cartListDataArray = cartListDataArray;
        nextView.finalCheckoutPriceDict=finalCheckoutPriceDict;
        [self.navigationController pushViewController:nextView animated:YES];
    }
    return YES;

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [myDelegate stopIndicator];
//    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
//    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage")  closeButtonTitle:nil duration:0.0f];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - end
@end
