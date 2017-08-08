//
//  CategorySliderViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "CategorySliderViewController.h"
#import "CategorySliderCell.h"
#import "DynamicHeightWidth.h"

@interface CategorySliderViewController ()<UICollectionViewDelegateFlowLayout> {
@private
    NSArray *categoryListArray;
}
@end

@implementation CategorySliderViewController
@synthesize categorySliderCollectionView;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    categoryListArray=@[@"Products value", @"value", @"c", @"d",@"a", @"b", @"c", @"d"];
    
    //Load category slider cell xib
    [categorySliderCollectionView registerNib:[UINib nibWithNibName:@"CategorySliderCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
    [categorySliderCollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark- Collection view delegate and datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return categoryListArray.count;
}

- (CategorySliderCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategorySliderCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    if (myDelegate.selectedCategoryIndex==indexPath.row) {
        [categoryCell displaySliderItems:[categoryListArray objectAtIndex:indexPath.row] isSelected:true];
    }
    else {
        [categoryCell displaySliderItems:[categoryListArray objectAtIndex:indexPath.row] isSelected:false];
    }
    return categoryCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way..
    return CGSizeMake([DynamicHeightWidth getDynamicLabelWidth:[categoryListArray objectAtIndex:indexPath.row] font:[UIFont fontWithName:@"Montserrat-SemiBold" size:17.0] widthValue:[[UIScreen mainScreen] bounds].size.width]+30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    myDelegate.selectedCategoryIndex=(int)indexPath.row;
    [_delegate selectedProduct:(int)indexPath.row];
    [categorySliderCollectionView reloadData];
}
#pragma mark - end

@end
