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
@synthesize productBrandStory;
@synthesize productBenefitsUsage;
@synthesize wishlist;
@synthesize following;
@synthesize productSubtitle;
@synthesize productWhereToBuy;
@synthesize productUrlKey;
@synthesize reviewAdded;
@synthesize reviewId;
@synthesize productMinQuantity;
@synthesize productSku;
@synthesize specialPrice;
@synthesize specialPriceEndDate;
@synthesize specialPriceStartDate;
@synthesize avg_rating_percent;
@synthesize attendiesArray;
@synthesize ticketingArray;
@synthesize locationDataArray;
@synthesize eventPrice;
@synthesize selectedTicketOptionValue;
@synthesize selectedTicketOption;
@synthesize redeemPointsRequired;
@synthesize shippingText;
@synthesize tierPricesArray;
@synthesize productVideoDefault;
@synthesize productVideoDefaultThumbnail;
@synthesize sharingType;
@synthesize socialMediaType;

- (id)copyWithZone:(NSZone *)zone {
    ProductDataModel *another = [[ProductDataModel alloc] init];
    another.categoryId= [self.categoryId copyWithZone: zone];
    another.categoryName= [self.categoryName copyWithZone: zone];
    another.productMediaUrl= [self.productMediaUrl copyWithZone: zone];
    another.productMediaType= [self.productMediaType copyWithZone: zone];
    another.productPrice= [self.productPrice copyWithZone: zone];
    another.productDescription= [self.productDescription copyWithZone: zone];
    another.productShortDescription= [self.productShortDescription copyWithZone: zone];
    another.productBrandStory= [self.productBrandStory copyWithZone: zone];
    another.productBenefitsUsage= [self.productBenefitsUsage copyWithZone: zone];
    another.productImageThumbnail= [self.productImageThumbnail copyWithZone: zone];
    another.productId= [self.productId copyWithZone: zone];
    another.productName= [self.productName copyWithZone: zone];
    another.productRating= [self.productRating copyWithZone: zone];
    another.productPointsEarn= [self.productPointsEarn copyWithZone: zone];
    another.productMaxQuantity= [self.productMaxQuantity copyWithZone: zone];
    another.productQuantity= [self.productQuantity copyWithZone: zone];
    another.productDataArray= [self.productDataArray copyWithZone: zone];
    another.productMediaArray= [self.productMediaArray copyWithZone: zone];
    another.productMinQuantity= [self.productMinQuantity copyWithZone: zone];
    another.productSku= [self.productSku copyWithZone: zone];
    another.specialPrice= [self.specialPrice copyWithZone: zone];
    another.attendiesArray= [self.attendiesArray copyWithZone: zone];
    another.ticketingArray= [self.ticketingArray copyWithZone: zone];
    another.locationDataArray= [self.locationDataArray copyWithZone: zone];
    another.eventPrice= [self.eventPrice copyWithZone: zone];
    another.selectedTicketOption=[self.selectedTicketOption copyWithZone:zone];
    another.redeemPointsRequired= [self.redeemPointsRequired copyWithZone: zone];
    another.shippingText=[self.shippingText copyWithZone:zone];
    another.tierPricesArray=[self.tierPricesArray copyWithZone:zone];
    another.productVideoDefault=[self.productVideoDefault copyWithZone:zone];
    another.productVideoDefaultThumbnail=[self.productVideoDefaultThumbnail copyWithZone:zone];
    another.sharingType=[self.sharingType copyWithZone:zone];
    another.socialMediaType=[self.socialMediaType copyWithZone:zone];
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

#pragma mark - Fetch subscription detail
- (void)getSubscriptionDetailOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getSubscriptionDetail:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end//shareProductService

#pragma mark - Share service
- (void)shareProductDataService:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] shareProductService:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end//shareProductService

#pragma mark - Add to wishlist
- (void)addProductWishlistOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] addToWishlistService:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Add to cart service
- (void)addToCartProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] addToCartProductService:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Add events to cart
- (void)addEventsToCartProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] addEventsToCartProductService:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end


#pragma mark - Follow product
- (void)followProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] followProduct:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Remove from wishlist
- (void)removeProductWishlistOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] removeWishlistService:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Unfollow product
- (void)unFollowProductOnSuccess:(void (^)(ProductDataModel *))success onfailure:(void (^)(NSError *))failure{
    [[ConnectionManager sharedManager] unFollowProduct:self onSuccess:^(ProductDataModel *productData) {
        if (success) {
            success (productData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
