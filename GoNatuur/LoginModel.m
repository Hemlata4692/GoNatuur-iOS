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
@synthesize isSocialLogin;
@synthesize accessToken;
@synthesize userId;
@synthesize followCount;
@synthesize notificationsCount;
@synthesize quoteCount;
@synthesize quoteId;
@synthesize wishlistCount;

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
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - save device token
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
@end
