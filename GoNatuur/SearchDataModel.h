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
@property (strong, nonatomic) NSString *searchPageCount;
@property (strong, nonatomic) NSMutableArray *searchKeywordListingArray;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *productImageThumbnail;
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productRating;
@property (strong, nonatomic) NSMutableArray *searchProductListArray;
@property (strong, nonatomic) NSString *specialPrice;
@property (strong, nonatomic) NSString *specialPriceStartDate;
@property (strong, nonatomic) NSString *specialPriceEndDate;
@property (strong, nonatomic) NSString *productQty;
@property (strong, nonatomic) NSString *productType;
@property (strong, nonatomic) NSMutableArray *searchProductIds;
@property (strong, nonatomic) NSString *pageSize;
@property (strong, nonatomic) NSString *wishlistItemId;
@property (strong, nonatomic) NSNumber *isRedeemProduct;
@property (strong, nonatomic) NSNumber *productImpactPoint;

//Singleton method
+ (instancetype)sharedUser;

//Fetch search suggestions
- (void)getSearchSuggestions:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;

//Get search listing data
- (void)getSearchProductListing:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
//Search list pagination data
- (void)getProductListServiceOnSuccess:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
//Wishlist data
- (void)getWishlistService:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
//remove from wishlist
- (void)removeFromWishlist:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
//Search list by name data
- (void)getProductListByNameServiceOnSuccess:(void (^)(SearchDataModel *))success onfailure:(void (^)(NSError *))failure;
@end
