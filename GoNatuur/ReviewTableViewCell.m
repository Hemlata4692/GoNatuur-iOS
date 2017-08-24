//
//  ReviewTableViewCell.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "ImageCaching.h"
#import "DynamicHeightWidth.h"

@implementation ReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)removeAutolayouts {
    _reviewTitleLabel.translatesAutoresizingMaskIntoConstraints=YES;
    _reviewTextLabel.translatesAutoresizingMaskIntoConstraints=YES;
}

- (void)displayData :(ReviewDataModel *)listData reviewId:(NSString*)reviewId rectSize:(CGSize)rectSize {
    [self removeAutolayouts];
    _userName.text=listData.username;
    _reviewTitleLabel.text=listData.reviewTitle;
    float titleHeight =[DynamicHeightWidth getDynamicLabelHeight:_reviewTitleLabel.text font:[UIFont montserratBoldWithSize:13] widthValue:rectSize.width-93];
    _reviewTitleLabel.numberOfLines=2;
    
    if ([reviewId intValue]==0) {
        _reviewTitleLabel.frame=CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.width+20, _reviewTitleLabel.frame.origin.y, rectSize.width-93, titleHeight+1);
        _editReviewIcon.hidden=YES;
    }
    else {
        _reviewTitleLabel.frame=CGRectMake(_reviewTitleLabel.frame.origin.x, _reviewTitleLabel.frame.origin.y, rectSize.width-120, titleHeight+1);
        _editReviewIcon.hidden=NO;
    }
    
    _reviewTextLabel.text=listData.reviewDescription;
    float descriptionHeight =[DynamicHeightWidth getDynamicLabelHeight:_reviewTextLabel.text font:[UIFont montserratRegularWithSize:12] widthValue:rectSize.width-93];
    _reviewTextLabel.numberOfLines=0;
    if (titleHeight<=17 && descriptionHeight<=16) {
        _ratingView.frame=CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.width+17, _reviewTitleLabel.frame.origin.y+15, _ratingView.frame.size.width, _ratingView.frame.size.height);
        
        _reviewTextLabel.frame=CGRectMake(_reviewTextLabel.frame.origin.x, _reviewTitleLabel.frame.origin.y+_reviewTitleLabel.frame.size.height+4+_ratingView.frame.size.height+15, rectSize.width-93, descriptionHeight+1);
    }
    else if (titleHeight<=33 && descriptionHeight<=31) {
        _ratingView.translatesAutoresizingMaskIntoConstraints=YES;
        _ratingView.frame=CGRectMake(_userImageView.frame.origin.x+_userImageView.frame.size.width+17, _reviewTitleLabel.frame.origin.y+_reviewTitleLabel.frame.size.height+10, _ratingView.frame.size.width, _ratingView.frame.size.height);
        
        _reviewTextLabel.frame=CGRectMake(_reviewTextLabel.frame.origin.x, _reviewTitleLabel.frame.origin.y+_reviewTitleLabel.frame.size.height+4+_ratingView.frame.size.height+15, rectSize.width-93, descriptionHeight);
    }
    else {
        _reviewTextLabel.frame=CGRectMake(_reviewTextLabel.frame.origin.x, _reviewTitleLabel.frame.origin.y+_reviewTitleLabel.frame.size.height+4+_ratingView.frame.size.height+4, rectSize.width-93, descriptionHeight);
    }
    
    [self starRating:listData.ratingId];
    [_userImageView setCornerRadius:25];
    [ImageCaching downloadImages:_userImageView imageUrl:listData.userImageUrl placeholderImage:@"review-placeholder" isDashboardCell:true];
}

- (void)starRating:(NSString *)rating {
    _ratingView.starImage = [UIImage imageNamed:@"star-unselected"];
    _ratingView.starHighlightedImage = [UIImage imageNamed:@"star"];
    
    _ratingView.maxRating = 5.0;
    _ratingView.delegate = self;
    _ratingView.horizontalMargin = 6;
    _ratingView.editable=NO;
    _ratingView.rating= [rating floatValue];
    _ratingView.displayMode=EDStarRatingDisplayHalf;
}
@end
