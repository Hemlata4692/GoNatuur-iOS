//
//  ProfileModel.m
//  GoNatuur
//
//  Created by Monika on 8/29/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProfileModel.h"
#import "ConnectionManager.h"

@implementation ProfileModel
@synthesize currentPassword;
@synthesize changePassword;
@synthesize countryLocale;
@synthesize countryId;
@synthesize countryCodeArray;
@synthesize email;
@synthesize firstName;
@synthesize lastName;
@synthesize defaultLanguage;
@synthesize defaultCurrency;
@synthesize addressArray;
@synthesize city;
@synthesize defaultBillingAddress;
@synthesize defaultShippingAddress;
@synthesize postalCode;
@synthesize stateName;
@synthesize stateCode;
@synthesize stateID;
@synthesize addressLine1;
@synthesize addressLine2;
@synthesize phoneNumber;
@synthesize addreesFirstName;
@synthesize addreesLastName;
@synthesize addressCountry;
@synthesize companyName;
@synthesize fax;
@synthesize addressId;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static ProfileModel *profileData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        profileData = [[[self class] alloc] init];
    });
    
    return profileData;
}
#pragma mark - end

#pragma mark - Get user profile
- (void)getUserProfile:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getUserProfileData:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Change password
- (void)changePasswordService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] changePasswordService:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Change password
- (void)getCountryCodeService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getCountryCodeService:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
