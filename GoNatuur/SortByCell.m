//
//  SortByCell.m
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SortByCell.h"

@implementation SortByCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)displaySortData:(CGSize)rectSize sortData:(SortFilterModel *)sortData {
    _ascLabel.text = sortData.ascValue;
    _descLabel.text = sortData.descValue;
}

@end
