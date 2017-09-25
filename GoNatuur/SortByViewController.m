//
//  SortByViewController.m
//  GoNatuur
//
//  Created by Monika on 21/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SortByViewController.h"
#import "SortByCell.h"
#import "SortFilterModel.h"

@interface SortByViewController ()
{
    NSMutableArray *sortingArray;
    SortFilterModel *sortDataModel;
    NSUInteger index;
    BOOL isFirstTime;
    NSString *requestValuesString;
}
@property (weak, nonatomic) IBOutlet UITableView *sortByTableView;

@end

@implementation SortByViewController
@synthesize productListViewObj,sortingType,sortBasis;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    isFirstTime  = true;
    sortingArray = [NSMutableArray new];
    sortDataModel = [SortFilterModel new];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"SortByTitle");
    NSLog(@"basis = %@, type = %@",sortBasis,sortingType);
    //remove extra lines from table view
    _sortByTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _productId = @"2";
    [self getAdditionalId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark - Get additional sort values
- (void)getAdditionalId {
    requestValuesString = [NSString stringWithFormat:@"%@,%@",NSLocalizedText(@"sortName"),NSLocalizedText(@"sortPrice")];
    NSLog(@"product Id = %@",_productId);
    NSArray *sortArray = @[ @{@"Id":@"1",
                              @"value":@"brand",
                              },
                            @{@"Id":@"2",
                              @"value":@"rating",
                              },
                            @{@"Id":@"3",
                              @"value":@"brand",
                              },
                            @{@"Id":@"4",
                              @"value":@"rating",
                              },
                            ];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Id == %@", _productId];
    NSArray *filteredarray = [sortArray filteredArrayUsingPredicate:predicate];
    if (filteredarray.count>0) {
        index = [sortArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [predicate evaluateWithObject:obj];
        }];
    }
    NSDictionary *dict = [sortArray objectAtIndex:index];
    NSLog(@"value = %@",dict[@"value"]);
    if (dict[@"value"] != nil) {
       requestValuesString = [NSString stringWithFormat:@"%@,%@",requestValuesString,dict[@"value"]];
    }
    NSLog(@"requestValuesString = %@",requestValuesString);
    [myDelegate showIndicator];
    [self performSelector:@selector(getSortListData) withObject:nil afterDelay:.1];
}
#pragma mark - end

#pragma mark TableView methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sortingArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.row == 0) {
        simpleTableIdentifier=@"DescCell";
    } else {
        simpleTableIdentifier=@"AscCell";
    }
    SortByCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SortByCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //Display default seleced value
    if (isFirstTime) {
        isFirstTime  = false;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"attributeValue == %@", sortingType];
        NSArray *filteredarray = [sortingArray filteredArrayUsingPredicate:predicate];
        if (filteredarray.count>0) {
            index = [sortingArray indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
                return [predicate evaluateWithObject:obj];
            }];
        }
        //Change particular value of array
        sortDataModel = [sortingArray objectAtIndex:index];
        sortDataModel.sortBasis = sortBasis;
        sortDataModel.selectedValue = 1;
        [sortingArray setObject:sortDataModel atIndexedSubscript:index];
    }
    sortDataModel = [sortingArray objectAtIndex:indexPath.section];
    [cell displaySortData:_sortByTableView.frame.size sortData:sortDataModel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Deselect all values
    for (int i=0;i<sortingArray.count;i++) {
        SortFilterModel *tempModel = [sortingArray objectAtIndex:i];
        tempModel.selectedValue = 0;
        [sortingArray setObject:tempModel atIndexedSubscript:i];
    }
    sortDataModel = [sortingArray objectAtIndex:indexPath.section];
    sortingType = sortDataModel.attributeValue;
    //Change particular value of array
    if (indexPath.row == 0) {
        sortBasis = DESC;
        sortDataModel.sortBasis = DESC;
    } else {
        sortBasis = ASC;
        sortDataModel.sortBasis = ASC;
    }
    sortDataModel.selectedValue = 1;
    [sortingArray setObject:sortDataModel atIndexedSubscript:indexPath.section];
    [_sortByTableView reloadData];
    NSLog(@"basis = %@, type = %@",sortBasis,sortingType);
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)applyButtonAction:(id)sender {
    productListViewObj.sortingType = sortingType;
    productListViewObj.sortBasis = sortBasis;
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Get sort list service
- (void)getSortListData {
    SortFilterModel *sortList = [SortFilterModel sharedUser];
    sortList.requestValues=requestValuesString;
    [sortList getSortData:^(SortFilterModel *sortData) {
        sortingArray = [sortData.sortArray mutableCopy];
        [_sortByTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
