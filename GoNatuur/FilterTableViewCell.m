//
//  FilterTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FilterTableViewCell.h"

@implementation FilterTableViewCell {

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)displaySlider {
    
    _minimumPriceLabel.text=@"0";
    _maximumPriceLabel.text=@"5000";
    
    _priceRangeSliderView.requireSegments = NO;
    _priceRangeSliderView.sliderSize = CGSizeMake(20, 20);
    
    _priceRangeSliderView.rangeSliderForegroundColor = [UIColor redColor];
    
    
    _priceRangeSliderView.rangeSliderButtonImage = [UIImage imageNamed:@"slide-arrow"];
    [_priceRangeSliderView setDelegate:self];
    
    [_priceRangeSliderView scrollStartSliderToStartRange:0 andEndRange:100];
}

- (void)sliderScrolling:(VPRangeSlider *)slider withMinPercent:(CGFloat)minPercent andMaxPercent:(CGFloat)maxPercent
{
    _priceRangeSliderView.minRangeText = [NSString stringWithFormat:@"%.0f", minPercent];
    _priceRangeSliderView.maxRangeText = [NSString stringWithFormat:@"%.0f", maxPercent];
}

- (void)displayCountry:(SortFilterModel *)data {
    if ([data.filterCountryValue isEqualToString:@""]) {
        _countryLabel.text=NSLocalizedText(@"All");
    }
    else {
        _countryLabel.text=data.filterCountry;
    }
}
@end
