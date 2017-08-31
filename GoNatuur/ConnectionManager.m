//
//  ConnectionManager.m
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 24/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ConnectionManager.h"
#import "LoginService.h"
#import "LoginModel.h"
#import "DashboardDataModel.h"
#import "DashboardService.h"
#import "SearchDataModel.h"
#import "SearchService.h"
#import "CurrencyDataModel.h"
#import "NotificationService.h"
#import "NotificationDataModel.h"
#import "ReviewDataModel.h"
#import "ReviewService.h"
#import "ProductDataModel.h"
#import "ProductService.h"
#import "ProfileModel.h"
#import "ProfileService.h"

@implementation ConnectionManager
#pragma mark - Shared instance

+ (instancetype)sharedManager {
    static ConnectionManager *connectionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connectionManager = [[[self class] alloc] init];
    });
    return connectionManager;
}
#pragma mark - end

#pragma mark - Community code
- (void)getAccessToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *authToken = [[LoginService alloc] init];
    //parse data from server response and store in datamodel
    [authToken getAccessToken:userData onSuccess:^(id response) {
        
        
        success(response);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login user
- (void)loginUser:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginUser:userData onSuccess:^(id response) {
        DLog(@"login response %@",response);
        //Parse data from server response and store in datamodel
        userData.userId=[[response objectForKey:@"customer"] objectForKey:@"id"];
        userData.profilePicture=[[response objectForKey:@"customer"] objectForKey:@"profile_pic"];
        userData.accessToken=[response objectForKey:@"api_key"];
        userData.followCount=[response objectForKey:@"follow_count"];
        userData.notificationsCount=[response objectForKey:@"notifications_count"];
        userData.quoteId=[response objectForKey:@"quote_id"];
        userData.quoteCount=[response objectForKey:@"quote_count"];
        userData.wishlistCount=[response objectForKey:@"wishlist_count"];
        userData.firstName=[[response objectForKey:@"customer"] objectForKey:@"firstname"];
        userData.lastName=[[response objectForKey:@"customer"] objectForKey:@"lastname"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Login as guest user
- (void)loginGuestUser:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService loginGuestUser:^(id response) {
        //Parse data from server response and store in data model
        userData.quoteId=[[response objectAtIndex:0] objectForKey:@"quote_id"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    {
        LoginService *loginService = [[LoginService alloc] init];
        [loginService saveDeviceTokenService:userData onSuccess:^(id response) {
            success(userData);
        } onFailure:^(NSError *error) {
            failure(error);
        }] ;
        
    }
}

#pragma mark - CMS page service
- (void)CMSPageService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService CMSPageService:userData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"CMS page response %@",response);
        userData.cmsTitle=[[[response objectForKey:@"items"] objectAtIndex:0] objectForKey:@"title"];
        userData.cmsContent=[[[response objectForKey:@"items"] objectAtIndex:0] objectForKey:@"content"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Forgot password service
- (void)forgotPasswordService:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure  {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService forgotPasswordService:userData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        userData.otpNumber=[[response  objectAtIndex:0] objectForKey:@"resetOTP"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Reset password service
- (void)resetPasswordService:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure  {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService resetPasswordService:userData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        userData.successMessage=response[@"message"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Category listing service
- (void)getCategoryListing:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *categoryList=[[DashboardService alloc]init];
    [categoryList getCategoryListData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"category list response %@",response);
        //        myDelegate.categoryNameArray=[response[@"children_data"] mutableCopy];
        userData.categoryNameArray=[response[@"children_data"] mutableCopy];
        success(userData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - SignUp user service
- (void)signUpUserService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService signUpUserService:userData onSuccess:^(id response) {
        DLog(@"signup response %@",response);
        //Parse data from server response and store in datamodel
        userData.userId=[[response objectForKey:@"customer"] objectForKey:@"id"];
        userData.profilePicture=[[response objectForKey:@"customer"] objectForKey:@"profile_pic"];
        userData.accessToken=[response objectForKey:@"api_key"];
        userData.followCount=[response objectForKey:@"follow_count"];
        userData.notificationsCount=[response objectForKey:@"notifications_count"];
        userData.quoteId=[response objectForKey:@"quote_id"];
        userData.quoteCount=[response objectForKey:@"quote_count"];
        userData.firstName=[[response objectForKey:@"customer"] objectForKey:@"firstname"];
        userData.lastName=[[response objectForKey:@"customer"] objectForKey:@"lastname"];
        userData.wishlistCount=[response objectForKey:@"wishlist_count"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Dashboard data service
- (void)getDashboardData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *categoryList=[[DashboardService alloc]init];
    [categoryList getDashboardData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"dashboard data response %@",response);
        userData.bannerImageArray=[[NSMutableArray alloc]init];
        userData.notificationsCount=response[@"notification_count"];
        userData.profilePicture=response[@"profile_pick"];
        userData.firstName=response[@"firstname"];
        userData.lastName=response[@"lastname"];
        NSArray *bannerArray=response[@"banner"];
        for (int i =0; i<bannerArray.count; i++) {
            NSDictionary * bannerDataDict =[bannerArray objectAtIndex:i];
            DashboardDataModel * bannerData = [[DashboardDataModel alloc]init];
            bannerData.banerImageUrl = bannerDataDict[@"image"];
            bannerData.banerImageId = bannerDataDict[@"action_id"];
            bannerData.bannerImageType = bannerDataDict[@"action"];
            [userData.bannerImageArray addObject:bannerData];
        }
        userData.bestSellerArray=[[NSMutableArray alloc]init];
        NSArray *productDataArray=response[@"best_seller_slider"];
        for (int i =0; i<productDataArray.count; i++) {
            [userData.bestSellerArray addObject:[self getDashboardParseData:[productDataArray objectAtIndex:i]]];
        }
        userData.healthyLivingArray=[[NSMutableArray alloc]init];
        NSArray *healthyLivingArray=response[@"category_tab1"];
        for (int i =0; i<healthyLivingArray.count; i++) {
            [userData.healthyLivingArray addObject:[self getDashboardParseData:[healthyLivingArray objectAtIndex:i]]];
        }
        userData.samplersDataArray=[[NSMutableArray alloc]init];
        NSArray *samplersArray=response[@"category_tab2"];
        for (int i =0; i<samplersArray.count; i++) {
            [userData.samplersDataArray addObject:[self getDashboardParseData:[samplersArray objectAtIndex:i]]];
        }
        userData.footerBannerImageArray=[[NSMutableArray alloc]init];
        NSArray *footerArray=response[@"footer_top_banners"];
        for (int i =0; i<footerArray.count; i++) {
            NSDictionary * footerDataDict =[footerArray objectAtIndex:i];
            DashboardDataModel * bannerData = [[DashboardDataModel alloc]init];
            bannerData.banerImageUrl = footerDataDict[@"image"];
            bannerData.banerImageId = footerDataDict[@"action_id"];
            bannerData.bannerImageType = footerDataDict[@"action"];
            [userData.footerBannerImageArray addObject:bannerData];
        }
        success(userData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
}

- (DashboardDataModel *)getDashboardParseData:(NSDictionary *)productDataDict {
    DashboardDataModel * productData = [[DashboardDataModel alloc]init];
    productData.productId = productDataDict[@"id"];
    productData.productPrice = [productDataDict[@"price"] stringValue];
    productData.productName = productDataDict[@"name"];
    if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
        productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
    }
    productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
    productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
    productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
    productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
    return productData;
}
#pragma mark - end

#pragma mark - Convert HTML in string
- (NSString *)stringByStrippingHTML:(NSString *)str {
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    return str;
}
#pragma mark - end

#pragma mark - Fetch currency data
- (void)getDefaultCurrency:(CurrencyDataModel *)userData onSuccess:(void (^)(CurrencyDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *currencyData=[[DashboardService alloc]init];
    [currencyData getCurrency:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"currency list response %@",response);
        userData.userCurrency=response[@"default_display_currency_symbol"];
        userData.currentCurrencyCode=response[@"default_display_currency_code"];
        userData.availableCurrencyArray=[response[@"available_currency_codes"] mutableCopy];
        userData.availableCurrencyRatesArray=[[NSMutableArray alloc]init];
        NSArray *ratesArray=response[@"exchange_rates"];
        for (int i =0; i<ratesArray.count; i++) {
            NSDictionary * footerDataDict =[ratesArray objectAtIndex:i];
            CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
            exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
            exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
            [userData.availableCurrencyRatesArray addObject:exchangeData];
        }
        success(userData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Fetch search suggestions data
- (void)getSearchSuggestionData:(SearchDataModel *)userData onSuccess:(void (^)(SearchDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getSearchKeywordData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"SearchService keyword response %@",response);
        userData.searchKeywordListingArray=[[NSMutableArray alloc]init];
        NSArray *searchArray=[response mutableCopy];
        for (int i =0; i<searchArray.count; i++) {
            NSDictionary * searchDataDict =[searchArray objectAtIndex:i];
            SearchDataModel * searchData = [[SearchDataModel alloc]init];
            searchData.keywordName = searchDataDict[@"title"];
            searchData.searchResultCount = searchDataDict[@"num_results"];
            [userData.searchKeywordListingArray addObject:searchData];
        }
        success(userData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Search listing data
- (void)getSearchData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getSearchListing:searchData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"SearchService list response %@",response);
        searchData.searchProductListArray=[[NSMutableArray alloc]init];
        NSArray *productDataArray=response[@"items"];
        for (int i =0; i<productDataArray.count; i++) {
            NSDictionary * productDataDict =[productDataArray objectAtIndex:i];
            SearchDataModel * productData = [[SearchDataModel alloc]init];
            productData.productId = productDataDict[@"id"];
            productData.productPrice = [productDataDict[@"price"] stringValue];
            productData.productName = productDataDict[@"name"];
            if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[productDataDict objectForKey:@"type_id"];
            [searchData.searchProductListArray addObject:productData];
        }
        searchData.searchResultCount=response[@"total_count"];
        searchData.searchProductIds=[response[@"relevance_items"] mutableCopy];
        success(searchData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Search list pagination data
- (void)getProductListService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getProductListService:searchData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"SearchService list response %@",response);
        searchData.searchProductListArray=[[NSMutableArray alloc]init];
        NSArray *productDataArray=response[@"items"];
        for (int i =0; i<productDataArray.count; i++) {
            NSDictionary * productDataDict =[productDataArray objectAtIndex:i];
            SearchDataModel * productData = [[SearchDataModel alloc]init];
            productData.productId = productDataDict[@"id"];
            productData.productPrice = [productDataDict[@"price"] stringValue];
            productData.productName = productDataDict[@"name"];
            if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[productDataDict objectForKey:@"type_id"];
            [searchData.searchProductListArray addObject:productData];
        }
        searchData.searchResultCount=response[@"total_count"];
        searchData.searchProductIds=[response[@"relevance_items"] mutableCopy];
        success(searchData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Notification listing
- (void)getNotificationListingData:(NotificationDataModel *)userData onSuccess:(void (^)(NotificationDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    NotificationService *dataList=[[NotificationService alloc]init];
    [dataList getUserNotificationData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"notification list response %@",response);
        userData.notificationListArray=[[NSMutableArray alloc]init];
        NSArray *notificationArray=response[@"items"];
        for (int i =0; i<notificationArray.count; i++) {
            NSDictionary * dataDict =[notificationArray objectAtIndex:i];
            NotificationDataModel * notiData = [[NotificationDataModel alloc]init];
            notiData.notificationId = dataDict[@"id"];
            notiData.notificationType = dataDict[@"type"];
            notiData.notificationMessage = dataDict[@"message"];
            notiData.targetId = dataDict[@"targat_id"];
            notiData.notificationStatus = dataDict[@"status"];
            [userData.notificationListArray addObject:notiData];
        }
        userData.totalCount=response[@"total_count"];
        success(userData);
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Notification read/unread
- (void)markNotificationAsRead:(NotificationDataModel *)userData onSuccess:(void (^)(NotificationDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    NotificationService *dataList=[[NotificationService alloc]init];
    [dataList markNotification:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"notification response %@",response);
        success(userData);
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Category banner service
- (void)getCategoryBannerData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *categoryList=[[DashboardService alloc]init];
    [categoryList getCategoryBannerData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"category list response %@",response);
        userData.banerImageUrl=@"";
        if (nil!=[response objectForKey:@"custom_attributes"]) {
            for (int i=0; i<[[response objectForKey:@"custom_attributes"] count]; i++) {
                if ([[[[response objectForKey:@"custom_attributes"] objectAtIndex:i] objectForKey:@"attribute_code"] isEqualToString:@"image"]) {
                    userData.banerImageUrl=[[[response objectForKey:@"custom_attributes"] objectAtIndex:i] objectForKey:@"value"];
                    break;
                }
            }
        }
        success(userData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Product list data service
- (void)getProductListService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *productList=[[DashboardService alloc]init];
    [productList getProductListService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"product list response %@",response);
        productData.totalProductCount=[response objectForKey:@"total_count"];
        productData.productDataArray=[NSMutableArray new];
        productData.banerImageUrl=@"";
        for (int i=0; i<[[response objectForKey:@"items"] count]; i++) {
            DashboardDataModel *tempModel=[[DashboardDataModel alloc] init];
            tempModel.productId=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"id"];
            tempModel.productName=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"name"];
            tempModel.productPrice=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"price"];
            tempModel.productImageThumbnail=[[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            if ([[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                tempModel.productDescription=[self stringByStrippingHTML:[[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            tempModel.specialPrice = [[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            tempModel.productQty = [[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            tempModel.productRating = [[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            tempModel.productType=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"type_id"];
            [productData.productDataArray addObject:tempModel];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Product detail service
- (void)getProductDetail:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData getProductDetailService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"product details response %@",response);
        NSDictionary *customAttributeDict=[[[response objectForKey:@"custom_attribute"] objectAtIndex:0] copy];
        productData.productRating=[response objectForKey:@"avg_rating_percent"];
        productData.productName=[response objectForKey:@"name"];
        productData.productPrice=[response objectForKey:@"price"];
        productData.categoryId=[[customAttributeDict objectForKey:@"category_ids"] objectAtIndex:0];
        productData.productSubtitle=[customAttributeDict objectForKey:@"subtitle"];
        productData.productUrlKey=[customAttributeDict objectForKey:@"url_key"];
        if ([customAttributeDict objectForKey:@"description"]!=nil) {
            productData.productDescription=[customAttributeDict objectForKey:@"description"];
        }
        if ([customAttributeDict objectForKey:@"short_description"]!=nil) {
            productData.productShortDescription=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"short_description"]];
        }
        if ([customAttributeDict objectForKey:@"benefits_usage"]!=nil) {
            productData.productBenefitsUsage=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"benefits_usage"]];
        }
        if ([customAttributeDict objectForKey:@"brand_story"]!=nil) {
            productData.productBrandStory=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"brand_story"]];
        }
        productData.productWhereToBuy=[customAttributeDict objectForKey:@"where_buy"];
        productData.productMinQuantity=([[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"min_qty"] intValue]==0?@1:[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"min_qty"]);
        productData.productMaxQuantity=[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"qty"];
        productData.following=[[response objectForKey:@"is_following"] stringValue];
        productData.wishlist=[[response objectForKey:@"is_in_wishlist"] stringValue];
        productData.reviewAdded=[[response objectForKey:@"is_reviewed"] stringValue];
        productData.reviewId=[response objectForKey:@"review_id"];
        productData.productSku=[response objectForKey:@"sku"];
        productData.specialPrice = [customAttributeDict objectForKey:@"special_price"];
        productData.productMediaArray=[NSMutableArray new];
        for (NSDictionary *tempDict in [response objectForKey:@"media"]) {
            if ([[tempDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
                if ([[tempDict objectForKey:@"types"] count]>0&&[[tempDict objectForKey:@"types"] containsObject:@"video_360"]) {
                    [tempDict setValue:@"video_360" forKey:@"media_type"];
                }
            }
            [productData.productMediaArray addObject:tempDict];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Add to cart service
- (void)addToCartProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData addToCartProduct:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"category list response %@",response);
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Review list service
- (void)getReviewListing:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    ReviewService *reviewList=[[ReviewService alloc]init];
    [reviewList getReviewListing:reviewData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"review list response %@",response);
        reviewData.totalCount=[response objectForKey:@"total_count"];
        reviewData.reviewListArray=[NSMutableArray new];
        NSArray *reviewArray=response[@"items"];
        for (int i=0; i<reviewArray.count; i++) {
            NSDictionary * dataDict =[reviewArray objectAtIndex:i];
            ReviewDataModel *tempModel=[[ReviewDataModel alloc] init];
            tempModel.username=[dataDict objectForKey:@"nickname"];
            tempModel.userImageUrl=[dataDict objectForKey:@"profile_pic"];
            tempModel.reviewDescription=[dataDict objectForKey:@"detail"];
            tempModel.reviewTitle=[dataDict objectForKey:@"title"];
            tempModel.reviewId=[dataDict objectForKey:@"review_id"];
            tempModel.ratingId = ([[dataDict objectForKey:@"rating_votes"] count]==0?@"0":[[[dataDict objectForKey:@"rating_votes"] objectAtIndex:0] objectForKey:@"value"]);
            [reviewData.reviewListArray addObject:tempModel];
        }
        success(reviewData);
    }
                       onfailure:^(NSError *error) {
                       }];
}
#pragma mark - end

#pragma mark - Rating options
- (void)getRationOptions:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    ReviewService *reviewList=[[ReviewService alloc]init];
    [reviewList getRatingOptions:reviewData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"rating option list response %@",response);
        reviewData.rationOptionsArray=[[NSMutableArray alloc]init];
        NSArray *ratingArray=[[response objectForKey:@"items"] objectForKey:@"rating_options"];
        for (int i =0; i<ratingArray.count; i++) {
            NSDictionary * dataDict =[ratingArray objectAtIndex:i];
            ReviewDataModel * ratingData = [[ReviewDataModel alloc]init];
            ratingData.ratingId = dataDict[@"rating_id"];
            ratingData.optionId = dataDict[@"option_id"];
            [reviewData.rationOptionsArray addObject:ratingData];
        }
        success(reviewData);
    }
                       onfailure:^(NSError *error) {
                       }];
}
#pragma mark - end

#pragma mark - Add review
- (void)addReview:(ReviewDataModel *)reviewData onSuccess:(void (^)(ReviewDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    ReviewService *reviewList=[[ReviewService alloc]init];
    [reviewList addProductReview:reviewData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"review  response %@",response);
        
        success(reviewData);
    }
                       onfailure:^(NSError *error) {
                       }];
}
#pragma mark - end

#pragma mark - Add to wishlist service
- (void)addToWishlistService:(ProductDataModel *)wishlistData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *addToWishlist=[[ProductService alloc]init];
    [addToWishlist addProductToWishlist:wishlistData success:^(id response) {
        DLog(@"wishlist response %@",response);
        success(wishlistData);
    }
                              onfailure:^(NSError *error) {
                              }];
    
}
#pragma mark - end

#pragma mark - Renove from wishlist service
- (void)removeWishlistService:(ProductDataModel *)wishlistData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *addToWishlist=[[ProductService alloc]init];
    [addToWishlist removeProductFromWishlist:wishlistData success:^(id response) {
        DLog(@"remove wishlist response %@",response);
        success(wishlistData);
    }
                                   onfailure:^(NSError *error) {
                                   }];
    
}
#pragma mark - end

#pragma mark - Follow product service
- (void)followProduct:(ProductDataModel *)followData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *followProduct=[[ProductService alloc]init];
    [followProduct followProduct:followData success:^(id response) {
        DLog(@"follow response %@",response);
        success(followData);
    }
                       onfailure:^(NSError *error) {
                       }];
    
}
#pragma mark - end

#pragma mark - Unfollow product service
- (void)unFollowProduct:(ProductDataModel *)followData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *followProduct=[[ProductService alloc]init];
    [followProduct unFollowProduct:followData success:^(id response) {
        DLog(@"unfollow response %@",response);
        success(followData);
    }
                         onfailure:^(NSError *error) {
                         }];
    
}
#pragma mark - end

#pragma mark - Change password service
- (void)changePasswordService:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService changePasswordService:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Change password service
- (void)getCountryCodeService:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService getCountryCodeService:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"country code list response %@",response);
        profileData.countryCodeArray=[[NSMutableArray alloc]init];
        profileData.regionArray=[[NSMutableArray alloc]init];
        NSArray *countryArray=response;
        for (int i=0; i<countryArray.count; i++) {
            NSDictionary * dataDict =[countryArray objectAtIndex:i];
            ProfileModel *countryData=[[ProfileModel alloc] init];
            countryData.countryLocale=[dataDict objectForKey:@"full_name_locale"];
            countryData.countryId=[dataDict objectForKey:@"id"];
            NSArray *regionListArray = [dataDict objectForKey:@"available_regions"];
            for (int j=0; j<regionListArray.count; j++) {
                NSDictionary * regionDict =[regionListArray objectAtIndex:j];
                countryData.regionId=[regionDict objectForKey:@"id"];
                countryData.regionCode=[regionDict objectForKey:@"code"];
                countryData.regionName=[regionDict objectForKey:@"name"];
                [profileData.regionArray addObject:countryData];
            }
            [profileData.countryCodeArray addObject:countryData];
        }
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end
@end
