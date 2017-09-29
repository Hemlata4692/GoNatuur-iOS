//
//  SortFilterService.m
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SortFilterService.h"
#import "SortFilterModel.h"

@implementation SortFilterService

static NSString *kSortData=@"ranosys/products/attributes";

#pragma mark - Sorting
- (void)getSortData:(SortFilterModel *)sortData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure {
    NSDictionary *parameters = parameters = @{@"searchCriteria" : @{@"filter_groups" : @[
                                                                            @{@"filters":@[
                                                                                      @{@"field":@"attribute_code",
                                                                                        @"value":sortData.requestValues,
                                                                                        @"condition_type": @"in"
                                                                                        }
                                                                                      ],
                                                                              }
                                                                            ],
                                                                    @"sort_orders":@[
                                                                            @{@"field":@"attribute_id",
                                                                              @"direction":DESC,
                                                                              }
                                                                            ],
                                                                    @"page_size" : @0,
                                                                    @"current_page" : @0
                                                                    },
                                              @"total_count" : @0
                                              };
    
    NSLog(@" request %@",parameters);
    [super post:kSortData parameters:parameters success:success failure:failure];
}
#pragma mark - end

@end
