//
//  CartDataModel.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartDataModel : NSObject
@property (strong, nonatomic) NSNumber *itemId;
@property (strong, nonatomic) NSString *itemName;
@property (strong, nonatomic) NSNumber *itemPrice;
@property (strong, nonatomic) NSNumber *itemQty;
@property (strong, nonatomic) NSString *itemSku;
@property (strong, nonatomic) NSString *itemDescription;
@property (strong, nonatomic) NSString *itemImageUrl;
@property (strong, nonatomic) NSNumber *itemQuoteId;
@property (strong, nonatomic) NSNumber *checkoutImpactPoint;
@property (strong, nonatomic) NSMutableArray *itemList;
@property (strong, nonatomic) NSMutableDictionary *billingAddressDict;
@property (strong, nonatomic) NSMutableDictionary *shippingAddressDict;
@property (strong, nonatomic) NSMutableDictionary *customerDict;
@property (strong, nonatomic) NSMutableArray *customerSavedAddressArray;
@property (strong, nonatomic) NSMutableArray *shippmentMethodsArray;
@property (strong, nonatomic) NSMutableArray *checkoutPromosArray;
@property (strong, nonatomic) id cartListResponse;

//Singleton instanse
+ (instancetype)sharedUser;

//Cart listing data
- (void)getCartListingData:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Remove item from cart
- (void)removeItemFromCart:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Fetch shippment methods
- (void)fetchShippmentMethodsOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
//Fetch checkout promos
- (void)fetchCheckoutPromosOnSuccess:(void (^)(CartDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
