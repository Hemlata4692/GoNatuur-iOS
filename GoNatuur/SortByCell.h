//
//  SortByCell.h
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortFilterModel.h"

@interface SortByCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ascLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
- (void)displaySortData:(CGSize)rectSize sortData:(SortFilterModel *)sortData;
@end
