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
@synthesize paymentMethod,cartListDataArray,finalCheckoutPriceDict;

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
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        paymentString = [NSString stringWithFormat:@"%@en/paymentview?quoteid=%@&paywith=%@",BaseUrl,[UserDefaultManager getValue:@"quoteId"],paymentMethod];
    } else {
        paymentString = [NSString stringWithFormat:@"%@en/paymentview?token=%@&paywith=%@",BaseUrl,[UserDefaultManager getValue:@"Authorization"],paymentMethod];
        
        //https://dev.gonatuur.com/en/paymentview?quoteid=41894f352a9444f4a7d02f8acdda2b01&paywith=paypal_express
    }
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:paymentString]];
    //Load the request in the UIWebView.
    [_paymentWebView loadRequest:requestObj];}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

//    NSLog(@"%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
//    NSLog(@"loadURL %@",[request.URL absoluteString]);
    //https://dev.gonatuur.com/en/checkout/onepage/success/121/
    if ([[request.URL absoluteString] isEqualToString:@"https://dev.gonatuur.com/en/checkout/onepage/success/"]) {
        
    }
    
   else if ([[request.URL absoluteString] containsString:@"https://dev.gonatuur.com/en/checkout/onepage/success/"]) {
       NSArray *items = [[request.URL absoluteString] componentsSeparatedByString:@"/"];
           UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
           ThankYouViewController * nextView=[sb instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
           nextView.orderId = [items objectAtIndex:items.count - 2];
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
