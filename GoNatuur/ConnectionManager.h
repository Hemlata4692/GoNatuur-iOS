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
@class ProfileModel;
@class CartDataModel;
@class OrderModel;
@class ProductGuideDataModel;
@class PaymentModel;

@interface ConnectionManager : NSObject

//Singleton method
+ (instancetype)sharedManager;
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
//Unfollow product
- (void)unFollowProduct:(ProductDataModel *)followData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure ;
//remove from wishlist
- (void)removeWishlistService:(ProductDataModel *)wishlistData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Add to cart service
- (void)addToCartProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Search list pagination data
- (void)getProductListService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Change password service
- (void)changePasswordService:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Get country code service
- (void)getCountryCodeService:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Save and update address
- (void)saveAndUpdateAddress:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Get user profile data
- (void)getUserProfileData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure ;
//Save user profile
- (void)saveUserProfileData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Get imapct points
- (void)getUserImpactPointsData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Update user profile image
- (void)updateUserProfileImage:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure;
//Wishlist data
- (void)getWishlistData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove from wishlist
- (void)removeFromWishlistData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Cart listing service
- (void)getCartListing:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Search list by name data
- (void)getProductListByNameService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure;
//Remove item from cart
- (void)removeItemFromCart:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure ;
//Order listing
- (void)getOrderListing:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure;
//News centre
- (void)getNewsCenterListService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//News centre detail
- (void)getNewsCenterDetailService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//News centre category
- (void)getNewsCategoryListing:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Subscribe news letter
- (void)newsLetterSubscribe:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure;
//Fetch shippment methods
- (void)fetchShippmentMethods:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Fetch checkout promos
- (void)fetchCheckoutPromos:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure;
//Guide category data
- (void)getGuideCategory:(ProductGuideDataModel *)guideData onSuccess:(void (^)(ProductGuideDataModel *guideData))success onFailure:(void (^)(NSError *))failure;
//Guide category details data
- (void)getGuideDetailsCategory:(ProductGuideDataModel *)guideData onSuccess:(void (^)(ProductGuideDataModel *guideData))success onFailure:(void (^)(NSError *))failure ;
//Cancel order
- (void)cancelOrderService:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure;
//Get ticket option
- (void)getTicketOption:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure;
//Get order invoice
- (void)getOrderInvoice:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure;
//Add events to cart
- (void)addEventsToCartProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure;
//Get card listing
- (void)getCardListing:(PaymentModel *)paymentData onSuccess:(void (^)(PaymentModel *paymentData))success onFailure:(void (^)(NSError *))failure;
//Fetch constants listing service
- (void)getConstantsListData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure;
@end
