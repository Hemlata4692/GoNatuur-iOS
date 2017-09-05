//
//  WishlistViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 31/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "WishlistViewController.h"
#import "SearchCollectionViewCell.h"

@interface WishlistViewController () {
@private
    int pageCount, btnTag;
    int totalProductCount, currentpage;
    NSMutableArray *wishlistProductsArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *wishlistCollectionView;
@property (weak, nonatomic) IBOutlet UIView *paginationView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) NSString *wishlistItemId;

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
    _noRecordLabel.text=NSLocalizedText(@"norecord");
}
#pragma mark - end

#pragma mark - Webservice
- (void)getWislistItemsData {
    SearchDataModel *wishlistData = [SearchDataModel sharedUser];
     wishlistData.searchPageCount=[@(pageCount) stringValue];
    wishlistData.pageSize=[@(currentpage) stringValue] ;
    [wishlistData getWishlistService:^(SearchDataModel *userData)  {
        totalProductCount=[userData.searchResultCount intValue];
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
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
        _noRecordLabel.hidden=NO;
        _wishlistCollectionView.hidden=YES;
    }];

}

//remove from wishlist
- (void)removeItemFromWishlist {
    SearchDataModel *wishlistData = [SearchDataModel sharedUser];
    wishlistData.wishlistItemId=_wishlistItemId;
    [wishlistData removeFromWishlist:^(SearchDataModel *userData)  {
        wishlistProductsArray=[NSMutableArray new];
        [self getWislistItemsData];
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
//    if ([[[searchedProductsArray objectAtIndex:indexPath.item] productType] isEqualToString:eventIdentifier]) {
//        [self.view makeToast:NSLocalizedText(@"featureNotAvailable")];
//    }
//    else {
//        //StoryBoard navigation
//        ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
//        obj.selectedProductId=[[[searchedProductsArray objectAtIndex:indexPath.item] productId] intValue];
//        [self.navigationController pushViewController:obj animated:YES];
//    }
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)removeItemFromWishlist:(id)sender {
    NSLog(@"%ld",(long)[sender tag]);
    _wishlistItemId=[[wishlistProductsArray objectAtIndex:[sender tag]]wishlistItemId];
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
                [self getWislistItemsData];
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
