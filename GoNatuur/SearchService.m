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

@implementation SearchService

#pragma mark - Fetch search keywords
- (void)getSearchKeywordData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"q":searchData.serachKeyword};
    NSLog(@"search list request %@",parameters);
    [super getSearchData:kSearchSuggestions parameters:parameters onSuccess:success onFailure:failure];
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
                                                       @"page_size" : @0,
                                                       @"current_page" : @0
                                                       }
                                 };
    [super post:kProductListData parameters:parameters success:success failure:failure];
}

#pragma mark - Search list by name data
- (void)getProductListByNameService:(SearchDataModel *)productData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                               @{
                                                                   @"filters":@[
                                                                           @{@"field":@"name",
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
