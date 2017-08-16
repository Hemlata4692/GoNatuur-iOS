//
//  LoginModel.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "LoginModel.h"
#import "ConnectionManager.h"

@implementation LoginModel

@synthesize username;
@synthesize email;
@synthesize password;
@synthesize otpNumber;
@synthesize isSocialLogin;
@synthesize accessToken;
@synthesize userId;
@synthesize followCount;
@synthesize notificationsCount;
@synthesize quoteCount;
@synthesize quoteId;
@synthesize wishlistCount;
@synthesize firstName;
@synthesize lastName;
@synthesize profilePicture;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static LoginModel *loginUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loginUser = [[[self class] alloc] init];
    });
    
    return loginUser;
}
#pragma mark - end

#pragma mark - Get authorization token
- (void)accessToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getAccessToken:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] loginUser:self onSuccess:^(LoginModel *userData) {
        if (success) {
            [UserDefaultManager setValue:userData.userId key:@"userId"];
            [UserDefaultManager setValue:userData.email key:@"emailId"];
            [UserDefaultManager setValue:userData.followCount key:@"followCount"];
            [UserDefaultManager setValue:userData.notificationsCount key:@"notificationsCount"];
            [UserDefaultManager setValue:userData.quoteId key:@"quoteId"];
            [UserDefaultManager setValue:userData.quoteCount key:@"quoteCount"];
            [UserDefaultManager setValue:userData.wishlistCount key:@"wishlistCount"];
            [UserDefaultManager setValue:userData.accessToken key:@"Authorization"];
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Save device token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] sendDevcieToken:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Login as guest user
- (void)loginGuestUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] loginGuestUser:self onSuccess:^(LoginModel *userData) {
        if (success) {
            [UserDefaultManager setValue:userData.quoteId key:@"quoteId"];
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - CMS page service
- (void)CMSPageService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {

    [[ConnectionManager sharedManager] CMSPageService:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Sign up user service
- (void)signUpUserService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    
    [[ConnectionManager sharedManager] signUpUserService:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Forgot password service
- (void)forgotPasswordService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] forgotPasswordService:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Reset password service
- (void)resetPasswordService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] resetPasswordService:self onSuccess:^(LoginModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
