//
//  SearchDataModel.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchDataModel : NSObject
@property (strong, nonatomic) NSString *serachKeyword;
@property (strong, nonatomic) NSString *keywordID;
@property (strong, nonatomic) NSString *keywordName;
@property (strong, nonatomic) NSString *keywordAction;
@property (strong, nonatomic) NSString *searchResultCount;
@property (strong, nonatomic) NSMutableArray *searchKeywordListingArray;

//Singleton method
+ (instancetype)sharedUser;

//Fetch search suggestions
- (void)getSearchSuggestions:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
