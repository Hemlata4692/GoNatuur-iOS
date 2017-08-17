//
//  GmailSignInConnect.h
//  SocialLogin
//
//  Created by Hema on 14/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>



@interface GmailSignInConnect : NSObject<GIDSignInUIDelegate> {
}

@property (nonatomic,strong) id delegate;
- (void)gmailLoginWithPermission:(UIViewController *)selfVC NSString:(NSString *)clientId;

@end
