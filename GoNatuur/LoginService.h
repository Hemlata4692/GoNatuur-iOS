//
//  LoginService.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Webservice.h"

@class LoginModel;

@interface LoginService : Webservice

//get authorization token
- (void)getAccessToken:(LoginModel *)accessToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
////login user
//- (void)loginUser:(LoginModel *)userLogin onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
////save device token
//- (void)saveDeviceToken:(LoginModel *)deviceToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;


@end
