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
    
//    appDelegate.selectedLoginType=FacebookLogin;
    //need to change facebook app id with the client's one
//    FacebookConnect *fbConnectObject = [[FacebookConnect alloc]init];
//    fbConnectObject.delegate = self;
//    [fbConnectObject facebookLoginWithReadPermission:self];
}

- (IBAction)loginWithWeChat:(id)sender {
}

- (IBAction)loginWithWiebo:(id)sender {
}

- (IBAction)loginWithGoogle:(id)sender {
    
////    myDelegate.selectedLoginType=GoogleLogin;
//    GmailSignInConnect *gmailConnect = [[GmailSignInConnect alloc]init];
//    [GIDSignIn sharedInstance].delegate=self;
//    [GIDSignIn sharedInstance].uiDelegate = self;
//    [gmailConnect gmailLoginWithPermission:self NSString:kClientID];
}

#pragma mark - Login with facebook delegate method
//facebook delegate method to fetch user data
//- (void) facebookLoginWithReadPermissionResponse:(id)fbResult status:(int)status {
//    if (status == 1) {
//        //        [myDelegate stopIndicator];
//        //fetched data from facebook login
//        NSLog(@"facebookResult is %@", fbResult);
//        NSLog(@"facebookUserEmailId: %@",[fbResult objectForKey:@"email"]);
//        NSLog(@"facebookUserId: %@",[fbResult objectForKey:@"id"]);
//        NSLog(@"facebookUserImage: %@",[[[fbResult objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]);
//        NSLog(@"facebookUserName: %@",[fbResult objectForKey:@"name"]);
//        NSLog(@"facebookUserBirthday: %@",[fbResult objectForKey:@"birthday"]);
//        NSLog(@"facebookUserFirtName: %@",[fbResult objectForKey:@"first_name"]);
//        NSLog(@"facebookUserLastName: %@",[fbResult objectForKey:@"last_name"]);
//        NSLog(@"facebookUserGender: %@",[fbResult objectForKey:@"gender"]);
//        NSLog(@"facebookUserFriendCount: %@",[[[fbResult objectForKey:@"friends"] objectForKey:@"summary"] objectForKey:@"total_count"]);
//        [_delegate socialLoginResponse:FacebookLogin result:@{@"email":[fbResult objectForKey:@"email"], @"id":[fbResult objectForKey:@"id"]}];
//    }
//    else {
//        //        [myDelegate stopIndicator];
//        //show alert if error occured
//    }
//}
//#pragma mark - end
//
//
//#pragma mark - Login with gmail delegate method
////google sign in delegate to fetch user data
//- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)gmailResult withError:(NSError *)error {
//    //logout user from gmail
//    [[GIDSignIn sharedInstance] signOut];
//    //fetch user data
//    NSLog(@"gmail userId is %@", gmailResult.userID);
//    NSLog(@"gmail name is %@", gmailResult.profile.name);
//    NSLog(@"gmail email is %@", gmailResult.profile.email);
//    NSLog(@"gmail has image is %d", gmailResult.profile.hasImage);
//    if (gmailResult.profile.hasImage) {
//        NSURL *ImageURL = [gmailResult.profile imageURLWithDimension:200];
//        NSLog(@"user image URL : %@",ImageURL);
//    }
//    NSLog(@"gmail given name is %@", gmailResult.profile.givenName);
//    NSLog(@"gmail family name is %@", gmailResult.profile.familyName);
//    NSLog(@"gmail auth token is %@", gmailResult.authentication.idToken);
//    [_delegate socialLoginResponse:FacebookLogin result:@{@"email":gmailResult.profile.email, @"id":gmailResult.userID}];
//}
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
