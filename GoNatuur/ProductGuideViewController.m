//
//  ProductGuideViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 14/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductGuideViewController.h"
#import "DynamicHeightWidth.h"
#import "ProductGuideTableViewCell.h"
#import "ProductGuideCollectionViewCell.h"
#import "ProductGuideDataModel.h"
#import "SearchDataModel.h"

@interface ProductGuideViewController () {
    @private
    NSArray *productGuideMenuArray;
    NSMutableArray *productGuideCategoryArray;
    NSMutableArray *guideDetailDataArray;
    NSString *categoryHeading;
    BOOL isServiceCalled, categoryServiceCalled;
    int cellIndex, categoryIndex;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *productGuideTableView;

@end

@implementation ProductGuideViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     productGuideMenuArray = @[@"headingCell", @"subCategoryCell", @"nameCell", @"taglineCell", @"shortDescriptionCell", @"webViewCell", @"productHeadingCell", @"productCell"];
    productGuideCategoryArray=[[NSMutableArray alloc]init];
    guideDetailDataArray=[[NSMutableArray alloc]init];
    categoryIndex=0;
    cellIndex=0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=NSLocalizedText(@"productGuide");
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:false];
    isServiceCalled=false;
    categoryServiceCalled=false;
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductGuideCategoryListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark - Webservice
//Get category list data
- (void)getProductGuideCategoryListData {
    ProductGuideDataModel *categoryList = [ProductGuideDataModel sharedUser];
    [categoryList getProductGuideCategoryData:^(ProductGuideDataModel *userData)  {
        categoryServiceCalled=true;
        productGuideCategoryArray=[userData.guideCategoryDataArray mutableCopy];
        categoryHeading=[[productGuideCategoryArray objectAtIndex:0]categoryDescription];
        [_categoryCollectionView reloadData];
        [self getProductGuideCategoryDetials:[[productGuideCategoryArray objectAtIndex:0]categoryId]];
    } onfailure:^(NSError *error) {
    }];
}

- (void)getProductGuideCategoryDetials:(NSString *)categoryId {
    ProductGuideDataModel *categoryList = [ProductGuideDataModel sharedUser];
    categoryList.categoryId=categoryId;
    [categoryList getProductGuideDetailsCategoryData:^(ProductGuideDataModel *userData)  {
        isServiceCalled=true;
        if (userData.postDataArray.count!=0) {
            guideDetailDataArray=[userData.postDataArray mutableCopy];
            [_productGuideTableView reloadData];
            [self getStaticProductListing];
        }
        else {
            //no recoed label
        }
       // [myDelegate stopIndicator];
        
    } onfailure:^(NSError *error) {
    }];
}

- (void)getStaticProductListing {
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    searchData.serachKeyword=[[guideDetailDataArray objectAtIndex:cellIndex] postName];
    searchData.searchPageCount=@"3";
    [searchData getSearchProductListing:^(SearchDataModel *userData)  {
        [myDelegate stopIndicator];
//        totalProducts=[userData.searchResultCount intValue];
//        if (userData.searchProductListArray.count==0) {
//            _noRecordLabel.hidden=NO;
//        }
//        else {
//            searchListIds=[[userData searchProductIds] mutableCopy];
//            [self removeObectsFromSearchListWithLimit];
//            _noRecordLabel.hidden=YES;
//            [searchedProductsArray addObjectsFromArray:userData.searchProductListArray];
//            [_searchCollectionView reloadData];
       /// }
    } onfailure:^(NSError *error) {
//        _noRecordLabel.hidden=NO;
//        _searchCollectionView.hidden=YES;
    }];
}
#pragma mark - end

#pragma mark - Table view datasource/delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isServiceCalled) {
    return productGuideMenuArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return [DynamicHeightWidth getDynamicLabelHeight:categoryHeading font:[UIFont montserratSemiBoldWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-50]+20;
    }
    else if (indexPath.row==1) {
       return 90;
    }
    else if (indexPath.row==2) {
        if ((nil==[[guideDetailDataArray objectAtIndex:cellIndex] postName]) ||[[[guideDetailDataArray objectAtIndex:cellIndex] postName] isEqualToString:@""]) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[[guideDetailDataArray objectAtIndex:cellIndex] postName] font:[UIFont montserratMediumWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50];
        }
    }
    else if (indexPath.row==3) {
        if ([[[guideDetailDataArray objectAtIndex:cellIndex] tagline] isEqualToString:@""] || (nil==[[guideDetailDataArray objectAtIndex:cellIndex] tagline])) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[[guideDetailDataArray objectAtIndex:cellIndex] tagline] font:[UIFont montserratLightWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width-50]+10;
        }
    }
    else if (indexPath.row==4) {
        if ([[[guideDetailDataArray objectAtIndex:cellIndex] shortDescription] isEqualToString:@""] || (nil==[[guideDetailDataArray objectAtIndex:cellIndex] shortDescription])) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[[guideDetailDataArray objectAtIndex:cellIndex] shortDescription] font:[UIFont montserratLightWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width-50]+10;
        }
    }
    else if (indexPath.row==5) {
        if ([[[guideDetailDataArray objectAtIndex:cellIndex] postContent] isEqualToString:@""] || (nil==[[guideDetailDataArray objectAtIndex:cellIndex] postContent])) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[[guideDetailDataArray objectAtIndex:cellIndex] postContent] font:[UIFont montserratLightWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width-50]+3;
        }
    }
    else if (indexPath.row==6) {
        if ([[[guideDetailDataArray objectAtIndex:cellIndex] postName] isEqualToString:@""] || (nil==[[guideDetailDataArray objectAtIndex:cellIndex] postName])) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"productGuideText"),[[[guideDetailDataArray objectAtIndex:cellIndex] postName] uppercaseString]] font:[UIFont montserratMediumWithSize:16] widthValue:[[UIScreen mainScreen] bounds].size.width-50]+15;
        }
    }
    else if (indexPath.row==7) {
       return 200;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [productGuideMenuArray objectAtIndex:indexPath.row];
    ProductGuideTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductGuideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        cell.headingLabel.text=categoryHeading;
    }
    else if (indexPath.row==1) {
        [cell.subCategoryCollectionView reloadData];
    }
    else if (indexPath.row==2) {
        [cell displayProductName:[[guideDetailDataArray objectAtIndex:cellIndex] postName]];
    }
    else if (indexPath.row==3) {
        [cell displayProductTagline:[[guideDetailDataArray objectAtIndex:cellIndex] tagline]];
    }
    else if (indexPath.row==4) {
        [cell displayProductShortDescription:[[guideDetailDataArray objectAtIndex:cellIndex] shortDescription]];
    }
    else if (indexPath.row==5) {
        cell.productGuideWebView.scrollView.scrollEnabled = NO;
        cell.productGuideWebView.scrollView.bounces = NO;
        [cell.productGuideWebView loadHTMLString:[[guideDetailDataArray objectAtIndex:cellIndex] postContent] baseURL: nil];
    }
    else if (indexPath.row==6) {
        [cell displayProductBottomHeadingData:[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"productGuideText"),[[[guideDetailDataArray objectAtIndex:cellIndex] postName] uppercaseString]]];
    }
    else if (indexPath.row==7) {
        [cell.productCollectionView reloadData];
    }
    return cell;
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];
    NSString *padding = @"document.body.style.padding='1px 1px 1px 1px'";
    [webView stringByEvaluatingJavaScriptFromString:padding];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [myDelegate stopIndicator];
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    [alert addButton:NSLocalizedText(@"alertOk") actionBlock:^(void) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert showWarning:nil title:NSLocalizedText(@"alertTitle") subTitle:NSLocalizedText(@"somethingWrongMessage")  closeButtonTitle:nil duration:0.0f];
}
#pragma mark - end

#pragma mark - Collection view datasource methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (categoryServiceCalled) {
        if (view.tag==10) {
            return productGuideCategoryArray.count;
        }
    }
    if (isServiceCalled) {
    if (view.tag==20) {
        return guideDetailDataArray.count;
    }
    else {
        return 3;
    }
    }
    return 0;
}

- (ProductGuideCollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cv.tag==10) {
        ProductGuideCollectionViewCell *categoryCell = [cv dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
        [categoryCell displayCategoryData:[[productGuideCategoryArray objectAtIndex:indexPath.item]categoryName] selectedIndex:categoryIndex currentIndex:(int)indexPath.item];
        return categoryCell;
    }
    else if (cv.tag==20) {
         ProductGuideCollectionViewCell *subCategoryColelctionCell = [cv dequeueReusableCellWithReuseIdentifier:@"subCategoryColelctionCell" forIndexPath:indexPath];
        [subCategoryColelctionCell displaySubCategoryData:[[guideDetailDataArray objectAtIndex:indexPath.item] postName] productImage:[[guideDetailDataArray objectAtIndex:indexPath.item] postImage] selectedIndex:cellIndex currentIndex:(int)indexPath.item];
        return subCategoryColelctionCell;
    }
    else  {
         ProductGuideCollectionViewCell *productCollectionCell = [cv dequeueReusableCellWithReuseIdentifier:@"productCollectionCell" forIndexPath:indexPath];
        
        return productCollectionCell;
    }
//    [productCell displayProductListData:[productListDataArray objectAtIndex:indexPath.row] exchangeRates:[UserDefaultManager getValue:@"ExchangeRates"]];
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    //You may want to create a divider to scale the size by the way.
//    float picDimension = ([[UIScreen mainScreen] bounds].size.width-20) / 2.0;
//    return CGSizeMake(picDimension-5, picDimension+105);
//}

- (void)collectionView:(UICollectionView *)cv didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (cv.tag==10) {
        
        NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:categoryIndex inSection:0];
        ProductGuideCollectionViewCell *tempCategoryCell = (ProductGuideCollectionViewCell *)[cv cellForItemAtIndexPath:tempIndex];
        tempCategoryCell.categoryLabel.textColor=[UIColor blackColor];
        
        ProductGuideCollectionViewCell *categoryCell = (ProductGuideCollectionViewCell *)[cv cellForItemAtIndexPath:indexPath];
        categoryHeading=[[productGuideCategoryArray objectAtIndex:indexPath.item]categoryDescription];
        categoryIndex=(int)indexPath.item;
          categoryCell.categoryLabel.textColor=[UIColor colorWithRed:182.0/255.0 green:37.0/255.0 blue:70.0/255.0 alpha:1.0];
        [myDelegate showIndicator];
        [self getProductGuideCategoryDetials:[[productGuideCategoryArray objectAtIndex:indexPath.item]categoryId]];
    }
    else if (cv.tag==20) {
        cellIndex=(int)indexPath.item;
        [_productGuideTableView reloadData];
    }
    else {
        
    }
    //StoryBoard navigation
//    ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
//    obj.selectedProductId=[[[productListDataArray objectAtIndex:indexPath.row] productId] intValue];
//    [self.navigationController pushViewController:obj animated:YES];
    
}
#pragma mark - end
@end
