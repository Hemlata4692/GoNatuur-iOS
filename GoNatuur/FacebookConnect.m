//
//  FacebookConnect.m
//  Created by Ranosys on 12/07/16.
//

#import "FacebookConnect.h"

@implementation FacebookConnect

#pragma mark - Facebook login with read permission
- (void)facebookLoginWithReadPermission:(UIViewController *)selfVC {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
     fromViewController:selfVC
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             [myDelegate showIndicator];
             [self performSelector:@selector(fetchFBDataWithReadPermission) withObject:nil afterDelay:.1];
             //process error
         } else if (result.isCancelled) {
             //Cancelled
         } else {
             //logged in
             if ([FBSDKAccessToken currentAccessToken]) {
                 [myDelegate showIndicator];
                 [self performSelector:@selector(fetchFBDataWithReadPermission) withObject:nil afterDelay:.1];
             }
         }
     }];
}

- (void)fetchFBDataWithReadPermission {
    NSString *fbAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    DLog(@"fbAccessToken is %@", fbAccessToken);
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture.type(large), name, first_name, last_name, age_range, gender, birthday, email, friends"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         [myDelegate stopIndicator];
         if (!error) {
             //fetch result from facebook login
             [_delegate facebookLoginWithReadPermissionResponse:result status:1];
         }
         else{
             [_delegate facebookLoginWithReadPermissionResponse:result status:2];
             DLog(@"%@", [error localizedDescription]);
         }
     }];
}
#pragma mark - end
@end
