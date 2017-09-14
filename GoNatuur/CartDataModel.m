//
//  CartDataModel.m
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CartDataModel.h"
#import "ConnectionManager.h"

@implementation CartDataModel
@synthesize itemId;
@synthesize itemName;
@synthesize itemPrice;
@synthesize itemQty;
@synthesize itemSku;
@synthesize itemQuoteId;
@synthesize itemList;
@synthesize cartListResponse;
@synthesize billingAddressDict;
@synthesize shippingAddressDict;
@synthesize customerDict;
@synthesize customerSavedAddressArray;
@synthesize shippmentMethodsArray;
@synthesize checkoutPromosArray;
@synthesize checkoutImpactPoint;
@synthesize selectedShippingMethod;
@synthesize promoPoints;
@synthesize promoDiscountValue;
@synthesize checkoutFinalData;
@synthesize paymentMethod;

- (id)copyWithZone:(NSZone *)zone {
    CartDataModel *another = [[CartDataModel alloc] init];
    another.itemId= [self.itemId copyWithZone: zone];
    another.itemName= [self.itemName copyWithZone: zone];
    another.itemPrice= [self.itemPrice copyWithZone: zone];
    another.itemQty= [self.itemQty copyWithZone: zone];
    another.itemSku= [self.itemSku copyWithZone: zone];
    another.itemQuoteId= [self.itemQuoteId copyWithZone: zone];
    another.itemList= [self.itemList copyWithZone: zone];
    another.cartListResponse= [self.cartListResponse copyWithZone: zone];
    another.billingAddressDict= [self.billingAddressDict copyWithZone: zone];
    another.shippingAddressDict= [self.shippingAddressDict copyWithZone: zone];
    another.customerDict= [self.customerDict copyWithZone: zone];
    another.customerSavedAddressArray= [self.customerSavedAddressArray copyWithZone: zone];
    another.shippmentMethodsArray= [self.shippmentMethodsArray copyWithZone: zone];
    another.checkoutPromosArray= [self.checkoutPromosArray copyWithZone: zone];
    another.checkoutImpactPoint= [self.checkoutImpactPoint copyWithZone: zone];
    another.selectedShippingMethod= [self.selectedShippingMethod copyWithZone: zone];
    another.promoPoints= [self.promoPoints copyWithZone: zone];
    another.promoDiscountValue= [self.promoDiscountValue copyWithZone: zone];
    another.checkoutFinalData= [self.checkoutFinalData copyWithZone: zone];
    another.paymentMethod= [self.paymentMethod copyWithZone: zone];
    return another;
}

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static CartDataModel *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[[self class] alloc] init];
    });
    return data;
}
#pragma mark - end

#pragma mark - Cart listing data
- (void)getCartListingData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure{
    [[ConnectionManager sharedManager] getCartListing:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Fetch shippment methods
- (void)fetchShippmentMethodsOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] fetchShippmentMethods:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Fetch checkout promos
- (void)fetchCheckoutPromosOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] fetchCheckoutPromos:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] setUpdatedAddressShippingMethodsService:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Remove item from cart
- (void)removeItemFromCart:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] removeItemFromCart:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Set checkout promo
- (void)setCheckoutPromosOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] setCheckoutPromosService:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Set payment method
- (void)setPaymentMethodOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] setPaymentMethodService:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Set checkout order
- (void)setCheckoutOrderOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] setCheckoutOrderService:self onSuccess:^(CartDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
