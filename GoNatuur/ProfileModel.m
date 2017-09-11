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
@synthesize customAttributeArray;
@synthesize storeId;
@synthesize groupId;
@synthesize websiteId;
@synthesize currentPage;
@synthesize pageCount;
@synthesize totalPoints;
@synthesize recentEarnedPoints;
@synthesize userImageURL;
@synthesize userImage;

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

- (id)mutableCopyWithZone:(NSZone *)zone {
    ProfileModel *another = [[ProfileModel alloc] init];
    another.countryId= [self.countryId mutableCopyWithZone: zone];
    another.countryLocale= [self.countryLocale mutableCopyWithZone: zone];
    another.regionArray= [self.regionArray mutableCopyWithZone: zone];
    another.regionId= [self.regionId mutableCopyWithZone: zone];
    another.regionCode= [self.regionCode mutableCopyWithZone: zone];
    another.regionName= [self.regionName mutableCopyWithZone: zone];
    return another;
}

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

#pragma mark - Update user image
- (void)updateUserProfileImage:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] updateUserProfileImage:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
             [UserDefaultManager setValue:profileData.userImageURL key:@"profilePicture"];
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Get user imapct points data
- (void)getImpactPoints:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getUserImpactPointsData:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            if ([profileData.totalPoints isEqualToString:@""] || profileData.totalPoints==nil) {
                 [UserDefaultManager setValue:@"0" key:@"TotalPoints"];
            }
            else {
                 [UserDefaultManager setValue:profileData.totalPoints key:@"TotalPoints"];
            }
            
            if ([profileData.recentEarnedPoints isEqualToString:@""] || profileData.recentEarnedPoints==nil) {
                profileData.recentEarnedPoints=@"0";
                [UserDefaultManager setValue:profileData.recentEarnedPoints key:@"RecentEarned"];
            }
            else {
                [UserDefaultManager setValue:profileData.recentEarnedPoints key:@"RecentEarned"];
            }
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end


#pragma mark - Save user profile
- (void)saveUserProfile:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] saveUserProfileData:self onSuccess:^(ProfileModel *profileData) {
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

#pragma mark - Country code service
- (void)getCountryCodeService:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getCountryCodeService:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Save address
- (void)saveAndUpdateAddress:(void (^)(ProfileModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] saveAndUpdateAddress:self onSuccess:^(ProfileModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end
@end
