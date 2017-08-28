//
//  ReviewViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewDataModel.h"
#import "ReviewListingViewController.h"

@interface ReviewViewController : GoNatuurViewController
@property (nonatomic,strong) NSNumber *selectedProductId;
@property (nonatomic,strong) ReviewDataModel *reviewData;
@property (nonatomic,strong) NSString *isEditMode;
@property (nonatomic,strong) ReviewListingViewController *reviewListObj;
@end
