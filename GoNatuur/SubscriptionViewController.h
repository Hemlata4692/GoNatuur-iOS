//
//  SubscriptionViewController.h
//  GoNatuur
//
//  Created by Monika on 23/11/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductDetailViewController.h"
#import "EventDetailViewController.h"

@interface SubscriptionViewController : GoNatuurViewController
@property (nonatomic)int productId;
@property (nonatomic,strong)ProductDetailViewController *productDetailControllerObj;
@property (nonatomic,strong)EventDetailViewController *eventDetailControllerObj;
@property (nonatomic) BOOL isEventScreen;
@end
