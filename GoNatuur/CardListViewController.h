//
//  CardListViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FinalCheckoutViewController.h"

@interface CardListViewController : GoNatuurViewController
@property (nonatomic, strong) NSString *cardAdded;
@property (nonatomic, assign) int cardCount;
@property(nonatomic,strong)FinalCheckoutViewController *finalCheckoutView;
@end
