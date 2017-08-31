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
//User profile
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *defaultLanguage;
@property (strong, nonatomic) NSString *defaultCurrency;
@property (strong, nonatomic) NSMutableArray *addressArray;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *defaultBillingAddress;
@property (strong, nonatomic) NSString *defaultShippingAddress;
@property (strong, nonatomic) NSString *addressId;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *stateName;
@property (strong, nonatomic) NSString *stateID;
@property (strong, nonatomic) NSString *stateCode;
@property (strong, nonatomic) NSString *addressLine1;
@property (strong, nonatomic) NSString *addressLine2;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSString *addreesFirstName;
@property (strong, nonatomic) NSString *addreesLastName;
@property (strong, nonatomic) NSString *addressCountry;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *fax;

+ (instancetype)sharedUser;
//Login user
- (void)changePasswordService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
//Get country code
- (void)getCountryCodeService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
//Get user profile
- (void)getUserProfile:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
//Save address
- (void)saveAndUpdateAddress:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure;
@end
