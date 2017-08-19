//
//  ProductDetailViewController.m
//  GoNatuur
//
//  Created by Ranosys on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductDataModel.h"
#import "DynamicHeightWidth.h"
#import "ProductDetailCollectionViewCell.h"
#import "ProductDetailTableViewCell.h"

@interface ProductDetailViewController () {
@private
    ProductDataModel *productDetailModelData;
    float productDetailCellHeight;
    BOOL isServiceCalled;
}
@property (strong, nonatomic) IBOutlet UITableView *productDetailTableView;
@end

@implementation ProductDetailViewController
@synthesize selectedProductId;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    isServiceCalled=false;
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"Product");
    [self addLeftBarButtonWithImage:true];
    productDetailCellHeight=0.0;
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductDetailData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - Table view datasource/delegates
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (isServiceCalled) {
        return 8;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productName font:[UIFont montserratMediumWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80]+24;
    }
    else if (indexPath.row==1) {
        return [DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productShortDescription font:[UIFont montserratMediumWithSize:11] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
    }
    else if (indexPath.row==2) {
        return 15;
    }
    else if (indexPath.row==3) {
        return 290;
    }
    else if (indexPath.row==4) {
        return 80;
    }
    else if (indexPath.row==5) {
        return 75;
    }
    else if (indexPath.row==6) {
        float tempHeight=[DynamicHeightWidth getDynamicLabelHeight:@"Shipping is free if the total purchase is above USD$100." font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        tempHeight+=[DynamicHeightWidth getDynamicLabelHeight:@"Products can be returned within 30 days of purchase, subject to the following conditions." font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
        return tempHeight+10;
    }
    else if (indexPath.row==7) {
        return 50;
    }
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailTableViewCell *cell;
    
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailNameCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailNameCell"];
        }
    }
    else if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailDescriptionCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailDescriptionCell"];
        }
    }
    else if (indexPath.row==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailRatingCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailRatingCell"];
        }
    }
    else if (indexPath.row==3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailImageCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailImageCell"];
        }
    }
    else if (indexPath.row==4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailMediaCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailMediaCell"];
        }
    }
    else if (indexPath.row==5) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailPriceCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailPriceCell"];
        }
    }
    else if (indexPath.row==6) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailInfoCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailInfoCell"];
        }
    }
    else if (indexPath.row==7) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"productDetailAddCartButtonCell"];
        if (cell == nil){
            cell = [[ProductDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productDetailAddCartButtonCell"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}
#pragma mark - end

#pragma mark - Webservice
//Get product detail
- (void)getProductDetailData {
    ProductDataModel *productData = [ProductDataModel sharedUser];
    productData.productId=[NSNumber numberWithInt:selectedProductId];
    [productData getProductDetailOnSuccess:^(ProductDataModel *productDetailData)  {
        productDetailModelData=productDetailData;
        isServiceCalled=true;
        [_productDetailTableView reloadData];
    } onfailure:^(NSError *error) {
        
    }];
}
#pragma mark - end

- (void)productDetailHandler {
    productDetailCellHeight=24.0;
    float tempHeight=[DynamicHeightWidth getDynamicLabelHeight:productDetailModelData.productName font:[UIFont montserratMediumWithSize:20] widthValue:[[UIScreen mainScreen] bounds].size.width-80];
    productDetailCellHeight=productDetailCellHeight+tempHeight;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
