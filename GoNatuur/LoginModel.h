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
@property (strong, nonatomic) NSString *password;

+ (instancetype)sharedUser;
//login user
- (void)loginUserOnSuccess:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//get community code
- (void)accessToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;
//save devcie token
- (void)saveDeviceToken:(void (^)(LoginModel *))success onfailure:(void (^)(NSError *))failure;

@end
