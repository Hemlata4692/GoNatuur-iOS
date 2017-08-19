//
//  SearchService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchService.h"
#import "SearchDataModel.h"

static NSString *kSearchSuggestions=@"search/ajax/suggest/?";
static NSString *kSearchListing=@"ranosys/getSearchList?";

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
    NSDictionary *parameters = @{@"keyword":searchData.serachKeyword,@"currentPage":searchData.searchPageCount,@"pageSize":@"10"};
    NSLog(@"search list request %@",parameters);
    [super post:kSearchListing parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
