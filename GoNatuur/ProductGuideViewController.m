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
#import "SearchViewController.h"

@interface ProductGuideViewController ()<UIGestureRecognizerDelegate> {
    @private
    NSArray *productGuideMenuArray;
    NSMutableArray *productGuideCategoryArray;
    NSMutableArray *guideDetailDataArray, *staticProductsArray;
    NSString *categoryHeading;
    BOOL isServiceCalled, categoryServiceCalled, isProductServiceCalled;
    int cellIndex, categoryIndex;
}
@property (weak, nonatomic) IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *productGuideTableView;
@property (weak, nonatomic) IBOutlet UILabel *noRecordLabel;
@end

@implementation ProductGuideViewController
@synthesize selectedPostId;
@synthesize screenType;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     productGuideMenuArray = @[@"headingCell", @"subCategoryCell", @"nameCell", @"taglineCell", @"shortDescriptionCell", @"webViewCell", @"productHeadingCell", @"productCell"];
    productGuideCategoryArray=[[NSMutableArray alloc]init];
    guideDetailDataArray=[[NSMutableArray alloc]init];
    staticProductsArray=[[NSMutableArray alloc]init];
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
    isServiceCalled=false;
    categoryServiceCalled=false;
    isProductServiceCalled=false;
    isProductServiceCalled=false;
    _noRecordLabel.hidden=true;
    _noRecordLabel.text=NSLocalizedText(@"norecord");
    if ([screenType isEqualToString:@"searchGuide"]) {
        [self addLeftBarButtonWithImage:true];
        [myDelegate showIndicator];
        [self getProductGuideCategoryDetials:selectedPostId];
        _categoryCollectionView.translatesAutoresizingMaskIntoConstraints=YES;
        _categoryCollectionView.frame=CGRectMake(0, 105, _categoryCollectionView.frame.size.width, 0);
    }
    else {
        [self addLeftBarButtonWithImage:false];
        [myDelegate showIndicator];
        [self performSelector:@selector(getProductGuideCategoryListData) withObject:nil afterDelay:.1];
    }
}

- (void)serachButtonAction:(id)sender {
    myDelegate.selectedCategoryIndex=-1;
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * searchView=[sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    searchView.screenType=@"Product Guide";
    [self.navigationController pushViewController:searchView animated:YES];
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
        //set collection view items in centre
        [_categoryCollectionView setContentInset:UIEdgeInsetsMake(0, ([[UIScreen mainScreen] bounds].size.width)/2-53-(53*(productGuideCategoryArray.count-1))+2, 0, 0)];
        [_categoryCollectionView reloadData];
        [self getProductGuideCategoryDetials:[[productGuideCategoryArray objectAtIndex:0]categoryId]];
    } onfailure:^(NSError *error) {
    }];
}

- (void)getProductGuideCategoryDetials:(NSString *)categoryId {
    ProductGuideDataModel *categoryList = [ProductGuideDataModel sharedUser];
    categoryList.categoryId=categoryId;
    categoryList.isSearch=@"No";
    categoryList.screenType=screenType;
    [categoryList getProductGuideDetailsCategoryData:^(ProductGuideDataModel *userData)  {
        isServiceCalled=true;
        if (userData.postDataArray.count!=0) {
             _productGuideTableView.hidden=false;
            _noRecordLabel.hidden=true;
            guideDetailDataArray=[userData.postDataArray mutableCopy];
            [_productGuideTableView reloadData];
            [self getStaticProductListing];
        }
        else {
            [myDelegate stopIndicator];
            _productGuideTableView.hidden=true;
            _noRecordLabel.hidden=false;
        }
    } onfailure:^(NSError *error) {
    }];
}

- (void)getStaticProductListing {
    SearchDataModel *searchData = [SearchDataModel sharedUser];
    searchData.serachKeyword=[[guideDetailDataArray objectAtIndex:cellIndex] postName];
    searchData.searchPageCount=@"3";
    [searchData getSearchProductListing:^(SearchDataModel *userData)  {
        [myDelegate stopIndicator];
        isProductServiceCalled=true;
        if (userData.searchProductListArray.count!=0) {
            staticProductsArray=[userData.searchProductListArray mutableCopy];
    }
    } onfailure:^(NSError *error) {
    
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
            return [DynamicHeightWidth getDynamicLabelHeight:[[guideDetailDataArray objectAtIndex:cellIndex] postContent] font:[UIFont montserratLightWithSize:14] widthValue:[[UIScreen mainScreen] bounds].size.width-50];
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
        if (staticProductsArray.count==0) {
            return 40;
        }
        else {
       return 200;
        }
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
        if (guideDetailDataArray.count==1) {
            cell.leftArrow.hidden=YES;
            cell.rightArrow.hidden=YES;
        }
        //The setup code (in viewDidLoad in your view controller)
        cell.leftArrow.userInteractionEnabled=YES;
        cell.rightArrow.userInteractionEnabled=YES;
        UITapGestureRecognizer *leftTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(leftTapAction:)];
        [cell.leftArrow addGestureRecognizer:leftTap];
        
        UITapGestureRecognizer *rightTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(rightTapAction:)];
        [cell.rightArrow addGestureRecognizer:rightTap];
        
        [cell.subCategoryCollectionView setContentInset:UIEdgeInsetsMake(0, ([[UIScreen mainScreen] bounds].size.width-60)/2-40-(40*(guideDetailDataArray.count-1)), 0, 0)];
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
        [cell.productGuideWebView setBorder:cell.productGuideWebView color:[UIColor whiteColor] borderWidth:2.0];
        [cell.productGuideWebView loadHTMLString:[[guideDetailDataArray objectAtIndex:cellIndex] postContent] baseURL: nil];
    }
    else if (indexPath.row==6) {
        [cell displayProductBottomHeadingData:[NSString stringWithFormat:@"%@ %@",NSLocalizedText(@"productGuideText"),[[[guideDetailDataArray objectAtIndex:cellIndex] postName] uppercaseString]]];
    }
    else if (indexPath.row==7) {
        if (staticProductsArray.count!=0) {
            cell.noRecordLabel.hidden=false;
            [cell.productCollectionView reloadData];
        }
        else {
             cell.noRecordLabel.hidden=false;
            cell.noRecordLabel.text=NSLocalizedText(@"noSimilarProducts");
        }
    }
    return cell;
}
#pragma mark - end

#pragma mark - Hangle arrow tag gesture
//The event handling method
- (void)leftTapAction:(UITapGestureRecognizer *)recognizer {
    if (cellIndex>0) {
        cellIndex=cellIndex-1;
        [self scrollMediaCollectionViewAtIndex];
    }
}

- (void)rightTapAction:(UITapGestureRecognizer *)recognizer {
    if (cellIndex<(int)guideDetailDataArray.count-1) {
        cellIndex=cellIndex+1;
        [self scrollMediaCollectionViewAtIndex];
    }
}
//scroll collection view to seleted index
- (void)scrollMediaCollectionViewAtIndex {
    ProductGuideTableViewCell *tempCell = [_productGuideTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [tempCell.subCategoryCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:cellIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    [self getStaticProductListing];
    [_productGuideTableView reloadData];
    [tempCell.subCategoryCollectionView reloadData];
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
    }
    if (isProductServiceCalled) {
        if (view.tag==30) {
            return staticProductsArray.count;
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
        [productCollectionCell.contentView setBorder:productCollectionCell.contentView color:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] borderWidth:1.0];
        [productCollectionCell.contentView setCornerRadius:5.0];
        [productCollectionCell displayProductListData:[staticProductsArray objectAtIndex:indexPath.row]];
       
        return productCollectionCell;
    }
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
        [self getStaticProductListing];
        [_productGuideTableView reloadData];
    }
    else {
        
    }
    //StoryBoard navigation
//    ProductDetailViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetailViewController"];
//    obj.selectedProductId=[[[productListDataArray objectAtIndex:indexPath.row] productId] intValue];
//    [self.navigationController pushViewController:obj animated:YES];
    
}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)cv layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    if (cv.tag==10) {
//    CGFloat totalCellWidth = 53 * productGuideCategoryArray.count;
//    CGFloat totalSpacingWidth = (53 * productGuideCategoryArray.count-1)+2;
//    CGFloat leftInset = ([[UIScreen mainScreen] bounds].size.width - (totalCellWidth + totalSpacingWidth)) / 2;
//   // CGFloat rightInset = leftInset;
//    UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, leftInset, 0, 0);
//    return sectionInset;
//    }
//    else {
//        UIEdgeInsets sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        return sectionInset;
//    }
//}
#pragma mark - end
@end
