//
//  LoginService.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginService.h"
#import "LoginModel.h"

static NSString *kAuthorizationToken=@"integration/admin/token";
static NSString *kLogin=@"ranosys/customer/customerLogin";
static NSString *kLoginAsGuest=@"ranosys/customer/guestLogin";
static NSString *kCMSPage=@"ranosys/cmsBlock/search";
static NSString *kSaveDeviceToken=@"ranosys/saveDeviceToken";
static NSString *kSignUp=@"ranosys/customer/customerSignup";
static NSString *kForgotPassword=@"ranosys/customer/forgotPassword";
static NSString *kResetPassword=@"ranosys/customer/resetPassword";
static NSString *kNewsSubscription=@"ranosys/newsletter/subscribe";

@implementation LoginService

#pragma mark - Login user service
- (void)loginUser:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if ([loginData.isSocialLogin isEqual:@0]) {
        parameters = @{@"email" : loginData.email,
                       @"password" : loginData.password,
                       @"isSocialLogin" : loginData.isSocialLogin,
                       @"countryCode" : [ConstantCode localeCountryCode],
                       @"socialType":@"",
                       @"socialUserId":@""
                       };
    }
    else {
        parameters = @{@"email" : loginData.email,
                       @"password" : loginData.password,
                       @"isSocialLogin" : loginData.isSocialLogin,
                       @"countryCode" : [ConstantCode localeCountryCode],
                       @"socialType":[NSNumber numberWithInt:myDelegate.selectedLoginType],
                       @"socialUserId":loginData.socialUserId};
    }
     DLog(@"login request %@",parameters);
    [super post:kLogin parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Login as guest user service
- (void)loginGuestUser:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"countryCode" : [ConstantCode localeCountryCode]};
    [super post:kLoginAsGuest parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Subscribe newsletter service
- (void)subscriptionNewsLetter:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if (nil==[UserDefaultManager getValue:@"userId"]) {
        parameters = @{@"email" : loginData.email};
    }
    else {
    parameters = @{@"email" : loginData.email,
                                 @"customerId" : [UserDefaultManager getValue:@"userId"]};
    }
    DLog(@"news subscription %@",parameters);
    [super post:kNewsSubscription parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - CMS page service
- (void)CMSPageService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups":@[@{@"filters":@[@{@"field":@"identifier",
                                                                                           @"value":loginData.cmsPageType,
                                                                                           @"condition_type":@"eq"
                                                                                           }
                                                                                         ]
                                                                            }
                                                                          ],
                                                       @"page_size":[NSNumber numberWithInt:0],
                                                       @"current_page":[NSNumber numberWithInt:0]
                                                       }
                                 };
   [super post:kCMSPage parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Save device token service
- (void)saveDeviceTokenService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"customerId" : [UserDefaultManager getValue:@"userId"],
                                 @"deviceType" : [NSNumber numberWithInt:2],
                                 @"deviceToken" : myDelegate.deviceToken};

    [super post:kSaveDeviceToken parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - SignUp user service
- (void)signUpUserService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    if ([loginData.isSocialLogin isEqual:@0]) {
        parameters = @{@"customer" : @{@"email" : loginData.email,
                                       @"firstname" : loginData.firstName,
                                       @"lastname" : loginData.lastName
                                       },
                       @"password" : loginData.password,
                       @"isSocial":loginData.isSocialLogin,
                       @"profileImageUrl":@"",
                       @"socialType":[NSNumber numberWithInt:myDelegate.selectedLoginType],
                       @"socialUserId":@"",
                       @"redirectUrl":@""
                       };
    }
    else {
        parameters = @{@"customer" : @{@"email" : loginData.email,
                                       @"firstname" : loginData.firstName,
                                       @"lastname" : loginData.lastName
                                       },
                       @"isSocial":loginData.isSocialLogin,
                       @"profileImageUrl":loginData.profilePicture,
                       @"socialType":[NSNumber numberWithInt:myDelegate.selectedLoginType],
                       @"socialUserId":loginData.socialUserId,
                       @"redirectUrl":@""
                       };
    }
    NSLog(@"sign up request social %@",parameters);
    [super post:kSignUp parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Forgot password service
- (void)forgotPasswordService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"email" : loginData.email,
                                 @"template" : @"email"
                                 };
    [super post:kForgotPassword parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Reset password service
- (void)resetPasswordService:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"email" : loginData.email,
                                 @"password" : loginData.password,
                                 @"requestOTP" : loginData.otpNumber
                                 };
    [super post:kResetPassword parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
