//
//  ProductDataModel.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDataModel.h"
#import "ConnectionManager.h"

@implementation ProductDataModel
@synthesize categoryId;
@synthesize categoryName;
@synthesize productMediaUrl;
@synthesize productMediaType;
@synthesize productPrice;
@synthesize productDescription;
@synthesize productShortDescription;
@synthesize productImageThumbnail;
@synthesize productId;
@synthesize productName;
@synthesize productRating;
@synthesize productPointsEarn;
@synthesize productMaxQuantity;
@synthesize productQuantity;
@synthesize productDataArray;
@synthesize productMediaArray;

#pragma mark - Shared instance
+ (instancetype)sharedUser{
    static ProductDataModel *productData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        productData = [[[self class] alloc] init];
    });
    return productData;
}
#pragma mark - end

#pragma mark - Fetch product detail
- (void)getProductDetailOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getProductDetail:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
