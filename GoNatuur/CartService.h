//
//  CartService.h
//  GoNatuur
//
//  Created by Ranosys on 01/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CartDataModel;
@interface CartService : Webservice

//Fetch cart listing
- (void)getCartListing:(CartDataModel *)reviewData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
