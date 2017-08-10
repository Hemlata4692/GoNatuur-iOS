//
//  DashboardViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardViewController.h"
#import "DasboardDataCollectionViewCell.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *buttonSeperator;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *footerImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *footerImageCollectionView;

@end

@implementation DashboardViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"GoNatuur";
    [self addLeftBarButtonWithImage:false];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (view==_productCollectionView) {
        return 10;
    }
    else {
        return 3;
    }
}

- (DasboardDataCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==_productCollectionView) {
    DasboardDataCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    return productCell;
    }
    else {
        DasboardDataCollectionViewCell *footerImageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"footerImageCell" forIndexPath:indexPath];
        return footerImageCell;
    }
}
#pragma mark - end


#pragma mark - IBActions
- (IBAction)healthyLivingButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}
- (IBAction)bestSellerButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}
- (IBAction)samplersButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}
#pragma mark - end

#pragma mark - Set animation for button bottom selection
- (void)reframeSeperatorLabel:(UIButton *)button {
    CGPoint endFrame = button.center;
    [UIView animateWithDuration:0.5 animations:^{
        _buttonSeperator.center = endFrame;
        _buttonSeperator.frame=CGRectMake(button.frame.origin.x+(button.frame.size.width/2)-(_buttonSeperator.frame.size.width/2), button.frame.size.height-2, _buttonSeperator.frame.size.width, _buttonSeperator.frame.size.height);
    }];
}
#pragma mark - end
@end
