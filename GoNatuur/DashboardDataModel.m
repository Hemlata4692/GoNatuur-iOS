//
//  DashboardDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardDataModel.h"
#import "ConnectionManager.h"

@implementation DashboardDataModel
@synthesize banerImageUrl;
@synthesize categoryId;
@synthesize categoryName;
@synthesize categoryNameArray;
@synthesize banerImageId;
@synthesize bannerImageType;
@synthesize bannerImageArray;
@synthesize bestSellerArray;
@synthesize productPrice;
@synthesize productDescription;
@synthesize productImageThumbnail;
@synthesize productId;
@synthesize productName;
@synthesize productRating;
@synthesize footerBannerImageArray;
@synthesize healthyLivingArray;
@synthesize samplersDataArray;
@synthesize userCurrency;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static DashboardDataModel *dasboardData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dasboardData = [[[self class] alloc] init];
    });
    
    return dasboardData;
}
#pragma mark - end

#pragma mark - Get category listing data
- (void)getCategoryListDataOnSuccess:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getCategoryListing:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Get dashboard data
- (void)getDashboardData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getDashboardData:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Get currency data
- (void)getCurrencyData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getDefaultCurrency:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
             [UserDefaultManager setValue:userData.userCurrency key:@"DefaultCurrency"];
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
