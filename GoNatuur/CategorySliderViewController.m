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
     [_shadowView addShadow:_shadowView color:[UIColor darkGrayColor]];

//    //Load category slider cell xib
    [categorySliderCollectionView registerNib:[UINib nibWithNibName:@"CategorySliderCell" bundle:nil] forCellWithReuseIdentifier:@"categoryCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    categoryDataArray=[[NSMutableArray alloc]init];
    categoryDataArray=[myDelegate.categoryNameArray mutableCopy];
    [categorySliderCollectionView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ((categoryDataArray.count>0)&&(myDelegate.selectedCategoryIndex!=-1)) {
        [categorySliderCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:myDelegate.selectedCategoryIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
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
    if (myDelegate.selectedCategoryIndex!=(int)indexPath.row) {
        myDelegate.isProductList=true;
        myDelegate.selectedCategoryIndex=(int)indexPath.row;
        [_delegate selectedProduct:(int)indexPath.row];
        [categorySliderCollectionView reloadData];
    }
}
#pragma mark - end

@end
