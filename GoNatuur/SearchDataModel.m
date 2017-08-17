//
//  SearchDataModel.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchDataModel.h"
#import "ConnectionManager.h"

@implementation SearchDataModel
@synthesize serachKeyword;
@synthesize keywordID;
@synthesize keywordName;
@synthesize keywordAction;
@synthesize searchResultCount;
@synthesize searchKeywordListingArray;

#pragma mark - Shared instance
+ (instancetype)sharedUser {
    static SearchDataModel *searchData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        searchData = [[[self class] alloc] init];
    });
    return searchData;
}
#pragma mark - end

#pragma mark - Get serach suggestions
- (void)getSearchSuggestions:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getSearchSuggestionData:self onSuccess:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end
@end
