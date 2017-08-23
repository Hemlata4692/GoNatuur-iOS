//
//  ProductService.h
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProductDataModel;

@interface ProductService : Webservice
//Get product detail service
- (void)getProductDetailService:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//add prodcut to wishlist
- (void)addProductToWishlist:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//follow product
- (void)followProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//unfollow
- (void)unFollowProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//remove from wishlist
- (void)removeProductFromWishlist:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Add to cart service
- (void)addToCartProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
