//
//  DashboardViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *buttonSeperator;
@property (weak, nonatomic) IBOutlet UIButton *heatlthyLivingButton;
@property (weak, nonatomic) IBOutlet UIButton *bestSellerButton;
@property (weak, nonatomic) IBOutlet UIButton *samplersButton;

@end

@implementation DashboardViewController

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

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    return categoryCell;
}

- (IBAction)healthyLivingButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}
- (IBAction)bestSellerButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}
- (IBAction)samplersButtonAction:(id)sender {
    [self reframeSeperatorLabel:sender];
}

- (void)reframeSeperatorLabel:(UIButton *)button {
    CGPoint endFrame = button.center;
    [UIView animateWithDuration:0.5 animations:^{
        _buttonSeperator.center = endFrame;
        _buttonSeperator.frame=CGRectMake(button.frame.origin.x+(button.frame.size.width/2)-(_buttonSeperator.frame.size.width/2), button.frame.size.height-2, _buttonSeperator.frame.size.width, _buttonSeperator.frame.size.height);
    }];
}
@end
