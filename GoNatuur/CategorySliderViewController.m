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

@interface CategorySliderViewController ()<UICollectionViewDelegateFlowLayout>

@end

@implementation CategorySliderViewController
@synthesize categorySliderCollectionView;
@synthesize categoryDataArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    categoryDataArray=[[NSMutableArray alloc]init];
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
    return categoryDataArray.count;
}

- (CategorySliderCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategorySliderCell *categoryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    NSDictionary *dataDict=[categoryDataArray objectAtIndex:indexPath.row];
    if (myDelegate.selectedCategoryIndex==indexPath.row) {
        [categoryCell displaySliderItems:[dataDict objectForKey:@"name"] isSelected:true];
    }
    else {
        [categoryCell displaySliderItems:[dataDict objectForKey:@"name"] isSelected:false];
    }
    return categoryCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way..
     NSDictionary *dataDict=[categoryDataArray objectAtIndex:indexPath.row];
    return CGSizeMake([DynamicHeightWidth getDynamicLabelWidth:[dataDict objectForKey:@"name"] font:[UIFont fontWithName:@"Montserrat-SemiBold" size:17.0] widthValue:[[UIScreen mainScreen] bounds].size.width]+30, 30);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    myDelegate.selectedCategoryIndex=(int)indexPath.row;
    [_delegate selectedProduct:(int)indexPath.row];
    [categorySliderCollectionView reloadData];
}
#pragma mark - end

@end
