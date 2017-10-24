//
//  FilterViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterTableViewCell.h"
#import "SortFilterModel.h"
#import "GoNatuurPickerView.h"
#import "DashboardDataModel.h"

@interface FilterViewController ()<GoNatuurPickerViewDelegate> {
@private
    NSMutableArray *filterDataArray, *filterValueDataArray, *selctedFilterDataArray;
    NSString *isFilterApplied;
    NSString *requestValuesString;
    GoNatuurPickerView *gNPickerViewObj;
    int selectedRowIndex;
    NSMutableDictionary *tempDataDict, *filterDataDictionary;
    NSUInteger selectedFilterIndex;
}
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UIButton *applyButtonOutlet;

@end

@implementation FilterViewController
@synthesize productListViewObj;
@synthesize selectedPickerValueIndex;
@synthesize filterProductId;
@synthesize selectedPickerIndexDict;
@synthesize isProductList;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    filterDataArray = [NSMutableArray new];
    filterDataDictionary=[[NSMutableDictionary alloc]init];
    selctedFilterDataArray=[[NSMutableArray alloc]init];
    //remove extra lines from table view
    _filterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tempDataDict=[selectedPickerIndexDict mutableCopy];
    isFilterApplied=@"0";
    [self addCustomPickerView];
    [myDelegate showIndicator];
    [self performSelector:@selector(getProductListData) withObject:nil afterDelay:.1];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"filterTitle");
    [_cancelButtonOutlet setTitle:NSLocalizedText(@"cancelButtonTitle") forState:UIControlStateNormal];
    [_applyButtonOutlet setTitle:NSLocalizedText(@"applyButtonTitle") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    //Bring front view picker view
    [self.view bringSubviewToFront:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - Get additional sort values
//Get product list service
- (void)getProductListData {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    productList.pageSize=[NSNumber numberWithInt:1];
    productList.currentPage=[NSNumber numberWithInt:1];
    productList.productSortingType = NSLocalizedText(@"sortPrice");
    productList.productSortingValue = DESC;
    productList.sortFilterRequestParameter=5;
    [productList getProductListService:^(DashboardDataModel *productData)  {
        [UserDefaultManager setValue:[[productData.productDataArray objectAtIndex:0] productPrice] key:@"maximumPrice"];
        [self setRequestAttributes];
    } onfailure:^(NSError *error) {
    }];
}

- (void)setRequestAttributes {
    //Set additional filter attribute code
    if ([[[UserDefaultManager getValue:@"AdditionalSortsFilters"] allKeys] containsObject:[NSString stringWithFormat:@"%d",filterProductId]] ) {
        requestValuesString = [[[[UserDefaultManager getValue:@"AdditionalSortsFilters"] objectForKey:[NSString stringWithFormat:@"%d",filterProductId]] objectForKey:@"additional_filter"] componentsJoinedByString:@","];
        NSLog(@"requestValuesString = %@",requestValuesString);
        [self performSelector:@selector(getFilterData) withObject:nil afterDelay:.1];
    } else {
        [_filterTableView reloadData];
    }
}
#pragma mark - end

#pragma mark - Custom picker view
- (void)addCustomPickerView {
     //Set initial index of picker view and initialized picker view
    gNPickerViewObj=[[GoNatuurPickerView alloc] initWithFrame:[[UIScreen mainScreen] bounds] delegate:self pickerHeight:230];
    [self.view addSubview:gNPickerViewObj.goNatuurPickerViewObj];
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)cancelButtonAction:(id)sender {
     [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)applyfilterButtonAction:(id)sender {
    [self dismissView];
}
#pragma mark - end

#pragma mark - Dismiss View
- (void)dismissView {
    NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:0 inSection:0];
    if ([isFilterApplied isEqualToString:@"1"]) {
        productListViewObj.isFilterApplied=true;
        _redeemListObj.isFilterApplied=true;
    }
    FilterTableViewCell *cell = (FilterTableViewCell *)[_filterTableView cellForRowAtIndexPath:tempIndex];
    productListViewObj.filterDictionary = @{@"maxPrice":cell.maxPriceValue,@"minPrice":cell.minPriceValue};
    productListViewObj.filterValueDataArray = [selctedFilterDataArray mutableCopy];
    _redeemListObj.filterDictionary = @{@"maxPrice":cell.maxPriceValue,@"minPrice":cell.minPriceValue};
    _redeemListObj.filterValueDataArray = [selctedFilterDataArray mutableCopy];
    DLog(@"productListViewObj.filterDictionary = %@ %@",productListViewObj.filterDictionary,productListViewObj.filterValueDataArray);
    productListViewObj.isSortFilter = true;
    productListViewObj.selectedPickerValueDict=[tempDataDict mutableCopy];
    _redeemListObj.isSortFilter = true;
    _redeemListObj.selectedPickerValueDict=[tempDataDict mutableCopy];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getFilterData {
    SortFilterModel *sortList = [SortFilterModel sharedUser];
    sortList.requestValues=requestValuesString;
    [sortList getFilterServiceData:^(SortFilterModel *sortData) {
        filterDataArray = [sortData.filterArray mutableCopy];
        [_filterTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Custom picker delegate method
- (void)goNatuurPickerViewDelegateActionIndex:(int)tempSelectedIndex option:(int)option {
    if (option==1) {
        if (selectedPickerValueIndex!=tempSelectedIndex) {
            NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:selectedRowIndex inSection:0];
            FilterTableViewCell *tempCountryCell = (FilterTableViewCell *)[_filterTableView cellForRowAtIndexPath:tempIndex];
            tempCountryCell.selectedFilterLabel.text=[filterValueDataArray objectAtIndex:tempSelectedIndex];
            [tempDataDict setObject:[NSString stringWithFormat:@"%d",tempSelectedIndex] forKey:[NSString stringWithFormat:@"%ld",tempIndex.row-1]];
            if (![[[[[filterDataArray objectAtIndex:tempIndex.row-1] filterOptionsArray] objectAtIndex:tempSelectedIndex] filterCountryValue] isEqualToString:@""]) {
            NSDictionary *tempDict = @{@"field":[[filterDataArray objectAtIndex:tempIndex.row-1] filterAttributeCode],@"value":[[[[filterDataArray objectAtIndex:tempIndex.row-1] filterOptionsArray] objectAtIndex:tempSelectedIndex] filterCountryValue], @"condition_type":@"eq"};
            NSMutableArray *tempArray=[NSMutableArray new];
            [tempArray addObject:tempDict];
            [filterDataDictionary setObject:tempArray forKey:@"filters"];
            
            if ([self checkIFValueExists:[tempDict objectForKey:@"field"]]) {
                [selctedFilterDataArray replaceObjectAtIndex:selectedFilterIndex withObject:[filterDataDictionary mutableCopy]];
            }
            else {
            [selctedFilterDataArray addObject:[filterDataDictionary mutableCopy]];
            }
            }
            isFilterApplied=@"1";
        }
    }
}

- (BOOL)checkIFValueExists:(NSString *)fieldValue {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"filters.field contains[cd] %@", fieldValue];
    NSArray *filteredarray = [selctedFilterDataArray filteredArrayUsingPredicate:predicate];
    if (filteredarray.count>0) {
        NSUInteger index = [selctedFilterDataArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [predicate evaluateWithObject:obj];
        }];
        selectedFilterIndex=index;
        DLog(@"%lu",(unsigned long)selectedFilterIndex);
        return YES;
    }
    else {
        return false;
    }
}
#pragma mark - end

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (filterDataArray.count>0) {
        return filterDataArray.count+1;
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 130;
    }
    else  {
        return 70;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.row == 0) {
        simpleTableIdentifier=@"rangeSlider";
    }
    else {
        simpleTableIdentifier=@"countryFilter";
    }
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 0) {
        [cell displaySlider:[UserDefaultManager getValue:@"maximumPrice"]];
    }
    else  {
        [cell displayCountry:[filterDataArray objectAtIndex:indexPath.row-1]];
         selectedPickerValueIndex=[[tempDataDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row-1]] intValue];
        if ([[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:selectedPickerValueIndex] filterCountry] isEqualToString:@""] || [[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:selectedPickerValueIndex] filterCountry] isEqualToString:@" "]) {
             cell.selectedFilterLabel.text=NSLocalizedText(@"All");
        }
        else {
        cell.selectedFilterLabel.text=[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:selectedPickerValueIndex] filterCountry];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=0) {
    selectedRowIndex=(int)indexPath.row ;
    filterValueDataArray= [[NSMutableArray alloc]init];
    for (int i=0; i<[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] count]; i++) {
        if ([[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:i] filterCountry] isEqualToString:@""] || [[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:i] filterCountry] isEqualToString:@" "]) {
            [filterValueDataArray addObject:NSLocalizedText(@"All")];
        }
        else {
            [filterValueDataArray addObject:[[[[filterDataArray objectAtIndex:indexPath.row-1] filterOptionsArray] objectAtIndex:i] filterCountry]];
        }
    }
    selectedPickerValueIndex=[[tempDataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]] intValue];
    [gNPickerViewObj showPickerView:filterValueDataArray selectedIndex:selectedPickerValueIndex option:1 isCancelDelegate:false isFilterScreen:true];
}
}
#pragma mark - end
@end
