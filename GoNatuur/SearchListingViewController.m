//
//  SearchListingViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchListingViewController.h"
#import "SearchCollectionViewCell.h"
#import "SearchService.h"
#import "SearchDataModel.h"

@interface SearchListingViewController ()<UICollectionViewDelegateFlowLayout> {
@private
    int pageCount;
    int totalProducts;
    NSMutableArray *searchedProductsArray;
}
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;

@end

@implementation SearchListingViewController
@synthesize searchKeyword;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchedProductsArray=[[NSMutableArray alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getSerachProductListing) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=searchKeyword;
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    pageCount=1;
}
#pragma mark - end

#pragma mark - Webservice
- (void) getSerachProductListing{
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    searchData.serachKeyword=searchKeyword;
    searchData.searchPageCount=[@(pageCount) stringValue];
    [searchData getSearchProductListing:^(SearchDataModel *userData)  {
        [myDelegate stopIndicator];
        totalProducts=[userData.searchPageCount intValue];
        if (userData.searchProductListArray.count==0) {
            //_noResultLabel.hidden=NO;
        }
        else {
            //            _noResultLabel.hidden=YES;
            [searchedProductsArray addObjectsFromArray:userData.searchProductListArray];
            [_searchCollectionView reloadData];
        }
    } onfailure:^(NSError *error) {
        //        _noResultLabel.hidden=NO;
        //        _searchTableView.hidden=YES;
    }];
}
#pragma mark - end


#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return searchedProductsArray.count;
}

- (SearchCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    [searchCell.contentView addShadow:searchCell.contentView color:[UIColor redColor]];
    [searchCell displaySearchListData];
    return searchCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+105);
}
#pragma mark - end

@end
