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
@property (strong, nonatomic) NSMutableArray *categoryNameArray;
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

+ (instancetype)sharedUser;

//Fetch category listng data
- (void)getCategoryListDataOnSuccess:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;

//Fetch dashboard data
- (void)getDashboardData:(void (^)(DashboardDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
