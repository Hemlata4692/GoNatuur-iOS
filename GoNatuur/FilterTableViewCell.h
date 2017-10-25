//
//  FilterTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortFilterModel.h"
#import "TTRangeSlider.h"

@interface FilterTableViewCell : UITableViewCell<TTRangeSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *priceFilterLabel;
@property (weak, nonatomic) IBOutlet TTRangeSlider *priceRangeSliderView;
@property (weak, nonatomic) IBOutlet UILabel *minimumPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumPriceLabel;
@property (strong, nonatomic) NSString *minPriceValue;
@property (strong, nonatomic) NSString *maxPriceValue;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedFilterLabel;
@property (strong, nonatomic) NSString *filterApplied;

- (void)displaySlider:(NSString *)maxPrice minLabelPrice:(NSString *)minLabelPrice maxLabelPrice:(NSString *)maxLabelPrice;

- (void)displayCountry:(SortFilterModel *)data;
@end
