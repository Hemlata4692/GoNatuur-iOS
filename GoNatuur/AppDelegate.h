//
//  AppDelegate.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 10/07/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantCode.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,assign)ConstantType selectedLoginType;
@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,assign) int selectedCategoryIndex;
@property (strong, nonatomic) NSMutableArray *categoryNameArray;
@property (nonatomic,assign) bool isProductList;
@property (retain, nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) NSString *exchangeRates;
@property (nonatomic, strong) NSString *tabButtonTag;
@property (strong, nonatomic) NSMutableArray *productCartItemKeys;
@property (strong, nonatomic) NSMutableDictionary *productCartItemsDetail;
- (void)showIndicator;
- (void)stopIndicator;

- (void)registerForRemoteNotification;
- (void)unregisterForRemoteNotifications;
- (void)checkGuestAccess;
- (void)logoutUser;
@end

