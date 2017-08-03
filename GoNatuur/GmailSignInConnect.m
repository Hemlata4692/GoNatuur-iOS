//
//  GmailSignInConnect.m
//  SocialLogin
//
//  Created by Hema on 14/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import "GmailSignInConnect.h"

@implementation GmailSignInConnect

- (void)gmailLoginWithPermission:(UIViewController *)selfVC NSString:(NSString *)clientId {
    [GIDSignIn sharedInstance].clientID =clientId;
    [GIDSignIn sharedInstance].shouldFetchBasicProfile = YES;
    [[GIDSignIn sharedInstance] signIn];
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    //[myActivityIndicator stopAnimating];
}

- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [viewController presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}
@end
