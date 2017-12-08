//
//  SearchService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchService.h"
#import "SearchDataModel.h"

static NSString *kProductListData=@"ranosys/productsList";
static NSString *kSearchSuggestions=@"search/ajax/suggest/?";
static NSString *kSearchListing=@"ranosys/getSearchList";
static NSString *kWishlistService=@"ipwishlist/items";
static NSString *kRemoveWishlistService=@"ipwishlist/delete/wishlistItem";
static NSString *kRecentlyViewedService=@"recentlyviewed/mine?";

@implementation SearchService

#pragma mark - Fetch search keywords
- (void)getSearchKeywordData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"q":searchData.serachKeyword};
    NSLog(@"search list request %@",parameters);
    [super getSearchData:kSearchSuggestions parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Recently viewd products
- (void)getRecentlyViewdDataFromService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    //pageSize=10&curPage=1
    NSDictionary *parameters = @{@"pageSize":@"0",@"curPage":@1};
    NSLog(@"recently viewed request %@",parameters);
    [super get:kRecentlyViewedService parameters:parameters onSuccess:success onFailure:failure];
}
#pragma mark - end

#pragma mark - Search listing data
- (void)getSearchListing:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"keyword":searchData.serachKeyword,@"pageSize":searchData.searchPageCount};
    NSLog(@"search list request %@",parameters);
    [super post:kSearchListing parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Search list pagination data
- (void)getProductListService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"entity_id",
                                                                             @"value":productData.productId,
                                                                             @"condition_type": @"in"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"page_size" : productData.searchPageCount,
                                                       @"current_page" : @0
                                                       }
                                 };
     NSLog(@"search pagination  request %@",parameters);
    [super post:kProductListData parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Wishlist data
- (void)getWishlistService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"",
                                                                             @"value":@"",
                                                                             @"condition_type": @""
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"sort_orders" : @[
                                                                           @{@"field":@"wishlist_item_id",
                                                                             @"direction":DESC,
                                                                             }
                                                                           ],
                                                       @"page_size" : productData.searchPageCount,
                                                       @"current_page" : productData.pageSize
                                                       }
                                 };
    DLog(@"wishlist request %@",parameters);
    [super post:kWishlistService parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Remove from wishlist
- (void)removeFromWishlistService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"customerId":[UserDefaultManager getValue:@"userId"],@"wishlistItemId":productData.wishlistItemId};
    
    DLog(@"remove wishlist request %@",parameters);
    [super post:kRemoveWishlistService parameters:parameters success:success failure:failure];
}
#pragma mark - end

#pragma mark - Search list by name data
- (void)getProductListByNameService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"sku",
                                                                             @"value":productData.productName,
                                                                             @"condition_type": @"in"
                                                                             }
                                                                           ]
                                                                   }
                                                               ],
                                                       @"page_size" : @0,
                                                       @"current_page" : @0
                                                       }
                                 };
    [super post:kProductListData parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
