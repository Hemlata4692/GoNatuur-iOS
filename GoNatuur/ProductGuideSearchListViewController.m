//
//  ProductGuideSearchListViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 18/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideSearchListViewController.h"
#import "ProductGuideDataModel.h"
#import "ProductGuideCollectionViewCell.h"
#import "ProductGuideViewController.h"

@interface ProductGuideSearchListViewController () {
    @private
    NSMutableArray *serachDataArray;
    int pageCount;
    int totalProducts;
}
@property (weak, nonatomic) IBOutlet UICollectionView *productGuideSearchTable;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (weak, nonatomic) IBOutlet UIView *paginationView;

@end

@implementation ProductGuideSearchListViewController
@synthesize searchKeyword;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _paginationView.hidden=YES;
    _noRecordLabel.hidden=YES;
    pageCount=1;
    serachDataArray=[[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductGuideSearchData) withObject:nil afterDelay:.1];
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
- (void)getProductGuideSearchData {
    ProductGuideDataModel *categoryList = [ProductGuideDataModel sharedUser];
    categoryList.isSearch=@"Yes";
    categoryList.searchKeywod=searchKeyword;
    categoryList.pageSize=[UserDefaultManager getValue:@"paginationSize"];
    categoryList.currentPage=[NSNumber numberWithInt:pageCount];
    [categoryList getProductGuideDetailsCategoryData:^(ProductGuideDataModel *userData)  {
        [myDelegate stopIndicator];
        totalProducts=[userData.totalProductCount intValue];
        if (userData.postDataArray.count!=0) {
            _productGuideSearchTable.hidden=false;
            _noRecordLabel.hidden=true;
            [serachDataArray addObjectsFromArray:userData.postDataArray];
            [_productGuideSearchTable reloadData];
            [self hideactivityIndicator];
        }
        else {
            _productGuideSearchTable.hidden=true;
            _noRecordLabel.hidden=false;
        }
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return serachDataArray.count;
}

- (ProductGuideCollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        ProductGuideCollectionViewCell *productCollectionCell = [cv dequeueReusableCellWithReuseIdentifier:@"productCollectionCell" forIndexPath:indexPath];
        [productCollectionCell.contentView setBorder:productCollectionCell.contentView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
        [productCollectionCell.contentView setCornerRadius:5.0];
        [productCollectionCell displayProductListSearchData:[serachDataArray objectAtIndex:indexPath.row]];
        return productCollectionCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = ([[UIScreen mainScreen] bounds].size.width-20) / 2.0;
    return CGSizeMake(picDimension-8, picDimension+80);
}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //StoryBoard navigation
        ProductGuideViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductGuideViewController"];
        obj.selectedPostId=[[serachDataArray objectAtIndex:indexPath.row] postId];
        obj.screenType=@"searchGuide";
        [self.navigationController pushViewController:obj animated:YES];
    
}
#pragma mark - end

#pragma mark - Pagination
//Handling pagination in collection view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    if (_paginationView.hidden==YES) {
        if (_productGuideSearchTable.contentOffset.y == _productGuideSearchTable.contentSize.height - scrollView1.frame.size.height) {
            if (serachDataArray.count<totalProducts) {
                _paginationView.hidden=NO;
                pageCount++;
                [self getProductGuideSearchData];
            }
        }
    }
}

- (void)hideactivityIndicator {
    _paginationView.hidden=YES;
    [_productGuideSearchTable reloadData];
}
#pragma mark - end
@end
