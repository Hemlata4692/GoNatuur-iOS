//
//  LoginViewController.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 17/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginViewController.h"
#import "FacebookConnect.h"
#import "GmailSignInConnect.h"
#import "LoginModel.h"
#import "SignUpViewController.h"

@interface LoginViewController ()<FacebookDelegate,GIDSignInDelegate,GIDSignInUIDelegate>

@end

@implementation LoginViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self authenticationToken];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
//login with facebook button action
- (IBAction)loginWithFacebookAction:(id)sender {
    //need to change facebook app id with the client's one
    FacebookConnect *fbConnectObject = [[FacebookConnect alloc]init];
    fbConnectObject.delegate = self;
    [fbConnectObject facebookLoginWithReadPermission:self];
}

- (IBAction)signUp:(UIButton *)sender {
    
    //storyBoard navigation
    UIViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self.navigationController pushViewController:obj animated:YES];
}

//login with gmail button action
- (IBAction)loginWithGoogleAction:(id)sender {
    
    GmailSignInConnect *gmailConnect = [[GmailSignInConnect alloc]init];
    [GIDSignIn sharedInstance].delegate=self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [gmailConnect gmailLoginWithPermission:self NSString:kClientID];
}
#pragma mark - end

#pragma mark - Login with facebook delegate method
//facebook delegate method to fetch user data
- (void) facebookLoginWithReadPermissionResponse:(id)fbResult status:(int)status {
    if (status == 1) {
        [myDelegate stopIndicator];
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
    }
    else {
        [myDelegate stopIndicator];
        //show alert if error occured
    }
}
#pragma mark - end

#pragma mark - Login with gmail delegate method
//google sign in delegate to fetch user data
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)gmailResult withError:(NSError *)error {
    //logout user from gmail
    [[GIDSignIn sharedInstance] signOut];
    //fetch user data
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
}
#pragma mark - end

#pragma mark - Webservice
//community code webservice called
- (void)authenticationToken {
    [myDelegate showIndicator];
    LoginModel *authToken = [LoginModel sharedUser];
    authToken.username=@"";
    authToken.password=@"";
    [authToken accessToken:^(LoginModel *userData) {
//        [self userLogin];
    } onfailure:^(NSError *error) {
        
    }];
}

//user login webservice called
- (void)userLogin {
//    LoginModel *userLogin = [LoginModel sharedUser];
//    userLogin.userName = self.usernameTextField.text;
//    userLogin.password = self.passwordTextField.text;
//    [userLogin loginUserOnSuccess:^(LoginModel *userData) {
//        if (nil==[UserDefaultManager getValue:@"deviceToken"]||NULL==[UserDefaultManager getValue:@"deviceToken"]) {
//            [myDelegate stopIndicator];
//        }
//        else{
//            [self saveDeviceToken];
//        }
        //land user to dashboard
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        MainSideBarViewController * homeView = [storyboard instantiateViewControllerWithIdentifier:@"MainSideBarViewController"];
//        [myDelegate.window setRootViewController:homeView];
//        [myDelegate.window makeKeyAndVisible];
//    } onfailure:^(NSError *error) {
//        
//    }];
}

//save device token for push notifications
- (void)saveDeviceToken {
    LoginModel *saveDeviceToken = [LoginModel sharedUser];
    [saveDeviceToken saveDeviceToken:^(LoginModel *deviceToken) {
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end


@end
