//
//  UpdateCartItem.m
//  GoNatuur
//
//  Created by apple on 20/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "UpdateCartItem.h"

@implementation UpdateCartItem

+ (void)addProductCartItem:(ProductDataModel *)productModelData {
    if (![myDelegate.productCartItemKeys containsObject:[NSString stringWithFormat:@"%@_%@",productModelData.categoryId, productModelData.productId]]) {
        [myDelegate.productCartItemKeys addObject:[NSString stringWithFormat:@"%@_%@",productModelData.categoryId, productModelData.productId]];
    }
    [myDelegate.productCartItemsDetail setObject:[productModelData copy] forKey:[NSString stringWithFormat:@"%@_%@",productModelData.categoryId, productModelData.productId]];
}
@end
