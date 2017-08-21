//
//  ConnectionManager.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoginModel;
@class DashboardDataModel;
@class SearchDataModel;
@class CurrencyDataModel;
@class NotificationDataModel;
@class ReviewDataModel;
@class ProductDataModel;

@interface ConnectionManager : NSObject

//Singleton method
+ (instancetype)sharedManager;
//Authentication token
- (void)getAccessToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Save device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Login as guest user
- (void)loginGuestUser:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//CMS page service
- (void)CMSPageService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//Forgot password service
- (void)forgotPasswordService:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Reset password service
- (void)resetPasswordService:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure;
//Get category listing
- (void)getCategoryListing:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Get dashboard data
- (void)getDashboardData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Get currency data
- (void)getDefaultCurrency:(CurrencyDataModel *)userData onSuccess:(void (^)(CurrencyDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//SignUp user service
- (void)signUpUserService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//Search keyword
- (void)getSearchSuggestionData:(SearchDataModel *)userData onSuccess:(void (^)(SearchDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//notification listing
- (void)getNotificationListingData:(NotificationDataModel *)userData onSuccess:(void (^)(NotificationDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Mark notification read
- (void)markNotificationAsRead:(NotificationDataModel *)userData onSuccess:(void (^)(NotificationDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Product list data service
- (void)getProductListService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Category banner service
- (void)getCategoryBannerData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Search listing data
- (void)getSearchData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Review listing data
- (void)getReviewListing:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Product detail service
- (void)getProductDetail:(ProductDataModel *)userData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Add to wishlist
- (void)addToWishlistService:(ProductDataModel *)wishlistData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Follow product
- (void)followProduct:(ProductDataModel *)followData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Add review
- (void)addReview:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Ration options
- (void)getRationOptions:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure;
@end
