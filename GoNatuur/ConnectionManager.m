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
        NSLog(@"login response %@",response);
        //Parse data from server response and store in datamodel
        userData.userId=[[[response objectAtIndex:0] objectForKey:@"customer"] objectForKey:@"entity_id"];
        userData.accessToken=[[response objectAtIndex:0] objectForKey:@"api_key"];
        userData.followCount=[[response objectAtIndex:0] objectForKey:@"follow_count"];
        userData.notificationsCount=[[response objectAtIndex:0] objectForKey:@"notifications_count"];
        userData.quoteId=[[response objectAtIndex:0] objectForKey:@"quote_id"];
        userData.quoteCount=[[response objectAtIndex:0] objectForKey:@"quote_count"];
        userData.wishlistCount=[[response objectAtIndex:0] objectForKey:@"wishlist_count"];
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
        userData.cmsTitle=[response objectForKey:@"title"];
        userData.cmsContent=[response objectForKey:@"content"];
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
        userData.otpNumber=[[response  objectAtIndex:0] objectForKey:@"resetOTP"];
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
        NSLog(@"category list response %@",response);
        myDelegate.categoryNameArray=[response[@"children_data"] mutableCopy];
        success(userData);
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - SignUp user service
- (void)signUpUserService:(LoginModel *)userData onSuccess:(void (^)(id userData))success onFailure:(void (^)(NSError *))failure {
    LoginService *loginService = [[LoginService alloc] init];
    [loginService signUpUserService:userData onSuccess:^(id response) {
        //Parse data from server response and store in datamodel
        userData.userId=[[[response objectAtIndex:0] objectForKey:@"customer"] objectForKey:@"entity_id"];
        userData.accessToken=[[response objectAtIndex:0] objectForKey:@"api_key"];
        userData.followCount=[[response objectAtIndex:0] objectForKey:@"follow_count"];
        userData.notificationsCount=[[response objectAtIndex:0] objectForKey:@"notifications_count"];
        userData.quoteId=[[response objectAtIndex:0] objectForKey:@"quote_id"];
        userData.quoteCount=[[response objectAtIndex:0] objectForKey:@"quote_count"];
        userData.wishlistCount=[[response objectAtIndex:0] objectForKey:@"wishlist_count"];
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
        NSLog(@"dashboard data response %@",response);
        userData.bannerImageArray=[[NSMutableArray alloc]init];
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
            NSDictionary * productDataDict =[productDataArray objectAtIndex:i];
            DashboardDataModel * productData = [[DashboardDataModel alloc]init];
            productData.productId = productDataDict[@"id"];
            productData.productPrice = [productDataDict[@"price"] stringValue];
            productData.productName = productDataDict[@"name"];
            productData.productDescription = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"];
            productData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            [userData.bestSellerArray addObject:productData];
        }
        userData.healthyLivingArray=[[NSMutableArray alloc]init];
        NSArray *healthyLivingArray=response[@"category_tab1"];
        for (int i =0; i<healthyLivingArray.count; i++) {
            NSDictionary * productDataDict =[healthyLivingArray objectAtIndex:i];
            DashboardDataModel * healthyLivingData = [[DashboardDataModel alloc]init];
            healthyLivingData.productId = productDataDict[@"id"];
            healthyLivingData.productPrice = [productDataDict[@"price"] stringValue];
            healthyLivingData.productName = productDataDict[@"name"];
            healthyLivingData.productDescription = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"];
            healthyLivingData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            [userData.healthyLivingArray addObject:healthyLivingData];
        }
        userData.samplersDataArray=[[NSMutableArray alloc]init];
        NSArray *samplersArray=response[@"category_tab2"];
        for (int i =0; i<samplersArray.count; i++) {
            NSDictionary * productDataDict =[samplersArray objectAtIndex:i];
            DashboardDataModel * samplersArrayData = [[DashboardDataModel alloc]init];
            samplersArrayData.productId = productDataDict[@"id"];
            samplersArrayData.productPrice = [productDataDict[@"price"] stringValue];
            samplersArrayData.productName = productDataDict[@"name"];
            samplersArrayData.productDescription = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"short_description"];
            samplersArrayData.productImageThumbnail = [[[productDataDict objectForKey:@"custom_attributes"] objectAtIndex:0] objectForKey:@"thumbnail"];
            [userData.samplersDataArray addObject:samplersArrayData];
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
#pragma mark - end

#pragma mark - Fetch currency data
- (void)getDefaultCurrency:(CurrencyDataModel *)userData onSuccess:(void (^)(CurrencyDataModel *userData))success onFailure:(void (^)(NSError *))failure {
    DashboardService *currencyData=[[DashboardService alloc]init];
    [currencyData getCurrency:userData success:^(id response) {
        //Parse data from server response and store in data model
        NSLog(@"currency list response %@",response);
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
        NSLog(@"SearchService list response %@",response);
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
@end
