//
//  ProductListingViewController.m
//  GoNatuur
//
//  Created by Ranosys on 16/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductListingViewController.h"
#import "ProductListCollectionViewCell.h"
#import "ProductListTableViewCell.h"
#import "DashboardDataModel.h"
#import "GoNatuurFilterView.h"
#import "GoNatuurPickerView.h"
#import "ProductDetailViewController.h"

@interface ProductListingViewController ()<UICollectionViewDelegateFlowLayout, GoNatuurFilterViewDelegate, GoNatuurPickerViewDelegate> {
    NSMutableArray *productListDataArray, *subCategoryDataList, *subCategoryPickerArray;
    int totalProductCount, currentpage;
    NSString *bannerImageUrl;
    float productListHeight;
    UIView *footerView;
    bool isPullToRefresh;
    GoNatuurFilterView *filterViewObj;
    int selectedFirstFilterIndex, selectedSubCategoryIndex, selectedSecondFilterIndex;
    GoNatuurPickerView *gNPickerViewObj;
    int currentCategoryId;
}
@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (strong, nonatomic) IBOutlet UITableView *productListTableView;
//Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;
@end

@implementation ProductListingViewController
@synthesize selectedProductCategoryId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"GoNatuur");
    [self addLeftBarButtonWithImage:false];
    [self viewInitialization];
    [myDelegate showIndicator];
    [self performSelector:@selector(getCategoryListData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - View initialization
- (void)viewInitialization {
    if (!myDelegate.isProductList) {
        currentCategoryId=21;
    }
    else {
        currentCategoryId=selectedProductCategoryId;
    }
    bannerImageUrl=@"";
    _noRecordLabel.hidden=true;
    isPullToRefresh=false;
    productListDataArray=[NSMutableArray new];
    subCategoryDataList=[NSMutableArray new];
    totalProductCount=0;
    currentpage=1;
    _productListTableView.tableFooterView=nil;
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
    //Allocate footer view
    [self initializeFooterView];
    // Pull to refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(160, 0, 20, 20)];
    _refreshControl.tintColor=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [_productListTableView addSubview:_refreshControl];
}

- (void)initializeFooterView {
    footerView=[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, 40.0)];
    UIActivityIndicatorView *activityIndicatorObject = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorObject.color=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
    activityIndicatorObject.tag = 10;
    activityIndicatorObject.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width/2-10, 0.0, 20.0, 20.0);
    activityIndicatorObject.hidesWhenStopped = YES;
    [footerView addSubview:activityIndicatorObject];
}

- (void)addCustomPickerView {
    //Add filter xib view
    filterViewObj=[[GoNatuurFilterView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35) delegate:self];
    filterViewObj.frame=CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 35);
    [filterViewObj setButtonTitles:@"" subCategoryText:((subCategoryPickerArray.count>0)?[subCategoryPickerArray objectAtIndex:selectedSubCategoryIndex]:@"") secondFilterText:@""];
    //Set initial index of picker view and initialized picker view
    selectedFirstFilterIndex=0;
    selectedSubCategoryIndex=0;
    selectedSecondFilterIndex=0;
    subCategoryPickerArray=[NSMutableArray new];
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:self.view.frame delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Table view datasource/delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return 180.0;
    }
    else if (indexPath.row==1) {
        return 35.0;
    }
    else if (indexPath.row==2) {
        return productListHeight;
    }
    else {
        return 1; //Use for pagination in willDisplayCell
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductListTableViewCell *cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"BannerImageCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerImageCell"];
        }
        [cell displayBannerImage:bannerImageUrl];
    }
    else if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"filterCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filterCell"];
        }
        
        [cell.contentView addSubview:filterViewObj.goNatuurFilterViewObj];
    }
    else if (indexPath.row==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productListCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productListCell"];
        }
        [cell.productListCollectionView reloadData];
    }
    else {
        //No any use this cell to display data. This cell will be used for pagination in willDisplayCell
        cell = [tableView dequeueReusableCellWithIdentifier:@"refreshCell"];
        if (cell == nil){
            cell = [[ProductListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"refreshCell"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ReviewListingViewController * searchView=[sb instantiateViewControllerWithIdentifier:@"ReviewListingViewController"];
//    [self.navigationController pushViewController:searchView animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (productListDataArray.count == totalProductCount)
    {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
        _productListTableView.tableFooterView = nil;
    }
    else if(indexPath.row==3) //self.array is the array of items you are displaying
    {
        if(productListDataArray.count <= totalProductCount)
        {
            _productListTableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            currentpage+=1;
            [self getProductListData];
        }
        else
        {
            _productListTableView.tableFooterView = nil;
        }
    }
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return productListDataArray.count;
}

- (ProductListCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductListCollectionViewCell *productCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productCell" forIndexPath:indexPath];
    [productCell displayProductListData:[productListDataArray objectAtIndex:indexPath.row] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
    return productCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //You may want to create a divider to scale the size by the way.
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    return CGSizeMake(picDimension-5, picDimension+105);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //StoryBoard navigation
    ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
    obj.selectedProductId=[[[productListDataArray objectAtIndex:indexPath.row] productId] intValue];
    [self.navigationController pushViewController:obj animated:YES];
}
#pragma mark - end

#pragma mark - Webservice
//Get sub category list data
- (void)getCategoryListData {
    DashboardDataModel *subCategoryList = [DashboardDataModel sharedUser];
    subCategoryList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    [subCategoryList getCategoryListDataOnSuccess:^(DashboardDataModel *userData)  {
        subCategoryDataList=[userData.categoryNameArray mutableCopy];
        if (subCategoryDataList.count>0) {
            for (int i=0; i<subCategoryDataList.count; i++) {
                [subCategoryPickerArray addObject:[[subCategoryDataList objectAtIndex:i] objectForKey:@"name"]];
            }
            [filterViewObj.subCategoryButtonOutlet setTitle:[subCategoryPickerArray objectAtIndex:0] forState:UIControlStateNormal];
        }
        else {
            [filterViewObj.subCategoryButtonOutlet setTitle:@"" forState:UIControlStateNormal];
        }
        [self getCategoryBannerData];
    } onfailure:^(NSError *error) {
        [self getCategoryBannerData];
    }];
}

//Get sub category list data
- (void)getCategoryBannerData {
    DashboardDataModel *bannerData = [DashboardDataModel sharedUser];
    bannerData.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    [bannerData getCategoryBannerData:^(DashboardDataModel *userData)  {
        bannerImageUrl=userData.banerImageUrl;
        [self getProductListData];
    } onfailure:^(NSError *error) {
        [self getProductListData];
    }];
}

//Get product list service
- (void)getProductListData {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    productList.categoryId=[NSString stringWithFormat:@"%d",currentCategoryId];
    productList.pageSize=[NSNumber numberWithInt:12];
    productList.currentPage=[NSNumber numberWithInt:currentpage];
    [productList getProductListService:^(DashboardDataModel *productData)  {
        [myDelegate stopIndicator];
        [self serviceDataHandling:productData];
    } onfailure:^(NSError *error) {
        [_refreshControl endRefreshing];
    }];
}
#pragma mark - end

#pragma mark - Service handling
- (void)serviceDataHandling:(DashboardDataModel *)productData {
    if (isPullToRefresh) {
        isPullToRefresh=false;
        productListDataArray=[NSMutableArray new];
        totalProductCount=0;
        currentpage=1;
    }
    if (productListDataArray.count>0) {
        [productListDataArray addObjectsFromArray:productData.productDataArray];
    }
    else {
        productListDataArray=productData.productDataArray.mutableCopy;
    }
    
    if (productListDataArray.count>0) {
        _noRecordLabel.hidden=true;
    }
    else {
        _noRecordLabel.hidden=false;
    }
    totalProductCount=[productData.totalProductCount intValue];
    float picDimension = (self.view.frame.size.width-20) / 2.0;
    int rowCount=(int)productListDataArray.count/2;
    if (productListDataArray.count%2!=0) {
        rowCount+=1;
    }
    [_refreshControl endRefreshing];
    productListHeight=(rowCount*(picDimension+105))+35+((rowCount-1)*10);   //productListHeight: (rowCount*cellHeight)+35+((rowCount-1)*cellRowSpacing)
    [_productListTableView reloadData];
}
#pragma mark - end

#pragma mark - Pull to refresh
- (void)refreshControlAction {
    isPullToRefresh=true;
    [self performSelector:@selector(getProductListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Filter delegate
- (void)goNatuurFilterViewDelegateActionIndex:(int)option {
    DLog(@"%d",option);
    if (option==1) {
        if (subCategoryPickerArray.count>0) {
            [gNPickerViewObj showPickerView:subCategoryPickerArray selectedIndex:selectedSubCategoryIndex option:1];
        }
    }
}

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedSubCategoryIndex!=tempSelectedIndex) {
            selectedSubCategoryIndex=tempSelectedIndex;
            [filterViewObj.subCategoryButtonOutlet setTitle:[subCategoryPickerArray objectAtIndex:tempSelectedIndex] forState:UIControlStateNormal];
            currentCategoryId=[[[subCategoryDataList objectAtIndex:selectedSubCategoryIndex] objectForKey:@"id"] intValue];
            [myDelegate showIndicator];
            [self performSelector:@selector(getCategoryBannerData) withObject:nil afterDelay:.1];
        }
    }
}
#pragma mark - end
@end
