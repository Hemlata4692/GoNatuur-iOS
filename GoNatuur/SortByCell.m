//
//  SortByCell.m
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SortByCell.h"

@implementation SortByCell

#pragma mark - Cell lifecycle
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

//Display sort data
- (void)displaySortData:(CGSize)rectSize sortData:(SortFilterModel *)sortData {
    UIColor *selectedColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    UIColor *deSelectedColor = [UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    
    if ([NSLocalizedText(sortData.attributeValue) isEqualToString:@""] || NSLocalizedText(sortData.attributeValue)==nil) {
        _ascLabel.text = sortData.ascValue;
        _descLabel.text = sortData.descValue;
    }
    else {
        _ascLabel.text = NSLocalizedText(sortData.attributeValue);
        _descLabel.text = NSLocalizedText(sortData.attributeValue);
    }
    if (sortData.selectedValue == 1) {
        if (sortData.sortBasis == DESC) {
            _ascLabel.textColor=selectedColor;
            _descLabel.textColor=deSelectedColor;
        } else {
            _descLabel.textColor=selectedColor;
            _ascLabel.textColor=deSelectedColor;
        }
    } else {
        _ascLabel.textColor=deSelectedColor;
        _descLabel.textColor=deSelectedColor;
    }
}
#pragma mark - end
@end
