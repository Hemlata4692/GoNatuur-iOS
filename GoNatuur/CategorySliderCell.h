//
//  CategorySliderCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySliderCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryName;

- (void)displaySliderItems:(NSString *)name isSelected:(BOOL)isSelected;
@end
