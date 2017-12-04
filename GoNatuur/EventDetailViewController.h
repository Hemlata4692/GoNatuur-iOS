//
//  EventDetailViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 10/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : GoNatuurViewController
@property (nonatomic,assign) int selectedProductId;
@property (nonatomic,strong) NSString *reviewAdded;
@property (nonatomic,strong) NSDictionary *subscriptionDetailDict;

@end
