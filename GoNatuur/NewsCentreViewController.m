//
//  NewsCentreViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 31/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCentreViewController.h"
#import "GoNatuurFilterView.h"
#import "GoNatuurPickerView.h"
#import "ProductListTableViewCell.h"

@interface NewsCentreViewController () <UICollectionViewDelegateFlowLayout, GoNatuurFilterViewDelegate, GoNatuurPickerViewDelegate> {
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
    int lastSelectedCategoryId;
}

@property (strong, nonatomic) IBOutlet UILabel *noRecordLabel;
@property (strong, nonatomic) IBOutlet UITableView *newsListingTableView;
//Pull to refresh
@property (strong,nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NewsCentreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Add custom picker view and initialized indexs
    [self addCustomPickerView];
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
    [self viewInitialization];
//    [myDelegate showIndicator];
//    [self performSelector:@selector(getCategoryListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - View initialization
- (void)viewInitialization {
    _noRecordLabel.hidden=true;
    isPullToRefresh=false;
    totalProductCount=0;
    currentpage=1;
    _newsListingTableView.tableFooterView=nil;
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
    //Allocate footer view
    [self initializeFooterView];
    // Pull to refresh
    _refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(160, 0, 20, 20)];
    _refreshControl.tintColor=[UIColor colorWithRed:143.0/255.0 green:29.0/255.0 blue:55.0/255.0 alpha:1.0];
//    [_refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [_newsListingTableView addSubview:_refreshControl];
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
    [filterViewObj setButtonTitles:NSLocalizedText(@"Filter") subCategoryText:((subCategoryPickerArray.count>0)?[subCategoryPickerArray objectAtIndex:selectedSubCategoryIndex]:@"") secondFilterText:NSLocalizedText(@"Sortby")];
    //Customized filter view
    filterViewObj.firstFilterButtonOutlet.enabled=false;
    filterViewObj.secondFilterButtonOutlet.enabled=false;
    filterViewObj.firstFilterButtonOutlet.alpha=0.5;
    filterViewObj.secondFilterButtonOutlet.alpha=0.5;
    filterViewObj.firstFilterArrowImageView.alpha=0.4;
    filterViewObj.secondFilterArrowImageView.alpha=0.4;
    if (!myDelegate.isProductList) {
        filterViewObj.subCategoryButtonOutlet.enabled=false;
        filterViewObj.subCategoryButtonOutlet.alpha=0.5;
        filterViewObj.subCategoryArrowImageView.alpha=0.4;
    }
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
//        [cell.productListCollectionView reloadData];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *) cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (productListDataArray.count == totalProductCount) {
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] stopAnimating];
        [(UILabel *)[footerView viewWithTag:11] setHidden:true];
        [(UIActivityIndicatorView *)[footerView viewWithTag:10] setHidden:true];
        _newsListingTableView.tableFooterView = nil;
    }
    else if(indexPath.row==3) {//self.array is the array of items you are displaying
        if(productListDataArray.count <= totalProductCount) {
            _newsListingTableView.tableFooterView = footerView;
            [(UIActivityIndicatorView *)[footerView viewWithTag:10] startAnimating];
            currentpage+=1;
//            [self getProductListData];
        }
        else {
            _newsListingTableView.tableFooterView = nil;
        }
    }
}
#pragma mark - end


@end
