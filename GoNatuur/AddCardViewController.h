//
//  AddCardViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 07/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardListViewController.h"

@interface AddCardViewController : GoNatuurViewController
@property (nonatomic, strong) CardListViewController *cardListObj;
@property (nonatomic, assign) int cardCount;
@end
