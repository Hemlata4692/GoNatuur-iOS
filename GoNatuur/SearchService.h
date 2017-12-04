//
//  SearchService.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SearchDataModel;

@interface SearchService : Webservice

//Fetch search keyword data
- (void)getSearchKeywordData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Get search listing data
- (void)getSearchListing:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Search list pagination data
- (void)getProductListService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Wishlist service data
- (void)getWishlistService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove from wishlist
- (void)removeFromWishlistService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Search list by name data
- (void)getProductListByNameService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Recently viewed data
- (void)getRecentlyViewdDataFromService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
@end
