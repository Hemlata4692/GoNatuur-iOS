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
@end
