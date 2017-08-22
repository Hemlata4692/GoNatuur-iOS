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
static NSString *kFollowProduct=@"ranosys/product/follow/mine";
static NSString *kRemoveWishlist=@"ipwishlist/delete/wishlistItem";
static NSString *kUnFollowProduct=@"ranosys/product/unfollow/mine";
static NSString *kGuestAddToCartProduct=@"guest-carts/566b65a6ac1eaa6587a939ca27d3d44b/items";
static NSString *kLoginedAddToCartProduct=@"carts/mine";

@implementation ProductService

#pragma mark - Get product detail service
- (void)getProductDetailService:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":[UserDefaultManager getValue:@"userId"]
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

#pragma mark - Remove to wish list
//remove prodcut to wishlist
- (void)removeProductFromWishlist:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"wishlistItemId":productDetail.productId,
                                 @"customerId":[UserDefaultManager getValue:@"userId"]
                                 };
    DLog(@"wish list request %@",parameters);
    [super post:kRemoveWishlist parameters:parameters success:success failure:failure];
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

#pragma mark - Unfollow product
//follow product
- (void)unFollowProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":[UserDefaultManager getValue:@"userId"]
                                 };
    DLog(@"unfollow request %@",parameters);
    [super post:kUnFollowProduct parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Add to cart service
- (void)addToCartProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        NSDictionary *parameters = @{@"cartItem":@{@"quote_id":[UserDefaultManager getValue:@"quoteId"],
                                                   @"sku":productDetail.productSku,
                                                   @"qty":productDetail.productQuantity
                                                   }
                                     };
        DLog(@"Add to cart parameters: %@",parameters);
        [super post:kGuestAddToCartProduct parameters:parameters success:success failure:failure];
    }
    else {
        NSDictionary *parameters = @{@"quote":@{@"id":[UserDefaultManager getValue:@"quoteId"],
                                                @"items":@[@{
                                                               @"sku":productDetail.productSku,
                                                               @"qty":productDetail.productQuantity,
                                                               @"quote_id":[UserDefaultManager getValue:@"quoteId"]
                                                               }
                                                           ]
                                                }
                                     };
        DLog(@"Add to cart parameters: %@",parameters);
        [super post:kLoginedAddToCartProduct parameters:parameters success:success failure:failure];
    }
}
#pragma mark - end
@end
