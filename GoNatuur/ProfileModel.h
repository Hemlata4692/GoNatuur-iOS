//
//  ProfileModel.h
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileModel : NSObject
//Change password
@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *changePassword;
//Country code list
@property (strong, nonatomic) NSString *countryLocale;
@property (strong, nonatomic) NSString *countryId;
@property (strong, nonatomic) NSMutableArray *countryCodeArray;
//Region list
@property (strong, nonatomic) NSString *regionCode;
@property (strong, nonatomic) NSString *regionId;
@property (strong, nonatomic) NSString *regionName;
@property (strong, nonatomic) NSMutableArray *regionArray;

+ (instancetype)sharedUser;

//Login user
- (void)changePasswordService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
//Get country code
- (void)getCountryCodeService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
@end
