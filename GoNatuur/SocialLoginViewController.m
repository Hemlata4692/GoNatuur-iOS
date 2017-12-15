//
//  SocialLoginViewController.m
//  GoNatuur
//
//  Created by Ranosys on 04/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SocialLoginViewController.h"
#import "FacebookConnect.h"
#import "GmailSignInConnect.h"
#import "WeiboAccess.h"

@interface SocialLoginViewController () <FacebookDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginWithFaceBookButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithWeChatButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithWieboButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithGoogleButton;
@end

@implementation SocialLoginViewController
@synthesize fbText, wieboText, weChatText, googlPlusText;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
  
    [self.loginWithFaceBookButton setTitle:fbText forState:UIControlStateNormal];
    [self.loginWithWeChatButton setTitle:weChatText forState:UIControlStateNormal];
    [self.loginWithWieboButton setTitle:wieboText forState:UIControlStateNormal];
    [self.loginWithGoogleButton setTitle:googlPlusText forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)loginWithFaceBook:(id)sender {
    myDelegate.selectedLoginType=FacebookLogin;
    //Need to login with FB
    FacebookConnect *fbConnectObject = [[FacebookConnect alloc]init];
    fbConnectObject.delegate = self;
    [fbConnectObject facebookLoginWithReadPermission:self];
}

- (IBAction)loginWithWeChat:(id)sender {
    [_delegate socialLoginResponse:WeChatLogin result:@{}];
}

- (IBAction)loginWithWiebo:(id)sender {
     myDelegate.selectedLoginType=WeiboLogin;
    [[WeiboAccess defaultAccess] login:^(BOOL succeeded, id responseObject) {
        if (succeeded) {
            NSLog(@"login response %@",responseObject);
            NSString *accessToken=[responseObject objectForKey:@"accessToken"];
             NSString *userID=[responseObject objectForKey:@"userID"];
            //email fetch : https://api.weibo.com/2/account/profile/basic.json
            //https://api.weibo.com/2/users/show.json?uid=6272175604&access_token=2.00e56TqGXA28ECd7e51aaac60BKixb
            [[Webservice sharedManager] getWeiboData:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?uid=%@&access_token=%@",userID,accessToken] parameters:nil onSuccess:^(id response){
                 NSLog(@"login response %@",response);
                 [_delegate socialLoginResponse:WeiboLogin result:@{@"email":([response objectForKey:@"email"]!=nil?[response objectForKey:@"email"]:@""), @"id":[response objectForKey:@"id"],@"firstName":([response objectForKey:@"name"]!=nil?[response objectForKey:@"name"]:@""),@"lastName":([response objectForKey:@"last_name"]!=nil?[response objectForKey:@"last_name"]:@""),@"imageUrl":[response objectForKey:@"avatar_hd"]}];
            } onFailure:^(NSError *error) {
                 NSLog(@"login failure %@",error);
              }];
        }
        else{
            if (WeiboStatusCodeAuthDeny == [responseObject[WEIBO_STATUS_CODE] integerValue]) {
                SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
                [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"weiboError") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
            }
        }
    }];
}

- (IBAction)loginWithGoogle:(id)sender {
    myDelegate.selectedLoginType=GoogleLogin;
    //Need to login with google plus
    GmailSignInConnect *gmailConnect = [[GmailSignInConnect alloc]init];
    [GIDSignIn sharedInstance].delegate=self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [gmailConnect gmailLoginWithPermission:self NSString:kClientID];
}
#pragma mark - end

#pragma mark - Login with facebook delegate method
//Facebook delegate method to fetch user data
- (void) facebookLoginWithReadPermissionResponse:(id)fbResult status:(int)status {
    if (status == 1) {
        //fetched data from facebook login
        DLog(@"facebookResult is %@", fbResult);
        DLog(@"facebookUserEmailId: %@",[fbResult objectForKey:@"email"]);
        DLog(@"facebookUserId: %@",[fbResult objectForKey:@"id"]);
        DLog(@"facebookUserImage: %@",[[[fbResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]);
        DLog(@"facebookUserName: %@",[fbResult objectForKey:@"name"]);
        DLog(@"facebookUserBirthday: %@",[fbResult objectForKey:@"birthday"]);
        DLog(@"facebookUserFirtName: %@",[fbResult objectForKey:@"first_name"]);
        DLog(@"facebookUserLastName: %@",[fbResult objectForKey:@"last_name"]);
        DLog(@"facebookUserGender: %@",[fbResult objectForKey:@"gender"]);
        DLog(@"facebookUserFriendCount: %@",[[[fbResult objectForKey:@"friends"] objectForKey:@"summary"] objectForKey:@"total_count"]);
        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":([fbResult objectForKey:@"email"]!=nil?[fbResult objectForKey:@"email"]:@""), @"id":[fbResult objectForKey:@"id"],@"firstName":([fbResult objectForKey:@"first_name"]!=nil?[fbResult objectForKey:@"first_name"]:@""),@"lastName":([fbResult objectForKey:@"last_name"]!=nil?[fbResult objectForKey:@"last_name"]:@""),@"id":[fbResult objectForKey:@"id"],@"imageUrl":[[[fbResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]}];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrondMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
    }
}
#pragma mark - end

#pragma mark - Login with gmail delegate method
//Google sign in delegate to fetch user data
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)gmailResult withError:(NSError *)error {
    //Logout user from gmail
    [[GIDSignIn sharedInstance] signOut];
    if (gmailResult!=nil) {
        //Fetch user data
        DLog(@"gmail userId is %@", gmailResult.userID);
        DLog(@"gmail name is %@", gmailResult.profile.name);
        DLog(@"gmail email is %@", gmailResult.profile.email);
        DLog(@"gmail has image is %d", gmailResult.profile.hasImage);
        NSURL *ImageURL;
        if (gmailResult.profile.hasImage) {
            ImageURL = [gmailResult.profile imageURLWithDimension:200];
            DLog(@"user image URL : %@",ImageURL);
        }
        DLog(@"gmail given name is %@", gmailResult.profile.givenName);
        DLog(@"gmail family name is %@", gmailResult.profile.familyName);
        DLog(@"gmail auth token is %@", gmailResult.authentication.idToken);
      [_delegate socialLoginResponse:GoogleLogin result:@{@"email":(gmailResult.profile.email!=nil?gmailResult.profile.email:@""), @"id":gmailResult.userID,@"firstName":(gmailResult.profile.givenName!=nil?gmailResult.profile.givenName:@""),@"lastName":(gmailResult.profile.familyName!=nil?gmailResult.profile.familyName:@""),@"id":gmailResult.userID,@"imageUrl":[ImageURL absoluteString]}];
    }
}
#pragma mark - end

//#pragma mark - Weibo delegate
//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result {
//    NSLog(@"%@",[NSString stringWithFormat:@"%@",result]);
//}
//
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error; {
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    title = NSLocalizedString(@"请求异常", nil);
//    alert = [[UIAlertView alloc] initWithTitle:title
//                                       message:[NSString stringWithFormat:@"%@",error]
//                                      delegate:nil
//                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                             otherButtonTitles:nil];
//    [alert show];
//}
//#pragma mark - end
@end
