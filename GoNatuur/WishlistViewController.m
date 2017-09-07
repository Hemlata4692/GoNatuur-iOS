//
//  WishlistViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 31/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "WishlistViewController.h"
#import "SearchCollectionViewCell.h"
#import "ProductDetailViewController.h"

@interface WishlistViewController () {
@private
    int pageCount, btnTag;
    int totalProductCount, currentpage;
    NSMutableArray *wishlistProductsArray;
     bool isPullToRefresh;
}

@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) NSString *wishlistItemId;
//Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

@implementation WishlistViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    wishlistProductsArray=[[NSMutableArray alloc]init];
    _paginationView.hidden=YES;
    _noRecordLabel.hidden=YES;
    pageCount=10;
    currentpage=1;
    [myDelegate showIndicator];
    [self performSelector:@selector(getWislistItemsData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
    myDelegate.selectedCategoryIndex=-1;
    [self showSelectedTab:3];
    isPullToRefresh=false;
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    // Pull to refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-10, 0, 20, 20)];
    _refreshControl.tintColor=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    [_refreshControl addTarget:self action:@selector(refreshWishlistItem) forControlEvents:UIControlEventValueChanged];
    [_wishlistCollectionView addSubview:_refreshControl];
    _wishlistCollectionView.alwaysBounceVertical = YES;
}
#pragma mark - end

#pragma mark - Pull to refresh
- (void)refreshWishlistItem {
    isPullToRefresh=true;
    currentpage=1;
    pageCount=10;
    [self performSelector:@selector(getWislistItemsData) withObject:nil afterDelay:.1];
    [_refreshControl endRefreshing];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getWislistItemsData {
    SearchDataModel *wishlistData = [SearchDataModel sharedUser];
    wishlistData.searchPageCount=[@(pageCount) stringValue];
    wishlistData.pageSize=[@(currentpage) stringValue] ;
    [wishlistData getWishlistService:^(SearchDataModel *userData)  {
        
        if (isPullToRefresh) {
            wishlistProductsArray=[NSMutableArray new];
            totalProductCount=0;
        }
        if (userData.searchProductListArray.count==0) {
            _noRecordLabel.hidden=NO;
            wishlistProductsArray=[NSMutableArray new];
            [_wishlistCollectionView reloadData];
        }
        else {
            _noRecordLabel.hidden=YES;
           [wishlistProductsArray addObjectsFromArray:userData.searchProductListArray];
            [_wishlistCollectionView reloadData];
        }
        totalProductCount=[userData.searchResultCount intValue];
        [self hideactivityIndicator];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _wishlistCollectionView.hidden=YES;
        [self hideactivityIndicator];
    }];
}

//remove from wishlist
- (void)removeItemFromWishlist {
    SearchDataModel *wishlistData = [SearchDataModel sharedUser];
    wishlistData.wishlistItemId=_wishlistItemId;
    [wishlistData removeFromWishlist:^(SearchDataModel *userData)  {
        [wishlistProductsArray removeObjectAtIndex:btnTag];
        totalProductCount=totalProductCount-1;
        if (wishlistProductsArray.count>(currentpage-1)*pageCount) {
            NSArray *tempDataArray=[wishlistProductsArray subarrayWithRange:NSMakeRange((currentpage-1)*pageCount, wishlistProductsArray.count-((currentpage-1)*pageCount))];
            [wishlistProductsArray removeObjectsInArray:tempDataArray];
            totalProductCount=(int)wishlistProductsArray.count;
            [self getWislistItemsData];
        }
        [_wishlistCollectionView reloadData];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _wishlistCollectionView.hidden=YES;
    }];
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return wishlistProductsArray.count;
}

- (SearchCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SearchCollectionViewCell *searchCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"searchCell" forIndexPath:indexPath];
    [searchCell displayProductListData:[wishlistProductsArray objectAtIndex:indexPath.item] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
    [searchCell.removeItemButton addTarget:self action:@selector(removeItemFromWishlist:) forControlEvents:UIControlEventTouchUpInside];
    searchCell.removeItemButton.tag=indexPath.item;
    return searchCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[wishlistProductsArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
       //event details
    }
    else {
        //StoryBoard navigation
        ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
        obj.selectedProductId=[[[wishlistProductsArray objectAtIndex:indexPath.item] productId] intValue];
        [self.navigationController pushViewController:obj animated:YES];
    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)removeItemFromWishlist:(id)sender {
    NSLog(@"%ld",(long)[sender tag]);
    btnTag=(int)[sender tag];
    _wishlistItemId=[[wishlistProductsArray objectAtIndex:btnTag]wishlistItemId];
    [myDelegate showIndicator];
    [self performSelector:@selector(removeItemFromWishlist) withObject:nil afterDelay:.1];

}
#pragma mark - end

#pragma mark - Pagination
//Handling pagination in collection view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    if (_paginationView.hidden==YES) {
        if (_wishlistCollectionView.contentOffset.y == _wishlistCollectionView.contentSize.height - scrollView1.frame.size.height) {
            if (wishlistProductsArray.count<totalProductCount) {
                _paginationView.hidden=NO;
                 currentpage+=1;
                isPullToRefresh=false;
                [self getWislistItemsData];
            }
            else if (wishlistProductsArray.count==totalProductCount){
                _paginationView.hidden=YES;
            }
        }
    }
}

- (void)hideactivityIndicator {
    _paginationView.hidden=YES;
    [_wishlistCollectionView reloadData];
}
#pragma mark - end
@end
