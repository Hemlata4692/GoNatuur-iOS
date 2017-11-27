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
static NSString *kGuestAddToCartProduct=@"guest-carts/";
static NSString *kLoginedAddToCartProduct=@"carts/mine/items";
static NSString *kGuestAddToCartEvent=@"ranosys/add-event-to-cart";
static NSString *kLoggedinAddToCartEvent=@"ranosys/add-event-to-cart/mine";
static NSString *kshareProductNews=@"socialmediasharing";
//https://dev.gonatuur.com/en/socialmediasharing
@implementation ProductService

#pragma mark - Get product detail service
- (void)getProductDetailService:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSString *customerID;
    if ((nil==[UserDefaultManager getValue:@"userId"])){
        customerID=@"0";
    }
    else {
        customerID=[UserDefaultManager getValue:@"userId"];
    }
    NSDictionary *parameters = @{@"productId":productDetail.productId,
                                 @"customerId":customerID
                                 };
    NSLog(@"event detail request %@",parameters);
    [super post:kProductDetail parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Sahre product/newws
- (void)shareProductNewsService:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"np_id":productDetail.productId,
                                 @"customer_id":[UserDefaultManager getValue:@"userId"],@"social_media_type":productDetail.socialMediaType,
                                 @"share_type":productDetail.sharingType,@"np_name":productDetail.productName
                                 };
    NSLog(@"sharing request %@",parameters);
    [super postSharing:kshareProductNews parameters:parameters success:success failure:failure];
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
//unfollow product
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
        [super post:[NSString stringWithFormat:@"%@%@/items",kGuestAddToCartProduct,[UserDefaultManager getValue:@"quoteId"]] parameters:parameters success:success failure:failure];
    }
    else {
        NSDictionary *parameters = @{@"cartItem":@{@"quote_id":[UserDefaultManager getValue:@"quoteId"],
                                                   @"sku":productDetail.productSku,
                                                   @"qty":productDetail.productQuantity
                                                   }
                                     };
        
        DLog(@"Add to cart parameters: %@",parameters);
        [super post:kLoginedAddToCartProduct parameters:parameters success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Add tickets to cart service
- (void)addTicketsToCartProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters;
    
    if ((nil==[UserDefaultManager getValue:@"userId"])) {
        parameters = @{@"quote_id":[UserDefaultManager getValue:@"quoteId"],
                                     @"item":@{@"product_id":productDetail.productId,
                                               @"option_id":@"2",
                                               @"option_value":productDetail.selectedTicketOptionValue,
                                               @"ticket_price":productDetail.productPrice,
                                               @"dropdow":productDetail.selectedTicketOption,
                                               @"ticket_location":@"",
                                               @"ticket_date":@"",
                                               @"ticket_session":@"",
                                               @"checkbox":@"",
                                               @"qty":productDetail.productQuantity
                                               }
                                     };
        
        DLog(@"Add tickets to cart parameters: %@",parameters);
        [super post:kGuestAddToCartEvent parameters:parameters success:success failure:failure];
    }
    else {
        parameters = @{@"item":@{@"product_id":productDetail.productId,
                                 @"option_id":@"2",
                                 @"option_value":productDetail.selectedTicketOptionValue,
                                 @"ticket_price":productDetail.productPrice,
                                 @"dropdow":productDetail.selectedTicketOption,
                                 @"ticket_location":@"",
                                 @"ticket_date":@"",
                                 @"ticket_session":@"",
                                 @"checkbox":@"",
                                 @"qty":productDetail.productQuantity
                                 }
                       };
        
        DLog(@"Add tickets to cart parameters: %@",parameters);
         [super post:kLoggedinAddToCartEvent parameters:parameters success:success failure:failure];
    }
   
}
#pragma mark - end
@end
