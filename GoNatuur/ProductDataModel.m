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

- (id)copyWithZone:(NSZone *)zone {
    ProductDataModel *another = [[ProductDataModel alloc] init];
    another.categoryId= [self.categoryId copyWithZone: zone];
    another.categoryName= [self.categoryName copyWithZone: zone];
    another.productMediaUrl= [self.productMediaUrl copyWithZone: zone];
    another.productMediaType= [self.productMediaType copyWithZone: zone];
    another.productPrice= [self.productPrice copyWithZone: zone];
    another.productDescription= [self.productDescription copyWithZone: zone];
    another.productShortDescription= [self.productShortDescription copyWithZone: zone];
    another.productImageThumbnail= [self.productImageThumbnail copyWithZone: zone];
    another.productId= [self.productId copyWithZone: zone];
    another.productName= [self.productName copyWithZone: zone];
    another.productRating= [self.productRating copyWithZone: zone];
    another.productPointsEarn= [self.productPointsEarn copyWithZone: zone];
    another.productMaxQuantity= [self.productMaxQuantity copyWithZone: zone];
    another.productQuantity= [self.productQuantity copyWithZone: zone];
    another.productDataArray= [self.productDataArray copyWithZone: zone];
    another.productMediaArray= [self.productMediaArray copyWithZone: zone];
    return another;
}

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
