//
//  ReviewTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "ImageCaching.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)displayData :(ReviewDataModel *)listData {
    _userName.text=listData.username;
    _reviewTextLabel.text=listData.reviewDescription;
    _reviewTitleLabel.text=listData.reviewTitle;
        if ([listData.ratingId isEqualToString:@""] || listData.ratingId==nil || [listData.ratingId isEqualToString:@"0"]) {
            //Show all blank star
        }
        else {
    _ratingView.starImage = [UIImage imageNamed:@"star-unselected"];
    _ratingView.starHighlightedImage = [UIImage imageNamed:@"star"];
    _ratingView.maxRating = 5.0;
    _ratingView.delegate = self;
    _ratingView.horizontalMargin = 2;
    _ratingView.editable=NO;
    _ratingView.rating= [listData.ratingId floatValue];
    _ratingView.displayMode=EDStarRatingDisplayHalf;
        }
    [ImageCaching downloadImages:_userImageView imageUrl:listData.userImageUrl placeholderImage:@"review-placeholder" isDashboardCell:true];
}
@end
