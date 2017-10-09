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

@interface FilterViewController ()<GoNatuurPickerViewDelegate> {
@private
    NSMutableArray *filterDataArray, *filterValueDataArray;
    NSString *filterType, *filterTypeValue;
    NSString *requestValuesString, *slectedAttributeId, *slectedAttributeCode;
    GoNatuurPickerView *gNPickerViewObj;
    int selectedRowIndex;
    NSMutableDictionary *tempDataDict;
}
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end

@implementation FilterViewController
@synthesize productListViewObj;
@synthesize selectedPickerValueIndex;
@synthesize filterProductId;
@synthesize selectedPickerIndexDict;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    filterDataArray = [NSMutableArray new];
    tempDataDict=[[NSMutableDictionary alloc]init];
    slectedAttributeId = @"";
    slectedAttributeCode = @"";
    //remove extra lines from table view
    _filterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    tempDataDict=[selectedPickerIndexDict mutableCopy];
    [self addCustomPickerView];
    [self setRequestAttributes];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"filterTitle");
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
- (void)setRequestAttributes {
    //Set additional filter attribute code
    if ([[[UserDefaultManager getValue:@"AdditionalSortsFilters"] allKeys] containsObject:[NSString stringWithFormat:@"%d",filterProductId]] ) {
        requestValuesString = [[[[UserDefaultManager getValue:@"AdditionalSortsFilters"] objectForKey:[NSString stringWithFormat:@"%d",filterProductId]] objectForKey:@"additional_filter"] componentsJoinedByString:@","];
        NSLog(@"requestValuesString = %@",requestValuesString);
        [myDelegate showIndicator];
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
    [self dismissView];
}

- (IBAction)applyfilterButtonAction:(id)sender {
    [self dismissView];
}
#pragma mark - end

#pragma mark - Dismiss View
- (void)dismissView {
    NSIndexPath *tempIndex=[NSIndexPath indexPathForRow:0 inSection:0];
    if ([slectedAttributeCode isEqualToString:@""]) {
        productListViewObj.sortFilterRequest = 1;
    } else {
        productListViewObj.sortFilterRequest = 2;
    }
    FilterTableViewCell *cell = (FilterTableViewCell *)[_filterTableView cellForRowAtIndexPath:tempIndex];
    productListViewObj.filterDictionary = @{@"maxPrice":cell.maxPriceValue,@"minPrice":cell.minPriceValue, @"attributeId":slectedAttributeId, @"attributedCode":slectedAttributeCode};
    DLog(@"productListViewObj.filterDictionary = %@",productListViewObj.filterDictionary);
    productListViewObj.isSortFilter = true;
    productListViewObj.selectedPickerValueDict=[tempDataDict mutableCopy];
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
        }
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
    selectedPickerValueIndex=[[tempDataDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row-1]] intValue];
    [gNPickerViewObj showPickerView:filterValueDataArray selectedIndex:selectedPickerValueIndex option:1 isCancelDelegate:false isFilterScreen:true];
}
}
#pragma mark - end
@end
