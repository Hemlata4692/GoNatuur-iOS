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

@interface SocialLoginViewController () <FacebookDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginWithFaceBookButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithWeChatButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithWieboButton;
@property (strong, nonatomic) IBOutlet UIButton *loginWithGoogleButton;
@end

@implementation SocialLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithFaceBook:(id)sender {
    myDelegate.selectedLoginType=FacebookLogin;
    //Need to login with FB
    FacebookConnect *fbConnectObject = [[FacebookConnect alloc]init];
    fbConnectObject.delegate = self;
    [fbConnectObject facebookLoginWithReadPermission:self];
}

- (IBAction)loginWithWeChat:(id)sender {
}

- (IBAction)loginWithWiebo:(id)sender {
}

- (IBAction)loginWithGoogle:(id)sender {
    myDelegate.selectedLoginType=GoogleLogin;
    //Need to login with google plus
    GmailSignInConnect *gmailConnect = [[GmailSignInConnect alloc]init];
    [GIDSignIn sharedInstance].delegate=self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [gmailConnect gmailLoginWithPermission:self NSString:kClientID];
}

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
        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":[fbResult objectForKey:@"email"], @"id":[fbResult objectForKey:@"id"]}];
    }
    else {
        SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
        [alert showWarning:nil title:@"Alert" subTitle:@"Some thing went wrong, Please try again later." closeButtonTitle:@"Ok" duration:0.0f];
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
        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":gmailResult.profile.email, @"id":gmailResult.userID}];
    }
}
#pragma mark - end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
