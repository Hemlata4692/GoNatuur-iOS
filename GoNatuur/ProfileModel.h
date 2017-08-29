//
//  ProfileModel.h
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject
@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *changePassword;

+ (instancetype)sharedUser;

//Login user
- (void)changePasswordService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;

@end
