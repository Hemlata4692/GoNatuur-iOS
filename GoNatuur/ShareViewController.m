//
//  ShareViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareDataModel.h"

@interface ShareViewController () {
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
    shareURL=@"http%3A%2F%2F192.121.166.226%3A81%2Fgopurpose%2Fen%2Fexciting-corn.html";
    NSString *webViewString=[NSString stringWithFormat:@"%@%@/%@url=%@&media=%@&name=%@&description=%@&token=%@&sharedpoint-nap=%@",BaseUrl,[UserDefaultManager getValue:@"Language"],@"socailsharing/product/share/?",shareURL,mediaURL,name,productDescription,[UserDefaultManager getValue:@"Authorization"],@"0"];
    NSString *encodedString = [webViewString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *webViewURL = [NSURL URLWithString:encodedString];
    NSURLRequest *shareRequest=[NSURLRequest requestWithURL:webViewURL];
    [_shareWebView loadRequest: shareRequest];

}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@",request);
    NSLog(@"%@", [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]);
    loadURL=[request.URL absoluteString];
    //URL: https://m.facebook.com/v2.10/dialog/share/submit - facebook
    //https://twitter.com/intent/tweet - twitter p=tweetbutton
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"loading comleted");
    if (webView.isLoading)
        return;
    else {
        [myDelegate stopIndicator];
        if ([loadURL isEqualToString:@"https://m.facebook.com/v2.10/dialog/share/submit"] || [loadURL containsString:@"p=tweetbutton"]) {
            [self loadShareRequestURL];
        }
        
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != NSURLErrorCancelled) {
        //show error alert, etc.
        [myDelegate stopIndicator];
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage")  closeButtonTitle:nil duration:0.0f];
    }
}
#pragma mark - end

#pragma mark - Webservices
- (void)sharingService {
    ShareDataModel *shareData = [ShareDataModel sharedUser];
    shareData.deeplinkURL=shareURL;
    shareData.imageURL=mediaURL;
    shareData.name=name;
    shareData.productDescription=productDescription;
    [shareData getShareDataWebView:^(ShareDataModel *userData) {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Dismiss view
//The event handling method
- (void)dismissNewsView:(UITapGestureRecognizer *)recognizer {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - end

#pragma mark - IBActionss
- (IBAction)weiboButtonAction:(id)sender {
}

- (IBAction)wechatButtonAction:(id)sender {
}
- (IBAction)twitterButtonAction:(id)sender {
}

- (IBAction)pinterestButtonAction:(id)sender {
}
- (IBAction)instagramButtonAction:(id)sender {
}
- (IBAction)googlePlusButtonAction:(id)sender {
}
- (IBAction)facebookButtonAction:(id)sender {
}
#pragma mark - end
@end
