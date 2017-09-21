//
//  NewsCentreCollectionViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 20/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DashboardDataModel.h"

@interface NewsCentreCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *productCellMainView;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productDescription;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIView *borderView;

- (void)displayProductListData :(DashboardDataModel *)productListData exchangeRates:(NSString *)exchangeRates;
@end
