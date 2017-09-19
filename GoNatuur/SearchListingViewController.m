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
#import "ProductDetailViewController.h"
#import "UIView+Toast.h"

@interface SearchListingViewController ()<UICollectionViewDelegateFlowLayout> {
@private
    int pageCount;
    int totalProducts;
    NSMutableArray *searchedProductsArray;
    NSMutableArray *searchListIds;
}
@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation SearchListingViewController
@synthesize searchKeyword;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchedProductsArray=[[NSMutableArray alloc]init];
    _paginationView.hidden=YES;
    _noRecordLabel.hidden=YES;
     pageCount=10;
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
    _noRecordLabel.text=NSLocalizedText(@"norecord");
}
#pragma mark - end

#pragma mark - Webservice
- (void)getSerachProductListing {
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    searchData.serachKeyword=searchKeyword;
    searchData.searchPageCount=[@(pageCount) stringValue];
    [searchData getSearchProductListing:^(SearchDataModel *userData)  {
        [myDelegate stopIndicator];
        totalProducts=[userData.searchResultCount intValue];
        if (userData.searchProductListArray.count==0) {
            _noRecordLabel.hidden=NO;
        }
        else {
            searchListIds=[[userData searchProductIds] mutableCopy];
            [self removeObectsFromSearchListWithLimit];
            _noRecordLabel.hidden=YES;
            [searchedProductsArray addObjectsFromArray:userData.searchProductListArray];
            [_searchCollectionView reloadData];
        }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _searchCollectionView.hidden=YES;
    }];
}

- (void)getSearchPaginationList {
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    NSString *productIds=[NSString stringWithFormat:@"%@",[searchListIds objectAtIndex:0]];
    for (int i=1; i<pageCount; i++) {
        if (i<searchListIds.count) {
            productIds=[NSString stringWithFormat:@"%@,%@",productIds,[searchListIds objectAtIndex:i]];
        }
    }
    searchData.productId=productIds;
    [searchData getProductListServiceOnSuccess:^(SearchDataModel *userData)  {
        [self removeObectsFromSearchListWithLimit];
        [searchedProductsArray addObjectsFromArray:userData.searchProductListArray];
        [self hideactivityIndicator];
    } onfailure:^(NSError *error) {
        [self hideactivityIndicator];
    }];
}

- (void)removeObectsFromSearchListWithLimit {
    for (int i=0; i<pageCount; i++) {
        if (i<searchListIds.count) {
            [searchListIds removeObjectAtIndex:0];
        }
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return searchedProductsArray.count;
}

- (SearchCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    [searchCell displayProductListData:[searchedProductsArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
    return searchCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[searchedProductsArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
    }
    else {
        //StoryBoard navigation
        ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        obj.selectedProductId=[[[searchedProductsArray objectAtIndex:indexPath.item] productId] intValue];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
#pragma mark - end

#pragma mark - Pagination
//Handling pagination in collection view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    if (_paginationView.hidden==YES) {
        if (_searchCollectionView.contentOffset.y == _searchCollectionView.contentSize.height - scrollView1.frame.size.height) {
            if (searchedProductsArray.count<totalProducts) {
                _paginationView.hidden=NO;
                [self getSearchPaginationList];
            }
        }
    }
}

- (void)hideactivityIndicator {
    _paginationView.hidden=YES;
    [_searchCollectionView reloadData];
}
#pragma mark - end

@end
