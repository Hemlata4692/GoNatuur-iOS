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
@synthesize productPrice;
@synthesize productDescription;
@synthesize productImageThumbnail;
@synthesize productId;
@synthesize productName;
@synthesize productRating;
@synthesize searchProductListArray;
@synthesize specialPrice;
@synthesize specialPriceEndDate;
@synthesize specialPriceStartDate;
@synthesize productQty;
@synthesize searchProductIds;
@synthesize pageSize;
@synthesize wishlistItemId;
@synthesize isRedeemProduct;
@synthesize productImpactPoint;

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

#pragma mark - Get search suggestions
- (void)getSearchSuggestions:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getSearchSuggestionData:self onSuccess:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onFailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Get search listing
- (void)getSearchProductListing:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getSearchData:self success:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onfailure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end

#pragma mark - Search list pagination data
- (void)getProductListServiceOnSuccess:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getProductListService:self success:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onfailure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end

#pragma mark - Wishlist data
- (void)getWishlistService:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getWishlistData:self success:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onfailure:^(NSError *error) {
        
    }] ;
}
#pragma mark - end

#pragma mark - Remove wishlist data
- (void)removeFromWishlist:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] removeFromWishlistData:self success:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onfailure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end

#pragma mark - Search list by name data
- (void)getProductListByNameServiceOnSuccess:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure {
    [[ConnectionManager sharedManager] getProductListByNameService:self success:^(SearchDataModel *userData) {
        if (success) {
            success (userData);
        }
    } onfailure:^(NSError *error) {
        
    }] ;
    
}
#pragma mark - end
@end
