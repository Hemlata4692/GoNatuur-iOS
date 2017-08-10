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
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSNumber *isSocialLogin;
@property (strong, nonatomic) NSString *userId;

+ (instancetype)sharedUser;
//Login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Get community code
- (void)accessToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Save devcie token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//Login as guest user
- (void)loginGuestUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
@end
