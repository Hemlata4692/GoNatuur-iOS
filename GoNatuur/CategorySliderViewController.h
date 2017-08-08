//
//  CategorySliderViewController.h
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategorySliderDelegate <NSObject>
@optional
- (void)selectedProduct:(int)option;
@end

@interface CategorySliderViewController : UIViewController {
    id <CategorySliderDelegate> _delegate;
}

@property (nonatomic,strong) id <CategorySliderDelegate>delegate;

@property (strong, nonatomic) IBOutlet UICollectionView *categorySliderCollectionView;
@end
