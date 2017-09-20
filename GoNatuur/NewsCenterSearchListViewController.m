//
//  NewsCenterSearchListViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 08/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCenterSearchListViewController.h"
#import "SearchCollectionViewCell.h"
#import "DashboardDataModel.h"
#import "NewsCentreDetailViewController.h"
#import "NewsCentreCollectionViewCell.h"

@interface NewsCenterSearchListViewController ()<UICollectionViewDelegateFlowLayout> {
@private
    int pageCount;
    int totalProducts;
    NSMutableArray *searchedProductsArray;
    NSMutableArray *searchListIds;
}
@property (weak, nonatomic) IBOutlet UICollectionView *newsSearchCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;

@end

@implementation NewsCenterSearchListViewController
@synthesize searchKeyword;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    searchedProductsArray=[[NSMutableArray alloc]init];
    _paginationView.hidden=YES;
    _noRecordLabel.hidden=YES;
    pageCount=1;
    [myDelegate showIndicator];
    [self performSelector:@selector(getSerachNewsListing) withObject:nil afterDelay:.1];
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
- (void)getSerachNewsListing {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    productList.newsType=@"search";
    productList.pageSize=[NSNumber numberWithInt:12];
    productList.currentPage=[NSNumber numberWithInt:pageCount];
    productList.categoryName=searchKeyword;
    [productList getNewsListDataService:^(DashboardDataModel *productData)  {
        [myDelegate stopIndicator];
        totalProducts=[productList.totalProductCount intValue];
                if (productList.productDataArray.count==0) {
                    _noRecordLabel.hidden=NO;
                }
                else {
                    _noRecordLabel.hidden=YES;
                    [searchedProductsArray addObjectsFromArray:productList.productDataArray];
                    [_newsSearchCollectionView reloadData];
                    [self hideactivityIndicator];
                }
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _newsSearchCollectionView.hidden=YES;
        [self hideactivityIndicator];
    }];
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return searchedProductsArray.count;
}

- (NewsCentreCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NewsCentreCollectionViewCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    [searchCell displayProductListData:[searchedProductsArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
    return searchCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = ([[UIScreen mainScreen] bounds].size.width-20) / 2.0;
    return CGSizeMake(picDimension-8, picDimension+80);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//        //StoryBoard navigation
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewsCentreDetailViewController * webView=[sb instantiateViewControllerWithIdentifier:@"NewsCentreDetailViewController"];
    webView.navigationTitle=[[searchedProductsArray objectAtIndex:indexPath.item]productName];
    webView.newsPostId=[[searchedProductsArray objectAtIndex:indexPath.item]productId];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark - end

#pragma mark - Pagination
//Handling pagination in collection view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    if (_paginationView.hidden==YES) {
        if (_newsSearchCollectionView.contentOffset.y == _newsSearchCollectionView.contentSize.height - scrollView1.frame.size.height) {
            if (searchedProductsArray.count<totalProducts) {
                _paginationView.hidden=NO;
                pageCount++;
                [self getSerachNewsListing];
            }
        }
    }
}

- (void)hideactivityIndicator {
    _paginationView.hidden=YES;
    [_newsSearchCollectionView reloadData];
}
#pragma mark - end
@end
