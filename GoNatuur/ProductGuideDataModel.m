//
//  ProductGuideDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideDataModel.h"
#import "ConnectionManager.h"

@implementation ProductGuideDataModel
@synthesize guideCategoryDataArray;
@synthesize categoryName;
@synthesize categoryDescription;
@synthesize postId;
@synthesize postName;
@synthesize shortDescription;
@synthesize tagline;
@synthesize postContent;
@synthesize postImage;
@synthesize postDataArray;
@synthesize categoryId;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static ProductGuideDataModel *productGuideData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productGuideData = [[[self class] alloc] init];
    });
    return productGuideData;
}
#pragma mark - end

#pragma mark - Get guide category data
- (void)getProductGuideCategoryData:(void (^)(ProductGuideDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getGuideCategory:self onSuccess:^(ProductGuideDataModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

#pragma mark - Get guide category details data
- (void)getProductGuideDetailsCategoryData:(void (^)(ProductGuideDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getGuideDetailsCategory:self onSuccess:^(ProductGuideDataModel *profileData) {
        if (success) {
            success (profileData);
        }
    } onFailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

@end
