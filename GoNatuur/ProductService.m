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
                                                   @"qty":@"10000"
                                                   }
                                     };
        
        DLog(@"Add to cart parameters: %@",parameters);
        [super post:kLoginedAddToCartProduct parameters:parameters success:success failure:failure];
    }
}
#pragma mark - end

#pragma mark - Add tickets to cart service
- (void)addTicketsToCartProduct:(ProductDataModel *)productDetail success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    
//    {
//        "quoteId": "72",
//        "item": {
//            "product_id": "30",
//            "option_id": "2",// same always
//            "option_value": "11_Op2",//original ticket  get price without conversion_option name
//            "ticket_price": "30.00",// converted price
//            "dropdow": "Op2",//option name
//            "ticket_location": "",
//            "ticket_date": "",
//            "ticket_session": "",
//            "checkbox": "",
//            "qty": "1"// selected quantity
//        }
//    }

//    productData.productQuantity=productDetailModelData.productQuantity;
//    productData.productSku=productDetailModelData.productSku;
//    productData.productId=[NSNumber numberWithInt:selectedProductId];
//    productData.selectedTicketOptionValue=[NSString stringWithFormat:@"%@_%@",productDetailModelData.eventPrice,selectedTicketOption];
//    productData.productPrice=[NSNumber numberWithDouble:[convertedPrice doubleValue]];
//    productData.selectedTicketOption=selectedTicketOption;
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
