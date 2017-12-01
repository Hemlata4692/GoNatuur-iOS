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
#import "CartDataModel.h"
#import "CartService.h"
#import "OrderModel.h"
#import "OrderService.h"
#import "ProductGuideDataModel.h"
#import "ProductGuideService.h"
#import "PaymentService.h"
#import "PaymentModel.h"
#import "ShareDataModel.h"
#import "ShareDataService.h"
#import "SortFilterModel.h"
#import "SortFilterModel.h"
#import "SortFilterService.h"

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
        if (([[[response objectForKey:@"customer"] objectForKey:@"default_currency"] isEqualToString:@""]||[[response objectForKey:@"customer"] objectForKey:@"default_currency"]==nil) ) {
            [UserDefaultManager setValue:[response objectForKey:@"local_currency_code"] key:@"DefaultCurrencyCode"];
        }
        else {
            [UserDefaultManager setValue:[[response objectForKey:@"customer"] objectForKey:@"default_currency"] key:@"DefaultCurrencyCode"];
        }
        if (([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@""]||[[response objectForKey:@"customer"] objectForKey:@"default_language"]==nil) ) {
            [UserDefaultManager setValue:[response objectForKey:@"local_language"] key:@"Language"];
        }
        else {
            if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"4"]) {
                [UserDefaultManager setValue:@"en" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"5"]) {
                [UserDefaultManager setValue:@"zh" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"6"]) {
                [UserDefaultManager setValue:@"cn" key:@"Language"];
            }
        }
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
        NSLog(@"guest login response %@",response);
        userData.quoteId=[response objectForKey:@"quote_id"];
        [UserDefaultManager setValue:[response objectForKey:@"local_language"] key:@"Language"];
        [UserDefaultManager setValue:[response objectForKey:@"local_currency_code"] key:@"DefaultCurrencyCode"];
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Send device token
- (void)sendDevcieToken:(LoginModel *)userData onSuccess:(void (^)(LoginModel *userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService saveDeviceTokenService:userData onSuccess:^(id response) {
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Subscribe newsletter
- (void)newsLetterSubscribe:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService subscriptionNewsLetter:userData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"Subscribe response %@",response);
        success(userData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - CMS page service
- (void)CMSPageService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService CMSPageService:userData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"CMS page response %@",response);
        if ([[response objectForKey:@"items"] count]!=0) {
            userData.cmsTitle=[[[response objectForKey:@"items"] objectAtIndex:0] objectForKey:@"title"];
            userData.cmsContent=[[[response objectForKey:@"items"] objectAtIndex:0] objectForKey:@"content"];
        }
        else {
            userData.cmsTitle=@"";
            userData.cmsContent=@"";
        }
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
        userData.categoryNameArray=[response[@"children_data"] mutableCopy];
        success(userData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

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
        if (([[[response objectForKey:@"customer"] objectForKey:@"default_currency"] isEqualToString:@""]||[[response objectForKey:@"customer"] objectForKey:@"default_currency"]==nil) ) {
            [UserDefaultManager setValue:[response objectForKey:@"local_currency_code"] key:@"DefaultCurrencyCode"];
        }
        else {
            [UserDefaultManager setValue:[[response objectForKey:@"customer"] objectForKey:@"default_currency"] key:@"DefaultCurrencyCode"];
        }
        if (([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@""]||[[response objectForKey:@"customer"] objectForKey:@"default_language"]==nil) ) {
            [UserDefaultManager setValue:[response objectForKey:@"local_language"] key:@"Language"];
        }
        else {
            if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"4"]) {
                [UserDefaultManager setValue:@"en" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"5"]) {
                [UserDefaultManager setValue:@"zh" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"6"]) {
                [UserDefaultManager setValue:@"cn" key:@"Language"];
            }
        }
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
        userData.promotionsDataArray=[[NSMutableArray alloc]init];
        NSArray *promotionsArray=response[@"new_promotions"];
        for (int i =0; i<promotionsArray.count; i++) {
            [userData.promotionsDataArray addObject:[self getDashboardParseData:[promotionsArray objectAtIndex:i]]];
        }
        userData.productsDataArray=[[NSMutableArray alloc]init];
        NSArray *productsArray=response[@"new_products"];
        for (int i =0; i<productsArray.count; i++) {
            [userData.productsDataArray addObject:[self getDashboardParseData:[productsArray objectAtIndex:i]]];
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
        //Check login/guest group
        if ([response[@"group_id"] isKindOfClass:[NSString class]]) {
            [UserDefaultManager setValue:@"promo_apply_Guest" key:@"GroupType"];
            [UserDefaultManager setValue:@"0" key:@"GroupId"];
        }
        else {
            switch ([response[@"group_id"] intValue]) {
                case 1:
                    [UserDefaultManager setValue:@"promo_apply_b2_ccustomer_check" key:@"GroupType"];
                    [UserDefaultManager setValue:response[@"group_id"] key:@"GroupId"];
                    break;
                case 3:
                    [UserDefaultManager setValue:@"promo_apply_b2_breseller_check" key:@"GroupType"];
                    [UserDefaultManager setValue:response[@"group_id"] key:@"GroupId"];
                    break;
                case 4:
                    [UserDefaultManager setValue:@"promo_apply_b2_bfranchise_check" key:@"GroupType"];
                    [UserDefaultManager setValue:response[@"group_id"] key:@"GroupId"];
                    break;
                default:
                    [UserDefaultManager setValue:@"promo_apply_Guest" key:@"GroupType"];
                    [UserDefaultManager setValue:response[@"group_id"] key:@"GroupId"];
                    break;
            }
        }
        //language and code
        if (![[response objectForKey:@"default_currency"] isEqualToString:@""]||[response objectForKey:@"default_currency"]!=nil) {
            [UserDefaultManager setValue:[response objectForKey:@"default_currency"] key:@"DefaultCurrencyCode"];
        }
        
        if (![[response objectForKey:@"default_language"] isEqualToString:@""]||[response objectForKey:@"default_language"]!=nil) {
            if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"4"]) {
                [UserDefaultManager setValue:@"en" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"5"]) {
                [UserDefaultManager setValue:@"zh" key:@"Language"];
            }
            else if ([[[response objectForKey:@"customer"] objectForKey:@"default_language"] isEqualToString:@"6"]) {
                [UserDefaultManager setValue:@"cn" key:@"Language"];
            }
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
    else {
        productData.productDescription=nil;
    }
    productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
    productData.ribbons = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
    productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
    productData.specialPriceStartDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
    productData.specialPriceEndDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
    if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
        productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
    }
    productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
    productData.productType=productDataDict[@"type_id"];
    productData.tierPriceArray=productDataDict[@"tier_prices"];
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
        [UserDefaultManager setValue:response[@"exchange_rates"] key:@"availableCurrencyRatesArray"];
        for (int i =0; i<ratesArray.count; i++) {
            NSDictionary * footerDataDict =[ratesArray objectAtIndex:i];
            CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
            exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
            exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
            exchangeData.currencysymbol = footerDataDict[@"currency_symbol"];
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

#pragma mark - Recently viewed products
- (void)getRecentlyViewedData:(SearchDataModel *)searchData onSuccess:(void (^)(SearchDataModel *searchData))success onFailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getRecentlyViewdDataFromService:searchData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"Recently viewed response %@",response);
        searchData.searchProductListArray=[[NSMutableArray alloc]init];
        NSArray *productDataArray=response[@"items"];
        for (int i =0; i<productDataArray.count; i++) {
            NSDictionary * productDataDict =[productDataArray objectAtIndex:i];
            SearchDataModel * productData = [[SearchDataModel alloc]init];
            productData.productId = productDataDict[@"id"];
            productData.productPrice = [productDataDict[@"price"] stringValue];
            productData.productName = productDataDict[@"name"];
            productData.productImpactPoint = [NSNumber numberWithDouble:[[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"] doubleValue]];
            if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            else {
                productData.productDescription=nil;
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPriceStartDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            productData.specialPriceEndDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
                productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
            productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[productDataDict objectForKey:@"type_id"];
            productData.teirPriceArray=[productDataDict objectForKey:@"tier_prices"];
            productData.ribbons = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
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
            productData.productImpactPoint = [NSNumber numberWithDouble:[[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"] doubleValue]];
            if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            else {
                productData.productDescription=nil;
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPriceStartDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            productData.specialPriceEndDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
                productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
            productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[productDataDict objectForKey:@"type_id"];
            productData.teirPriceArray=[productDataDict objectForKey:@"tier_prices"];
            productData.ribbons = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
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
            productData.productImpactPoint = [NSNumber numberWithDouble:[[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"] doubleValue]];
            if ([[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            else {
                productData.productDescription=nil;
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPriceStartDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            productData.specialPriceEndDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
                productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
            productData.productRating = [[productDataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[productDataDict objectForKey:@"type_id"];
            productData.teirPriceArray=[productDataDict objectForKey:@"tier_prices"];
            productData.ribbons = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
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

#pragma mark - Wishlist data
- (void)getWishlistData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getWishlistService:searchData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"wishlist service response %@",response);
        searchData.searchProductListArray=[[NSMutableArray alloc]init];
        NSArray *wishlistArray=response[@"items"];
        for (int i =0; i<wishlistArray.count; i++) {
            NSDictionary * dataDict =[[wishlistArray objectAtIndex:i]objectForKey:@"product"];
            SearchDataModel * productData = [[SearchDataModel alloc]init];
            productData.wishlistItemId=[[wishlistArray objectAtIndex:i]objectForKey:@"wishlist_item_id"];
            productData.productId = dataDict[@"id"];
            productData.productPrice = [dataDict[@"price"] stringValue];
            productData.productName = dataDict[@"name"];
            productData.productImpactPoint = [NSNumber numberWithDouble:[[[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"] doubleValue]];
            if ([[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                productData.productDescription=[self stringByStrippingHTML:[[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            else {
                productData.productDescription=nil;
            }
            productData.productImageThumbnail = [[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[dataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPriceStartDate = [[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            productData.specialPriceEndDate = [[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
                productData.specialPrice = [[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
            productData.productRating = [[dataDict objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            productData.productType=[dataDict objectForKey:@"type_id"];
            productData.teirPriceArray=[dataDict objectForKey:@"tier_prices"];
            productData.ribbons = [[[dataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
            [searchData.searchProductListArray addObject:productData];
        }
        searchData.searchResultCount=response[@"total_count"];
        success(searchData);
        
    } onfailure:^(NSError *error) {
        failure(error);
    }] ;
    
}
#pragma mark - end

#pragma mark - Remove from wishlist
- (void)removeFromWishlistData:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions removeFromWishlistService:searchData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"wishlist service response %@",response);
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
            tempModel.ribbons = [[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"ribbons"];
            if ([[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]!=nil) {
                tempModel.productDescription=[self stringByStrippingHTML:[[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"]];
            }
            else {
                productData.productDescription=nil;
            }
            tempModel.specialPriceStartDate = [[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            tempModel.specialPriceEndDate = [[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:tempModel.specialPriceStartDate endDate:tempModel.specialPriceEndDate]) {
                tempModel.specialPrice = [[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
            tempModel.productQty = [[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            tempModel.productRating = [[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"reviews"] objectForKey:@"avg_rating_percent"];
            tempModel.productType=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"type_id"];
            tempModel.redeemPointsRequired=[[[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"];
            tempModel.tierPriceArray=response[@"tier_prices"];
            [productData.productDataArray addObject:tempModel];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - News detail data service
- (void)getNewsCenterDetailService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *productList=[[DashboardService alloc]init];
    [productList getNewsDetailService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"news list response %@",response);
        productData.productDataArray=[response[@"news"]mutableCopy];
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - News list data service
- (void)getNewsCenterListService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *productList=[[DashboardService alloc]init];
    [productList getNewsListService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"news list response %@",response);
        productData.totalProductCount=[response objectForKey:@"total_count"];
        productData.productDataArray=[NSMutableArray new];
        productData.banerImageUrl=@"";
        for (int i=0; i<[[response objectForKey:@"items"] count]; i++) {
            DashboardDataModel *tempModel=[[DashboardDataModel alloc] init];
            tempModel.productId=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"post_id"];
            tempModel.productName=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"title"];
            tempModel.productImageThumbnail=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"featured_image"];
            tempModel.newsURL=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"post_url"];
            tempModel.newsContent=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"content"];
            if ([[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"short_filtered_content"]!=nil) {
                tempModel.productDescription=[self stringByStrippingHTML:[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"short_filtered_content"]];
            }
            else {
                productData.productDescription=nil;
            }
            [productData.productDataArray addObject:tempModel];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - News list filters data service
- (void)getNewsCenterFiltersListService:(DashboardDataModel *)productData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *productList=[[DashboardService alloc]init];
    [productList getNewsListFiltersService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"news filter list response %@",response);
        productData.archiveOptionsForNews=[response[@"archive_options"] mutableCopy];
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - News category listing service
- (void)getNewsCategoryListing:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *categoryList=[[DashboardService alloc]init];
    [categoryList getNewsCategoryData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"Nwes category list response %@",response);
        //        myDelegate.categoryNameArray=[response[@"children_data"] mutableCopy];
        userData.categoryNameArray=[response mutableCopy];
        success(userData);
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
        productData.tierPricesArray=[response[@"tier_prices"] mutableCopy];
        productData.categoryId=[[customAttributeDict objectForKey:@"category_ids"] objectAtIndex:0];
        productData.productSubtitle=[customAttributeDict objectForKey:@"subtitle"];
        productData.productUrlKey=[customAttributeDict objectForKey:@"url_key"];
        productData.productVideoDefaultThumbnail=[customAttributeDict objectForKey:@"product_video_preview"];
        productData.productVideoDefault=[customAttributeDict objectForKey:@"product_video"];
        productData.enableSubscription=[[customAttributeDict objectForKey:@"enable_subscription"] intValue];
        
        if ([customAttributeDict objectForKey:@"shipping_text"]!=nil) {
            productData.shippingText=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"shipping_text"]];
        }
        else {
            productData.shippingText=nil;
        }
        if ([customAttributeDict objectForKey:@"description"]!=nil) {
            productData.productDescription=[customAttributeDict objectForKey:@"description"];
        }
        else {
            productData.productDescription=nil;
        }
        if ([customAttributeDict objectForKey:@"organizer"]!=nil) {
            productData.organiser=[customAttributeDict objectForKey:@"organizer"];
        }
        else {
            productData.organiser=nil;
        }
        if ([customAttributeDict objectForKey:@"short_description"]!=nil) {
            productData.productShortDescription=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"short_description"]];
        }
        else {
            productData.productShortDescription=nil;
        }
        if ([customAttributeDict objectForKey:@"benefits_usage"]!=nil) {
            productData.productBenefitsUsage=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"benefits_usage"]];
        }
        else {
            productData.productBenefitsUsage=nil;
        }
        if ([customAttributeDict objectForKey:@"brand_story"]!=nil) {
            productData.productBrandStory=[self stringByStrippingHTML:[customAttributeDict objectForKey:@"brand_story"]];
        }
        else {
            productData.productBrandStory=nil;
        }
        productData.productWhereToBuy=[customAttributeDict objectForKey:@"where_buy"];
        productData.productMinQuantity=([[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"min_qty"] intValue]==0?@1:[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"min_qty"]);
        productData.productMaxQuantity=[[[response objectForKey:@"extension_attribute"] objectAtIndex:0] objectForKey:@"qty"];
        productData.following=[[response objectForKey:@"is_following"] stringValue];
        productData.wishlist=[[response objectForKey:@"is_in_wishlist"] stringValue];
        productData.reviewAdded=[[response objectForKey:@"is_reviewed"] stringValue];
        productData.reviewId=[response objectForKey:@"review_id"];
        productData.productSku=[response objectForKey:@"sku"];
        productData.specialPriceStartDate = [customAttributeDict objectForKey:@"special_from_date"];
        productData.specialPriceEndDate = [customAttributeDict objectForKey:@"special_to_date"];
        if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
            productData.specialPrice = [customAttributeDict objectForKey:@"special_price"];
        }
        if (![productData.specialPrice isEqualToString:@""] && nil!=productData.specialPrice) {
            productData.eventPrice=productData.specialPrice;
        }
        else {
            productData.eventPrice=[NSString stringWithFormat:@"%@",productData.productPrice];
        }
        productData.tierPricesArray=response[@"tier_prices"];
        productData.redeemPointsRequired = [customAttributeDict objectForKey:@"points_required"];
        productData.productMediaArray=[NSMutableArray new];
        for (NSDictionary *tempDict in [response objectForKey:@"media"]) {
            if ([[tempDict objectForKey:@"media_type"] isEqualToString:@"external-video"]) {
                if ([[tempDict objectForKey:@"types"] count]>0&&[[tempDict objectForKey:@"types"] containsObject:@"video_360"]) {
                    [tempDict setValue:@"video_360" forKey:@"media_type"];
                }
            }
            [productData.productMediaArray addObject:tempDict];
        }
        if (![response[@"type_id"] isEqualToString:[UserDefaultManager getValue:@"productIdentifier"]]) {
            NSDictionary *eventDetailsDict=[response objectForKey:@"ticket"];
            productData.attendiesArray=[NSMutableArray new];
            productData.locationDataArray=[NSMutableArray new];
            productData.ticketingArray=[NSMutableArray new];
            productData.attendiesArray=[[[eventDetailsDict objectForKey:@"attending"] objectForKey:@"attendies"] mutableCopy];
            productData.ticketingArray=[[eventDetailsDict objectForKey:@"ticketing"] mutableCopy];
            productData.locationDataArray=[[eventDetailsDict objectForKey:@"location"]mutableCopy];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - subscription detail service
- (void)getSubscriptionDetail:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData getSubscriptionDetailService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"subscription details response %@",response);
        productData.subscriptionArray=[NSMutableArray new];
        for (int i=0; i<[[response objectForKey:@"items"] count]; i++) {
            ProductDataModel *tempModel=[[ProductDataModel alloc] init];
            tempModel.selectedUnit=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"selectedUnit"];
            tempModel.optionName=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"optionName"];
            tempModel.frequency=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"frequency"];
            tempModel.maxCycles=[[[response objectForKey:@"items"] objectAtIndex:i] objectForKey:@"maxCycles"];
            
            [productData.subscriptionArray addObject:tempModel];
        }
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Check special price
- (BOOL)checkSpecialPriceSale:(NSString *)startDate endDate:(NSString *)endDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = specialPriceDateFormatter;
    NSString *currentDate = [formatter stringFromDate:[NSDate date]];
    if (([currentDate compare:startDate] == NSOrderedDescending || [currentDate compare:startDate]==NSOrderedSame) && ([currentDate compare:endDate] == NSOrderedAscending|| [currentDate compare:endDate]==NSOrderedSame)) {
        return true;
    }
    else {
        return false;
    }
}
#pragma mark - end
//shareProductNewsService
- (void)shareProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData shareProductNewsService:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"share response %@",response);
        
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}

#pragma mark - Add to cart service
- (void)addToCartProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData addToCartProduct:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"add to cart response %@",response);
        success(productData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Add events to cart service
- (void)addEventsToCartProductService:(ProductDataModel *)productData onSuccess:(void (^)(ProductDataModel *productData))success onFailure:(void (^)(NSError *))failure {
    ProductService *productDetailData=[[ProductService alloc]init];
    [productDetailData addTicketsToCartProduct:productData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"events add to cart response %@",response);
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
            tempModel.userLocation=[dataDict objectForKey:@"customer_country"];
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

#pragma mark - Remove from wishlist service
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

#pragma mark - Country list service
- (void)getCountryCodeService:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService getCountryCodeService:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"country code list response %@",response);
        NSArray *countryArray=response;
        profileData.countryCodeArray=[[NSMutableArray alloc]init];
        for (int i=0; i<countryArray.count; i++) {
            ProfileModel *countryData=[[ProfileModel alloc] init];
            countryData.regionArray=[[NSMutableArray alloc]init];
            NSDictionary * dataDict =[countryArray objectAtIndex:i];
            countryData.countryLocale=[dataDict objectForKey:@"full_name_locale"];
            countryData.countryNameEnglish=[dataDict objectForKey:@"full_name_english"];
            countryData.countryId=[dataDict objectForKey:@"id"];
            NSArray *regionListArray = [[NSArray alloc]init];
            regionListArray = [dataDict objectForKey:@"available_regions"];
            for (int i=0; i<regionListArray.count; i++) {
                ProfileModel *regionData=[[ProfileModel alloc] init];
                NSDictionary * regionDict =[regionListArray objectAtIndex:i];
                regionData.regionId=[regionDict objectForKey:@"id"];
                regionData.regionCode=[regionDict objectForKey:@"code"];
                regionData.regionName=[regionDict objectForKey:@"name"];
                [countryData.regionArray addObject:regionData];
            }
            [profileData.countryCodeArray addObject:countryData];
        }
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - User profile service
- (void)saveAndUpdateAddress:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService saveAndUpdateAddress:profileData onSuccess:^(id response) {
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - User profile service
- (void)getUserProfileData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService getUserProfileServiceData:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"user profile response %@",response);
        profileData.firstName=response[@"firstname"];
        profileData.lastName=response[@"lastname"];
        profileData.email=response[@"email"];
        profileData.groupId=response[@"group_id"];
        profileData.storeId=response[@"store_id"];
        profileData.websiteId=response[@"website_id"];
        profileData.customAttributeArray=[response[@"custom_attributes"]mutableCopy];
        profileData.addressArray=[response[@"addresses"]mutableCopy];
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - User profile image
- (void)updateUserProfileImage:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService updateUserprofileImageService:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"user profile image %@",response);
        profileData.userImageURL=response[@"profile_pic"];
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - User imapct points
- (void)getUserImpactPointsData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService getImpactsPointService:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"user imapct point response %@",response);
        profileData.totalPoints=[response[@"balance_points"] stringValue];
        profileData.recentEarnedPoints=response[@"recently_earned_points"];
        profileData.impactsPointDataArray=[response[@"impact_points_history"] mutableCopy];
        profileData.impactPointTotalRecord=response[@"total_records"];
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Save user profile service
- (void)saveUserProfileData:(ProfileModel *)profileData onSuccess:(void (^)(ProfileModel *profileData))success onFailure:(void (^)(NSError *))failure {
    ProfileService *profileService = [[ProfileService alloc] init];
    [profileService saveUserProfileServiceData:profileData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"save user profile response %@",response);
        [UserDefaultManager setValue:response[@"firstname"] key:@"firstname"];
        [UserDefaultManager setValue:response[@"lastname"] key:@"lastname"];
        for (NSDictionary *aDict in response[@"custom_attributes"]) {
            if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultLanguage"]) {
                NSString *languageValue;
                if ([[aDict objectForKey:@"value"] intValue] == 4) {
                    languageValue=@"en";
                }
                else if ([[aDict objectForKey:@"value"] intValue] == 5) {
                    languageValue=@"zh";
                }
                else if ([[aDict objectForKey:@"value"] intValue] == 6) {
                    languageValue=@"cn";
                }
                [UserDefaultManager setValue:languageValue key:@"Language"];
            }
        }
        for (NSDictionary *aDict in response[@"custom_attributes"]) {
            if ([[aDict objectForKey:@"attribute_code"] isEqualToString:@"DefaultCurrency"]) {
                [UserDefaultManager setValue:[aDict objectForKey:@"value"] key:@"DefaultCurrencyCode"];
            }
        }
        success(profileData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Cart module services
//Cart listing service
- (void)getCartListing:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList getCartListing:cartData success:^(id response) {
        DLog(@"cart list response %@",response);
        cartData.cartListResponse=[response mutableCopy];
        cartData.itemList=[NSMutableArray new];
        cartData.billingAddressDict=[NSMutableDictionary new];
        cartData.shippingAddressDict=[NSMutableDictionary new];
        cartData.customerDict=[NSMutableDictionary new];
        cartData.extensionAttributeDict=[NSMutableDictionary new];
        cartData.customerSavedAddressArray=[NSMutableArray new];
        //        cartData.selectedShippingMethod=@"";
        //        if ((nil==[UserDefaultManager getValue:@"userId"])){
        //            int cartCount=0;
        //            for (NSDictionary *tempDict in response) {
        //                cartCount+=[tempDict[@"qty"] intValue];
        //                [cartData.itemList addObject:[self loadCartListData:[tempDict copy]]];
        //            }
        //            cartData.itemQty=[NSNumber numberWithInt:cartCount];
        //            cartData.selectedShippingMethod=@"";
        //        }
        //        else {
        cartData.extensionAttributeDict=[response objectForKey:@"extension_attributes"];
        cartData.billingAddressDict=[response[@"billing_address"] mutableCopy];
        cartData.customerDict=[response[@"customer"] mutableCopy];
        cartData.customerSavedAddressArray=[cartData.customerDict[@"addresses"] mutableCopy];
        if ([[[response objectForKey:@"extension_attributes"] objectForKey:@"shipping_assignments"] count]>0) {
            cartData.shippingAddressDict=[[[[[response objectForKey:@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"shipping"] objectForKey:@"address"];
            cartData.selectedShippingMethod=[[[[[response objectForKey:@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"shipping"] objectForKey:@"method"];
        }
        for (NSDictionary *tempDict in response[@"items"]) {
            [cartData.itemList addObject:[self loadCartListData:[tempDict copy]]];
        }
        //        }
        success(cartData);
    }
                   onfailure:^(NSError *error) {
                   }];
}

- (CartDataModel *)loadCartListData:(NSDictionary *)tempDict {
    CartDataModel *listData = [[CartDataModel alloc]init];
    listData.itemId=tempDict[@"item_id"];
    listData.itemName=tempDict[@"name"];
    listData.itemPrice=tempDict[@"price"];
    listData.itemQty=tempDict[@"qty"];
    listData.itemQuoteId=tempDict[@"quote_id"];
    listData.itemSku=tempDict[@"sku"];
    return listData;
}
#pragma mark - end

#pragma mark - Remove item from cart
- (void)removeItemFromCart:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList removeItemFromCart:cartData success:^(id response) {
        DLog(@"cart list response %@",response);
        success(cartData);
    }
                       onfailure:^(NSError *error) {
                       }];
}
#pragma mark - end

#pragma mark - Fetch shippment methods
- (void)fetchShippmentMethods:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList fetchShippmentMethods:cartData success:^(id response) {
        DLog(@"Fetch shippment methods response %@",response);
        cartData.shippmentMethodsArray=[response mutableCopy];
        success(cartData);
    }
                          onfailure:^(NSError *error) {
                          }];
}
#pragma mark - end

#pragma mark - Fetch checkout promos
- (void)fetchCheckoutPromos:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList fetchCheckoutPromos:cartData success:^(id response) {
        DLog(@"Fetch promos response %@",response);
        cartData.checkoutPromosArray=[NSMutableArray new];
        BOOL flag=false;
        if (nil!=response[@"checkout_promo"]&&[response[@"checkout_promo"] count]>0) {
            float ip=[cartData.checkoutImpactPoint floatValue];
            NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"promo_points" ascending:YES];
            NSArray *results = [response[@"checkout_promo"]
                                sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
            for (NSDictionary *tempDict in results) {
                if ([tempDict[@"promo_status"] isEqualToString:@"draft"]) {
                    continue;
                }
                //Uncomment code after added groupType form login service
                else if(nil==tempDict[[UserDefaultManager getValue:@"GroupType"]]||![tempDict[[UserDefaultManager getValue:@"GroupType"]] boolValue]) {//Group is not same
                    continue;
                }
                else if(![tempDict[@"promo_category"] isEqualToString:@"rebate"]&&![tempDict[@"promo_category"] isEqualToString:@"percent_discount"]&&!flag) {  //During freeshipping include single entry
                    flag=true;
                    if ([tempDict[@"promo_points"] floatValue]<ip) {
                        [tempDict setValue:[NSNumber numberWithBool:false] forKey:@"HiddenPromo"];
                    }
                    else {
                        [tempDict setValue:[NSNumber numberWithBool:true] forKey:@"HiddenPromo"];
                    }
                    [cartData.checkoutPromosArray addObject:tempDict];
                }
                else if(![tempDict[@"promo_category"] isEqualToString:@"rebate"]&&![tempDict[@"promo_category"] isEqualToString:@"percent_discount"]&&flag) {
                    continue;
                }
                else {
                    if ([tempDict[@"promo_points"] floatValue]<=ip) {
                        [tempDict setValue:[NSNumber numberWithBool:false] forKey:@"HiddenPromo"];
                    }
                    else {
                        [tempDict setValue:[NSNumber numberWithBool:true] forKey:@"HiddenPromo"];
                    }
                    [cartData.checkoutPromosArray addObject:tempDict];
                }
            }
        }
        success(cartData);
    }
                        onfailure:^(NSError *error) {
                        }];
}
#pragma mark - end

#pragma mark - Set addresses and shipping methods
- (void)setUpdatedAddressShippingMethodsService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList setUpdatedAddressShippingMethodsService:cartData success:^(id response) {
        DLog(@"Set addresses and shipping methods response %@",response);
        cartData.checkoutFinalData=[response mutableCopy];
        success(cartData);
    }
                                            onfailure:^(NSError *error) {
                                            }];
}
#pragma mark - end

#pragma mark - Search list by name data
- (void)getProductListByNameService:(SearchDataModel *)searchData success:(void (^)(id))success onfailure:(void (^)(NSError *))failure {
    SearchService *serachSuggestions=[[SearchService alloc]init];
    [serachSuggestions getProductListByNameService:searchData success:^(id response) {
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
            else {
                productData.productDescription=nil;
            }
            if ([productDataDict[@"attribute_set_id"] intValue]==10) {
                productData.isRedeemProduct=[NSNumber numberWithBool:true];
                productData.productImpactPoint=[NSNumber numberWithDouble:[[[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"points_required"] doubleValue]];
            }
            else {
                productData.isRedeemProduct=[NSNumber numberWithBool:false];
            }
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            productData.productQty = [[productDataDict objectForKey:@"extension_attributes"]objectForKey:@"qty"];
            productData.specialPriceStartDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_from_date"];
            productData.specialPriceEndDate = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_to_date"];
            if ([self checkSpecialPriceSale:productData.specialPriceStartDate endDate:productData.specialPriceEndDate]) {
                productData.specialPrice = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"special_price"];
            }
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

#pragma mark - Get order listing
- (void)getOrderListing:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure {
    OrderService *orderService = [[OrderService alloc] init];
    [orderService getOrderListing:orderData onSuccess:^(id response) {
        DLog(@"order list response %@",response);
        orderData.orderListingArray=[[NSMutableArray alloc]init];
        orderData.totalProductCount=[response objectForKey:@"total_count"];
        NSArray *dataArray=response[@"items"];
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * orderDataDict =[dataArray objectAtIndex:i];
            OrderModel * orderListData = [[OrderModel alloc]init];
            orderListData.orderDate = orderDataDict[@"created_at"];
            orderListData.orderStatus = orderDataDict[@"status"];
            orderListData.orderState = orderDataDict[@"state"];
            orderListData.purchaseOrderId = orderDataDict[@"increment_id"];
            orderListData.orderId = [[[[[orderDataDict[@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"items"]objectAtIndex:0] objectForKey:@"order_id"];
            orderListData.billingAddressId = orderDataDict[@"billing_address_id"];
            orderListData.shippingAddress = [([[[[[orderDataDict[@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"shipping"] objectForKey:@"address"] objectForKey:@"street"]) componentsJoinedByString:@" "];
            orderListData.BillingAddress = [[orderDataDict[@"billing_address"] objectForKey:@"street"] componentsJoinedByString:@" "];
            orderListData.fullBillingAddress=orderDataDict[@"billing_address"];
            orderListData.fullShippingAddress=[[[[orderDataDict[@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"shipping"] objectForKey:@"address"];
            orderListData.shippingMethod = orderDataDict[@"shipping_description"];
            orderListData.paymentMethod = [orderDataDict[@"payment"] objectForKey:@"method"];
            orderListData.tax = orderDataDict[@"tax_amount"];
            //Use reusable code order detail handling
            [orderData.orderListingArray addObject:[self orderDetailHandling:orderDataDict orderDataModel:orderListData isOrderInvoice:false]];
        }
        success(orderData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Product guide service
- (void)getGuideCategory:(ProductGuideDataModel *)guideData onSuccess:(void (^)(ProductGuideDataModel *guideData))success onFailure:(void (^)(NSError *))failure {
    ProductGuideService *guideService = [[ProductGuideService alloc] init];
    [guideService getGuideCategoryService:guideData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        guideData.guideCategoryDataArray=[[NSMutableArray alloc]init];
        NSArray *dataArray=[response mutableCopy];
        DLog(@"response %@",response);
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * dataDict =[dataArray objectAtIndex:i];
            ProductGuideDataModel *categoryGuideData=[[ProductGuideDataModel alloc]init];
            categoryGuideData.categoryName=[dataDict objectForKey:@"name"];
            categoryGuideData.categoryDescription=[self stringByStrippingHTML:[dataDict objectForKey:@"description"]];
            categoryGuideData.categoryId=[dataDict objectForKey:@"category_id"];
            [guideData.guideCategoryDataArray addObject:categoryGuideData];
        }
        success(guideData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Product guide details service
- (void)getGuideDetailsCategory:(ProductGuideDataModel *)guideData onSuccess:(void (^)(ProductGuideDataModel *guideData))success onFailure:(void (^)(NSError *))failure {
    ProductGuideService *guideService = [[ProductGuideService alloc] init];
    [guideService getGuideCategoryDetailsService:guideData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        guideData.postDataArray=[[NSMutableArray alloc]init];
        guideData.totalProductCount=response[@"total_count"];
        NSArray *dataArray=[response[@"items"] mutableCopy];
        DLog(@"response %@",response);
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * dataDict =[dataArray objectAtIndex:i];
            ProductGuideDataModel *categoryGuideData=[[ProductGuideDataModel alloc]init];
            categoryGuideData.postId=[dataDict objectForKey:@"post_id"];
            categoryGuideData.postName=[dataDict objectForKey:@"name"];
            categoryGuideData.postImage=[dataDict objectForKey:@"image"];
            categoryGuideData.postContent=[dataDict objectForKey:@"post_content"];
            categoryGuideData.shortDescription=[dataDict objectForKey:@"short_description"];
            categoryGuideData.tagline=[dataDict objectForKey:@"tagline"];
            [guideData.postDataArray addObject:categoryGuideData];
        }
        success(guideData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Cancel order
- (void)cancelOrderService:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure {
    OrderService *orderService = [[OrderService alloc] init];
    [orderService cancelOrderService:orderData onSuccess:^(id response) {
        DLog(@"cancel order response %@",response);
        success(orderData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get ticket options
- (void)getTicketOption:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure {
    OrderService *orderService = [[OrderService alloc] init];
    [orderService getTicketOption:orderData onSuccess:^(id response) {
        DLog(@"get ticket response %@",response);
        orderData.ticketListingArray=[[NSMutableArray alloc]init];
        NSArray *dataArray=response;
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * orderDataDict =[dataArray objectAtIndex:i];
            OrderModel * orderListData = [[OrderModel alloc]init];
            orderListData.ticketProductId = orderDataDict[@"quote_item_id"];
            orderListData.ticketName = orderDataDict[@"selected_option"];
            [orderData.ticketListingArray addObject:orderListData];
        }
        success(orderData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Order data handling
- (OrderModel *)orderDetailHandling:(NSDictionary *)orderDataDict orderDataModel:(OrderModel *)orderListData isOrderInvoice:(BOOL)isOrderInvoice {
    orderListData.discountDescription = orderDataDict[@"discount_description"];
    NSMutableArray *ratesArray=[NSMutableArray new];
    for (int i =0; i<[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] count]; i++) {
        NSDictionary * footerDataDict =[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] objectAtIndex:i];
        CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
        exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
        exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
        exchangeData.currencysymbol = footerDataDict[@"currency_symbol"];
        [ratesArray addObject:exchangeData];
    }
    for (int i=0; i<ratesArray.count; i++) {
        if ([orderDataDict[@"order_currency_code"] containsString:[[ratesArray objectAtIndex:i] currencyExchangeCode]]) {
            if ([[[ratesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[ratesArray objectAtIndex:i] currencysymbol]==nil) {
                orderListData.orderSubTotal = [NSString stringWithFormat:@"%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDataDict[@"subtotal"] doubleValue]]];
                orderListData.shippingAmount = [NSString stringWithFormat:@"%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDataDict[@"shipping_amount"] doubleValue]]];
                orderListData.discountAmount = [NSString stringWithFormat:@"-%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:fabs([orderDataDict[@"discount_amount"] doubleValue])]];
                orderListData.taxAmount = [NSString stringWithFormat:@"%@ %@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDataDict[@"tax_amount"] doubleValue]]];
                orderListData.orderPrice = [NSString stringWithFormat:@"%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDataDict[@"grand_total"] doubleValue]]];
            }
            else {
                orderListData.orderSubTotal = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDataDict[@"subtotal"] doubleValue]]];
                orderListData.shippingAmount = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDataDict[@"shipping_amount"] doubleValue]]];
                orderListData.discountAmount = [NSString stringWithFormat:@"-%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:fabs([orderDataDict[@"discount_amount"] doubleValue])]];
                orderListData.taxAmount = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDataDict[@"tax_amount"] doubleValue]]];
                orderListData.orderPrice = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDataDict[@"grand_total"] doubleValue]]];
            }
        }
        if ([orderDataDict[@"base_currency_code"] containsString:[[ratesArray objectAtIndex:i] currencyExchangeCode]]) {
            if ([[[ratesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[ratesArray objectAtIndex:i] currencysymbol]==nil) {
                orderListData.baseGrandTotal = [NSString stringWithFormat:@"%@%@",orderDataDict[@"base_currency_code"],[ConstantCode decimalFormatter:[orderDataDict[@"base_grand_total"] doubleValue]]];
            }
            else {
                orderListData.baseGrandTotal = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDataDict[@"base_grand_total"] doubleValue]]];
            }
        }
    }
    orderListData.productListingArray=[[NSMutableArray alloc]init];
    NSArray *productDataArray;
    if (isOrderInvoice) {
        productDataArray=orderDataDict[@"items"];
    }
    else{
        productDataArray=[[[orderDataDict[@"extension_attributes"] objectForKey:@"shipping_assignments"] objectAtIndex:0] objectForKey:@"items"];
    }
    for (int i =0; i<productDataArray.count; i++) {
        NSDictionary * orderDetailDataDict =[productDataArray objectAtIndex:i];
        OrderModel * productListData = [[OrderModel alloc]init];
        
        NSMutableArray *ratesArray=[NSMutableArray new];
        for (int i =0; i<[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] count]; i++) {
            NSDictionary * footerDataDict =[[UserDefaultManager getValue:@"availableCurrencyRatesArray"] objectAtIndex:i];
            CurrencyDataModel * exchangeData = [[CurrencyDataModel alloc]init];
            exchangeData.currencyExchangeCode = footerDataDict[@"currency_to"];
            exchangeData.currencyExchangeRates = footerDataDict[@"rate"];
            exchangeData.currencysymbol = footerDataDict[@"currency_symbol"];
            [ratesArray addObject:exchangeData];
        }
        for (int i=0; i<ratesArray.count; i++) {
            if ([orderDataDict[@"order_currency_code"] containsString:[[ratesArray objectAtIndex:i] currencyExchangeCode]]) {
                if ([[[ratesArray objectAtIndex:i] currencysymbol] isEqualToString:@""] || [[ratesArray objectAtIndex:i] currencysymbol]==nil) {
                    productListData.productPrice = [NSString stringWithFormat:@"%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDetailDataDict[@"price"] doubleValue]]];
                    productListData.productSubTotal = [NSString stringWithFormat:@"%@%@",orderDataDict[@"order_currency_code"],[ConstantCode decimalFormatter:[orderDetailDataDict[@"row_total"] doubleValue]]];
                }
                else {
                    productListData.productPrice = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDetailDataDict[@"price"] doubleValue]]];
                    productListData.productSubTotal = [NSString stringWithFormat:@"%@%@",[[ratesArray objectAtIndex:i] currencysymbol],[ConstantCode decimalFormatter:[orderDetailDataDict[@"row_total"] doubleValue]]];
                }
            }
        }
        productListData.productId = orderDetailDataDict[@"quote_item_id"];
        productListData.productType = orderDetailDataDict[@"product_type"];
        productListData.productName = orderDetailDataDict[@"name"];
        productListData.productSku = orderDetailDataDict[@"sku"];
        if (isOrderInvoice) {
            productListData.productQuantity = orderDetailDataDict[@"qty"];
        }
        else{
            productListData.productQuantity = orderDetailDataDict[@"qty_ordered"];
        }
        [orderListData.productListingArray addObject:productListData];
    }
    return orderListData;
}
#pragma mark - end

#pragma mark - Get order invoice
- (void)getOrderInvoice:(OrderModel *)orderData onSuccess:(void (^)(OrderModel *orderData))success onFailure:(void (^)(NSError *))failure {
    OrderService *orderService = [[OrderService alloc] init];
    [orderService getOrderInvoice:orderData onSuccess:^(id response) {
        DLog(@"order invoice response %@",response);
        if (orderData.isOrderInvoice) {
            orderData.orderInvoiceArray=[[NSMutableArray alloc]init];
            NSArray *dataArray=response[@"items"];
            for (int i =0; i<dataArray.count; i++) {
                NSDictionary * orderDataDict =[dataArray objectAtIndex:i];
                OrderModel * orderListData = [[OrderModel alloc]init];
                orderListData.orderDate = [[orderDataDict[@"created_at"] componentsSeparatedByString:@" "] objectAtIndex:0];
                orderListData.orderStatus = orderDataDict[@"status"];
                orderListData.purchaseOrderId = orderDataDict[@"increment_id"];
                //Use reusable code order detail handling
                [orderData.orderInvoiceArray addObject:[self orderDetailHandling:orderDataDict orderDataModel:orderListData isOrderInvoice:true]];
            }
        }
        else {
            NSArray *dataArray=response[@"items"];
            for (int i =0; i<dataArray.count; i++) {
                NSDictionary * orderDataDict =[dataArray objectAtIndex:i];
                orderData.purchaseOrderId = orderDataDict[@"increment_id"];
                orderData.trackArray=[NSMutableArray new];
                orderData.orderShipmentDataArray=[NSMutableArray new];
                if (nil!=orderDataDict[@"tracks"]&&[orderDataDict[@"tracks"] count]>0) {
                    for (NSDictionary *tempDict in orderDataDict[@"tracks"]) {
                        OrderModel * orderTempTrack = [[OrderModel alloc]init];
                        orderTempTrack.productName=tempDict[@"title"];
                        orderTempTrack.trackNumber=tempDict[@"track_number"];
                        [orderData.trackArray addObject:orderTempTrack];
                    }
                }
                if (nil!=orderDataDict[@"items"]&&[orderDataDict[@"items"] count]>0) {
                    for (NSDictionary *tempDict in orderDataDict[@"items"]) {
                        OrderModel * orderShipment = [[OrderModel alloc]init];
                        orderShipment.productName=tempDict[@"name"];
                        orderShipment.productSku=tempDict[@"sku"];
                        orderShipment.productQuantity=tempDict[@"qty"];
                        [orderData.orderShipmentDataArray addObject:orderShipment];
                    }
                }
            }
        }
        success(orderData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Get card listing
- (void)getCardListing:(PaymentModel *)paymentData onSuccess:(void (^)(PaymentModel *paymentData))success onFailure:(void (^)(NSError *))failure {
    PaymentService *paymentService = [[PaymentService alloc] init];
    [paymentService getCardListing:paymentData onSuccess:^(id response) {
        DLog(@"getCardListing response %@",response);
        paymentData.cardListArray = [[NSMutableArray alloc]init];
        NSArray *dataArray=response[@"items"];
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * paymentDataDict =[dataArray objectAtIndex:i];
            PaymentModel * paymentListData = [[PaymentModel alloc]init];
            paymentListData.cardId = paymentDataDict[@"card_id"];;
            paymentListData.subscriptionId = paymentDataDict[@"subscription_id"];
            paymentListData.firstname = paymentDataDict[@"firstname"];
            paymentListData.lastname = paymentDataDict[@"lastname"];
            paymentListData.postcode = paymentDataDict[@"postcode"];
            paymentListData.countryId = paymentDataDict[@"country_id"];
            paymentListData.regionId = paymentDataDict[@"region_id"];
            paymentListData.state = paymentDataDict[@"state"];
            paymentListData.city = paymentDataDict[@"city"];
            paymentListData.company = paymentDataDict[@"company"];
            paymentListData.street = paymentDataDict[@"street"];
            paymentListData.telephone = paymentDataDict[@"telephone"];
            paymentListData.cardExpMonth = paymentDataDict[@"cc_exp_month"];
            paymentListData.cardExpYear = paymentDataDict[@"cc_exp_year"];
            paymentListData.cardLastFourDigit = paymentDataDict[@"cc_last_4"];
            paymentListData.cardType = paymentDataDict[@"cc_type"];
            paymentListData.encryptedSubscriptionId = paymentDataDict[@"encrypted_subscription_id"];
            [paymentData.cardListArray addObject:paymentListData];
        }
        success(paymentData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Delete card service
- (void)deleteCardService:(PaymentModel *)paymentData onSuccess:(void (^)(PaymentModel *paymentData))success onFailure:(void (^)(NSError *))failure {
    PaymentService *paymentService = [[PaymentService alloc] init];
    [paymentService deleteCardFromListing:paymentData onSuccess:^(id response) {
        DLog(@"delete card response %@",response);
        success(paymentData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Fetch constants listing service
- (void)getConstantsListData:(DashboardDataModel *)userData onSuccess:(void (^)(DashboardDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *categoryList=[[DashboardService alloc]init];
    [categoryList getConstantsListData:userData success:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"Constants list response %@",response);
        [UserDefaultManager setValue:response[@"cardTypes"] key:@"cardTypes"];
        [UserDefaultManager setValue:response[@"categoryMediaUrl"] key:@"categoryMediaUrl"];
        [UserDefaultManager setValue:response[@"eventCategoryId"] key:@"eventCategoryId"];
        [UserDefaultManager setValue:response[@"productMediaUrl"] key:@"productMediaUrl"];
        [UserDefaultManager setValue:response[@"emailForCrashingiOS"] key:@"emailForCrashingiOS"];
        [UserDefaultManager setValue:response[@"eventIdentifier"] key:@"eventIdentifier"];
        [UserDefaultManager setValue:response[@"orderStatuses"] key:@"orderStatuses"];
        [UserDefaultManager setValue:response[@"checkOutShippingMessage"] key:@"checkOutShippingMessage"];
        [UserDefaultManager setValue:response[@"maxQty"] key:@"maxQty"];
        [UserDefaultManager setValue:response[@"paginationSize"] key:@"paginationSize"];
        [UserDefaultManager setValue:response[@"reviewSortingByKey"] key:@"reviewSortingByKey"];
        [UserDefaultManager setValue:response[@"reviewSortingByKeyMostRecent"] key:@"reviewSortingByKeyMostRecent"];
        [UserDefaultManager setValue:response[@"impactPointRules"] key:@"impactPointRules"];
        [UserDefaultManager setValue:response[@"productIdentifier"] key:@"productIdentifier"];
        [UserDefaultManager setValue:response[@"cn"] key:@"cn"];
        [UserDefaultManager setValue:response[@"en"] key:@"en"];
        [UserDefaultManager setValue:response[@"zh"] key:@"zh"];
        [UserDefaultManager setValue:response[@"rewardCategoryId"] key:@"rewardCategoryId"];
        [UserDefaultManager setValue:response[@"terms&Condition"] key:@"terms&Condition"];
        [UserDefaultManager setValue:response[@"privacyPolicy"] key:@"privacyPolicy"];
        [UserDefaultManager setValue:response[@"contactUs"] key:@"contactUs"];
        [UserDefaultManager setValue:response[@"aboutUs"] key:@"aboutUs"];
        [UserDefaultManager setValue:response[@"return_policy"] key:@"returnPolicy"];
        [UserDefaultManager setValue:response[@"newsCentre"] key:@"newsCentre"];
        [UserDefaultManager setValue:response[@"rewardProductAttributeId"] key:@"rewardProductAttributeId"];
        [UserDefaultManager setValue:response[@"AdditionalSortsFilters"] key:@"AdditionalSortsFilters"];
        [UserDefaultManager setValue:response[@"DefaultSortsFilters"] key:@"DefaultSortsFilters"];
        [UserDefaultManager setValue:response[@"payment_methods"] key:@"paymentMethods"];
        success(userData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Share service
- (void)shareProductData:(ShareDataModel *)guideData onSuccess:(void (^)(ShareDataModel *guideData))success onFailure:(void (^)(NSError *))failure {
    ShareDataService *shareService = [[ShareDataService alloc] init];
    [shareService shareDataService:guideData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        success(guideData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Sorting and filter
- (void)getSortData:(SortFilterModel *)sortData onSuccess:(void (^)(SortFilterModel *userData))success onFailure:(void (^)(NSError *))failure {
    SortFilterService *sortService = [[SortFilterService alloc] init];
    [sortService getSortData:sortData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"response %@",response);
        NSArray *dataArray=response[@"items"];
        sortData.sortArray=[NSMutableArray new];
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * dataDict =[dataArray objectAtIndex:i];
            SortFilterModel * sortListData = [[SortFilterModel alloc]init];
            sortListData.ascValue = dataDict[@"default_frontend_label"];
            sortListData.descValue = dataDict[@"default_frontend_label"];
            sortListData.attributeValue = dataDict[@"attribute_code"];
            sortListData.sortBasis = DESC;
            [sortData.sortArray addObject:sortListData];
        }
        success(sortData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

- (void)getFilterDataData:(SortFilterModel *)sortData onSuccess:(void (^)(SortFilterModel *userData))success onFailure:(void (^)(NSError *))failure {
    SortFilterService *sortService = [[SortFilterService alloc] init];
    [sortService getSortData:sortData onSuccess:^(id response) {
        //Parse data from server response and store in data model
        DLog(@"response %@",response);
        NSArray *dataArray=response[@"items"];
        sortData.filterArray=[NSMutableArray new];
        for (int i =0; i<dataArray.count; i++) {
            NSDictionary * dataDict =[dataArray objectAtIndex:i];
            SortFilterModel * sortListData = [[SortFilterModel alloc]init];
            sortListData.filterLabelValue = dataDict[@"default_frontend_label"];
            sortListData.filterAttributeCode = dataDict[@"attribute_code"];
            sortListData.filterOptionsArray=[[NSMutableArray alloc]init];
            NSArray *tempArray=dataDict[@"options"];
            for (int j=0; j<tempArray.count; j++) {
                NSDictionary * dataDict =[tempArray objectAtIndex:j];
                SortFilterModel * filterValueData = [[SortFilterModel alloc]init];
                filterValueData.filterCountry = dataDict[@"label"];
                filterValueData.filterCountryValue = dataDict[@"value"];
                [sortListData.filterOptionsArray addObject:filterValueData];
            }
            [sortData.filterArray addObject:sortListData];
        }
        success(sortData);
    } onFailure:^(NSError *error) {
        failure(error);
    }] ;
}
#pragma mark - end

#pragma mark - Set checkout order
- (void)setCheckoutOrderService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList setCheckoutOrderService:cartData success:^(id response) {
        DLog(@"Set checkout order response %@",response);
        success(cartData);
    }
                            onfailure:^(NSError *error) {
                            }];
}
#pragma mark - end

#pragma mark - Set checkout order
- (void)cyberSourcePaymentService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList cyberSourcePaymentData:cartData success:^(id response) {
        DLog(@"Set checkout order response %@",response);
        if ([response isKindOfClass:[NSString class]]) {
            //Now do a simple casting
            cartData.cyberSourceOrderId = (NSString *)response;
            cartData.cyberSourceOrderId   = [cartData.cyberSourceOrderId stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            ;
        }
        success(cartData);
    }
                           onfailure:^(NSError *error) {
                           }];
}
#pragma mark - end

#pragma mark - Apply coupon
- (void)applyCouponCodeService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList applyCouponCode:cartData success:^(id response) {
        DLog(@"applyCouponCode response %@",response);
        success(cartData);
    }
                    onfailure:^(NSError *error) {
                    }];
}
#pragma mark - end

#pragma mark - Remove coupon
- (void)removeCouponCodeService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList removeCouponCode:cartData success:^(id response) {
        DLog(@"remove response %@",response);
        success(cartData);
    }
                     onfailure:^(NSError *error) {
                     }];
}
#pragma mark - end

#pragma mark - Set checkout promo
- (void)setCheckoutPromosService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList setCheckoutPromos:cartData success:^(id response) {
        DLog(@"Set checkout promo response %@",response);
        success(cartData);
    }
                      onfailure:^(NSError *error) {
                      }];
}
#pragma mark - end


#pragma mark - Set payment method
- (void)setPaymentMethodService:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList setPaymentMethodService:cartData success:^(id response) {
        DLog(@"Set payment method response %@",response);
        success(cartData);
    }
                            onfailure:^(NSError *error) {
                            }];
}
#pragma mark - end

#pragma mark - Get shipping method service
- (void)getShippingMethod:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList getShippingMethod:cartData success:^(id response) {
        DLog(@"Get shipping method response %@",response);
        cartData.selectedShippingMethod=[NSString stringWithFormat:@"%@_%@",[[response objectAtIndex:0] objectForKey:@"carrier_code"],[[response objectAtIndex:0] objectForKey:@"carrier_code"]];
        success(cartData);
    }
                      onfailure:^(NSError *error) {
                      }];
}
#pragma mark - end

#pragma mark - Clear cart
- (void)clearCart:(CartDataModel *)cartData onSuccess:(void (^)(CartDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    CartService *cartList=[[CartService alloc]init];
    [cartList clearCart:cartData success:^(id response) {
        DLog(@"clearCart response %@",response);
        NSString *quoteId = [cartData.cyberSourceOrderId stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [UserDefaultManager setValue:quoteId forKey:@"quoteId"];
        success(cartData);
    }
              onfailure:^(NSError *error) {
              }];
}
#pragma mark - end
@end
