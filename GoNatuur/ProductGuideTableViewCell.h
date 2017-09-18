//
//  ProductGuideTableViewCell.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductGuideTableViewCell : UITableViewCell
//product collection view
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
//product heading cell
@property (weak, nonatomic) IBOutlet UILabel *productHeading;
//webview cell
@property (weak, nonatomic) IBOutlet UIWebView *productGuideWebView;
//short description cell
@property (weak, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
//tagline cell
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;
//name cell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//subcategory collection cell
@property (weak, nonatomic) IBOutlet UICollectionView *subCategoryCollectionView;
//heading cell
@property (weak, nonatomic) IBOutlet UILabel *headingLabel;

- (void)displayProductBottomHeadingData:(NSString *)data;
- (void)displayProductName:(NSString *)data;
- (void)displayProductTagline:(NSString *)data;
- (void)displayProductShortDescription:(NSString *)data;
@end
