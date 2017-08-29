//
//  ProfileService.h
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProfileModel;

@interface ProfileService : Webservice

//Change password service
- (void)changePasswordService:(ProfileModel *)profileData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure;

@end
