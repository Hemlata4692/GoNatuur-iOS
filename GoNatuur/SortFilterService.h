//
//  SortFilterService.h
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SortFilterModel;

@interface SortFilterService : Webservice
//Sort data
- (void)getSortData:(SortFilterModel *)sortData onSuccess:(void (^)(id))success onFailure:(void (^)(NSError *))failure ;

@end
