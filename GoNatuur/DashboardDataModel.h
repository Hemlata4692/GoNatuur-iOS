//
//  DashboardDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 11/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardDataModel : NSObject
@property (strong, nonatomic) NSString *categoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *banerImageUrl;
@property (strong, nonatomic) NSString *banerImageId;
@property (strong, nonatomic) NSString *bannerImageType;
@property (strong, nonatomic) NSMutableArray *bannerImageArray;
@property (strong, nonatomic) NSMutableArray *bestSellerArray;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *productImageThumbnail;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productRating;
@property (strong, nonatomic) NSMutableArray *footerBannerImageArray;
@property (strong, nonatomic) NSMutableArray *healthyLivingArray;
@property (strong, nonatomic) NSMutableArray *samplersDataArray;
@property (strong, nonatomic) NSMutableArray *productDataArray;
@property (strong, nonatomic) NSNumber *currentPage;
@property (strong, nonatomic) NSNumber *pageSize;
@property (strong, nonatomic) NSNumber *totalProductCount;
@property (strong, nonatomic) NSMutableArray *categoryNameArray;
@property (strong, nonatomic) NSString *profilePicture;
@property (strong, nonatomic) NSNumber *notificationsCount;
@property (strong, nonatomic) NSString *specialPrice;
@property (strong, nonatomic) NSString *specialPriceStartDate;
@property (strong, nonatomic) NSString *specialPriceEndDate;
@property (strong, nonatomic) NSNumber *productQty;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *newsType;
@property (strong, nonatomic) NSString *newsContent;
@property (strong, nonatomic) NSString *newsURL;
@property (strong, nonatomic) NSMutableArray *archiveOptionsForNews;
@property (strong, nonatomic) NSString *filterValue;
@property (strong, nonatomic) NSString *filterValue2;
@property (strong, nonatomic) NSString *sortingValue;
@property (strong, nonatomic) NSString *redeemPointsRequired;
@property (strong, nonatomic) NSMutableArray *tierPriceArray;
@property (strong, nonatomic) NSString *ribbons;

@property (nonatomic) int sortFilterRequestParameter;
//Sorting
@property (strong, nonatomic) NSString *productSortingValue;
@property (strong, nonatomic) NSString *productSortingType;
//Filters
@property (strong, nonatomic) NSString *minPriceValue;
@property (strong, nonatomic) NSString *maxPriceValue;
@property (strong, nonatomic) NSString *filterAttributeCode;
@property (strong, nonatomic) NSString *filterAttributeId;
@property (strong, nonatomic) NSMutableArray *selectedFiltersDataArray;

//Singleton method
+ (instancetype)sharedUser;

//Fetch category listng data
- (void)getCategoryListDataOnSuccess:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;

//Fetch dashboard data
- (void)getDashboardData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
//Product list data service
- (void)getProductListService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
//Category banner service
- (void)getCategoryBannerData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
//News list
- (void)getNewsListDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
//News category list
- (void)getNewsCategoryListDataOnSuccess:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
///News detail data
- (void)getNewsDetailDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
//Fetch constants listng data
- (void)getConstantsListData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;

//Filters
- (void)getNewsListFiltersDataService:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
