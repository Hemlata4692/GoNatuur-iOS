//
//  SearchService.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchService.h"
#import "SearchDataModel.h"

static NSString *kSearchSuggestions=@"ranosys/getSearchSuggestions";

@implementation SearchService

#pragma mark - Fetch search keywords
- (void)getSearchKeywordData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = @{@"keyword":searchData.serachKeyword,@"limit":@"15"};
    NSLog(@"search list request %@",parameters);
    [super post:kSearchSuggestions parameters:parameters success:success failure:failure];
}
#pragma mark - end
@end
