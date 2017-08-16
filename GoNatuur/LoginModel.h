//
//  LoginModel.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginModel : NSObject
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *profilePicture;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *otpNumber;
@property (strong, nonatomic) NSNumber *isSocialLogin;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSNumber *followCount;
@property (strong, nonatomic) NSNumber *notificationsCount;
@property (strong, nonatomic) NSNumber *quoteCount;
@property (strong, nonatomic) NSNumber *quoteId;
@property (strong, nonatomic) NSNumber *wishlistCount;
@property (strong, nonatomic) NSNumber *cmsPageType;//Terms & Conditions:6 and Privacy policy:4
@property (strong, nonatomic) NSString *cmsTitle;
@property (strong, nonatomic) NSString *cmsContent;

+ (instancetype)sharedUser;
//Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Get community code
- (void)accessToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Save devcie token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Login as guest user
- (void)loginGuestUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//CMS page service
- (void)CMSPageService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Sign up user service
- (void)signUpUserService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Forgot password service
- (void)forgotPasswordService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Reset password service
- (void)resetPasswordService:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
@end
