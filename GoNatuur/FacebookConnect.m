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
             [_delegate facebookLoginWithReadPermissionResponse:result status:2];
             [self fetchFBDataWithReadPermission];
             //process error
         } else if (result.isCancelled) {
             [_delegate facebookLoginWithReadPermissionResponse:result status:3];
             [self fetchFBDataWithReadPermission];
             //cancelled
         } else {
            //logged in
            if ([FBSDKAccessToken currentAccessToken]) {
                 [self fetchFBDataWithReadPermission];
             }
         }
     }];
}

- (void)fetchFBDataWithReadPermission
{
    NSString *fbAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    NSLog(@"fbAccessToken is %@", fbAccessToken);
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                       parameters:@{@"fields": @"picture.type(large), name, first_name, last_name, age_range, gender, birthday, email, friends"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             //fetch result from facebook login
             [_delegate facebookLoginWithReadPermissionResponse:result status:1];
         }
         else{
              [_delegate facebookLoginWithReadPermissionResponse:result status:2];
             NSLog(@"%@", [error localizedDescription]);
         }
     }];
}
#pragma mark - end
@end
