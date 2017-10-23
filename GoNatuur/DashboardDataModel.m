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
@synthesize currentPage;
@synthesize pageSize;
@synthesize totalProductCount;
@synthesize categoryNameArray;
@synthesize profilePicture;
@synthesize notificationsCount;
@synthesize productQty;
@synthesize productType;
@synthesize firstName;
@synthesize lastName;
@synthesize newsType;
@synthesize newsContent;
@synthesize archiveOptionsForNews;
@synthesize filterValue2;
@synthesize filterValue;
@synthesize sortingValue;
@synthesize redeemPointsRequired;
@synthesize selectedFiltersDataArray;
@synthesize newsURL;
@synthesize tierPriceArray;
@synthesize ribbons;

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
            [UserDefaultManager setValue:userData.notificationsCount key:@"notificationsCount"];
            if ((nil==[UserDefaultManager getValue:@"userId"])){
                [UserDefaultManager removeValue:@"profilePicture"];
            }
            else {
                [UserDefaultManager setValue:userData.firstName key:@"firstname"];
                [UserDefaultManager setValue:userData.lastName key:@"lastname"];
                [UserDefaultManager setValue:userData.profilePicture key:@"profilePicture"];
            }
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Category banner service
- (void)getCategoryBannerData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getCategoryBannerData:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Product list data service
- (void)getProductListService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getProductListService:self onSuccess:^(DashboardDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - News list data service
- (void)getNewsListDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getNewsCenterListService:self onSuccess:^(DashboardDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - News list filters service
- (void)getNewsListFiltersDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getNewsCenterFiltersListService:self onSuccess:^(DashboardDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - News detail data service
- (void)getNewsDetailDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getNewsCenterDetailService:self onSuccess:^(DashboardDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Get News category listing data
- (void)getNewsCategoryListDataOnSuccess:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getNewsCategoryListing:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Fetch constants listng data
- (void)getConstantsListData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getConstantsListData:self onSuccess:^(DashboardDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

@end
