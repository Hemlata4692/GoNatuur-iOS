//
//  ProductService.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductService.h"
#import "ProductDataModel.h"

static NSString *kProductDetail=@"ranosys/getProductsDetails";
static NSString *kAddWishlist=@"ipwishlist/add/product";
static NSString *kFollowProduct=@"ranosys/getProductsDetails";

@implementation ProductService

#pragma mark - Get product detail service
- (void)getProductDetailService:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":[NSNumber numberWithInt:0]
                                 };
    DLog(@"producy detail request %@",parameters);
    [super post:kProductDetail parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Add to wish list
//add prodcut to wishlist
- (void)addProductToWishlist:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":[UserDefaultManager getValue:@"userId"]
                                 };
    DLog(@"wish list request %@",parameters);
    [super post:kAddWishlist parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Follow product
//follow product
- (void)followProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":[UserDefaultManager getValue:@"userId"]
                                 };
    DLog(@"follow request %@",parameters);
    [super post:kFollowProduct parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
