//
//  ProductDataModel.h
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDataModel : NSObject
@property (strong, nonatomic) NSNumber *categoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *productMediaUrl;
@property (strong, nonatomic) NSString *productMediaType;
@property (strong, nonatomic) NSNumber *productPrice;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *productSubtitle;
@property (strong, nonatomic) NSString *productShortDescription;
@property (strong, nonatomic) NSString *productImageThumbnail;
@property (strong, nonatomic) NSString *productBenefitsUsage;
@property (strong, nonatomic) NSString *productBrandStory;
@property (strong, nonatomic) NSString *productWhereToBuy;
@property (strong, nonatomic) NSNumber *productId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productRating;
@property (strong, nonatomic) NSString *following;
@property (strong, nonatomic) NSString *wishlist;
@property (strong, nonatomic) NSString *reviewId;
@property (strong, nonatomic) NSString *reviewAdded;
@property (strong, nonatomic) NSString *productUrlKey;
@property (strong, nonatomic) NSString *productPointsEarn;
@property (strong, nonatomic) NSNumber *productMaxQuantity;
@property (strong, nonatomic) NSNumber *productMinQuantity;
@property (strong, nonatomic) NSNumber *productQuantity;
@property (strong, nonatomic) NSMutableArray *productDataArray;
@property (strong, nonatomic) NSMutableArray *productMediaArray;
@property (strong, nonatomic) NSString *productSku;
@property (strong, nonatomic) NSString *specialPrice;
@property (strong, nonatomic) NSString *eventPrice;
@property (strong, nonatomic) NSString *avg_rating_percent;
@property (strong, nonatomic) NSMutableArray *attendiesArray;
@property (strong, nonatomic) NSMutableArray *ticketingArray;
@property (strong, nonatomic) NSMutableArray *locationDataArray;
@property (strong, nonatomic) NSString *selectedTicketOption;
@property (strong, nonatomic) NSString *selectedTicketOptionValue;
//Singleton method
+ (instancetype)sharedUser;

//Fetch product detail 
- (void)getProductDetailOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Add to wish list
- (void)addProductWishlistOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Remove wish list
- (void)removeProductWishlistOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Follow product
- (void)followProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Unfollow product
- (void)unFollowProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Add to cart service
- (void)addToCartProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;

//Add to events to cart
- (void)addEventsToCartProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
