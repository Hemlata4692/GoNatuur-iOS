//
//  PaymentWebViewController.h
//  GoNatuur
//
//  Created by Hemlata Khajanchi on 28/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentWebViewController : UIViewController
@property(nonatomic,strong)NSString *paymentMethod;
@property(nonatomic,strong)NSString *isSubscriptionProduct;
@property (nonatomic, strong) NSMutableArray *cartListDataArray;
@property (nonatomic, strong) NSDictionary *finalCheckoutPriceDict;
@end
