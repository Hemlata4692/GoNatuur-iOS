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
#import "UIView+Toast.h"

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
    [self.view makeToast:@"Feature is currently not available."];
}

- (IBAction)loginWithWiebo:(id)sender {
    [self.view makeToast:@"Feature is currently not available."];
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
        //        [myDelegate stopIndicator];
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
        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":[fbResult objectForKey:@"email"], @"id":[fbResult objectForKey:@"id"],@"firstName":([fbResult objectForKey:@"first_name"]!=nil?[fbResult objectForKey:@"first_name"]:@""),@"lastName":([fbResult objectForKey:@"last_name"]!=nil?[fbResult objectForKey:@"last_name"]:@"")}];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage") closeButtonTitle:NSLocalizedText(@"alertOk") duration:0.0f];
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
        if (gmailResult.profile.hasImage) {
            NSURL *ImageURL = [gmailResult.profile imageURLWithDimension:200];
            DLog(@"user image URL : %@",ImageURL);
        }
        DLog(@"gmail given name is %@", gmailResult.profile.givenName);
        DLog(@"gmail family name is %@", gmailResult.profile.familyName);
        DLog(@"gmail auth token is %@", gmailResult.authentication.idToken);
        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":gmailResult.profile.email, @"id":gmailResult.userID,@"firstName":(gmailResult.profile.givenName!=nil?gmailResult.profile.givenName:@""),@"lastName":(gmailResult.profile.familyName!=nil?gmailResult.profile.familyName:@"")}];
    }
}
#pragma mark - end
@end
