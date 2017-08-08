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

//Get authorization token
- (void)getAccessToken:(LoginModel *)accessToken onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
//Login user
- (void)loginUser:(LoginModel *)loginData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;
@end
