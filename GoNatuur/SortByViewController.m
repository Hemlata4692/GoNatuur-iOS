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
    NSString *sortingType, *sortBasis;
}
@property (weak, nonatomic) IBOutlet UITableView *sortByTableView;

@end

@implementation SortByViewController
@synthesize productListViewObj;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    sortingArray = [NSMutableArray new];
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"SortByTitle");
    //remove extra lines from table view
    _sortByTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [myDelegate showIndicator];
    [self performSelector:@selector(getSortListData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - end

#pragma mark TableView DataSource Methods
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
        simpleTableIdentifier=@"AscCell";
    } else {
        simpleTableIdentifier=@"DescCell";
    }
    SortByCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[SortByCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    //Show default selection
    if (indexPath.section == 0 && indexPath.row == 0) {
        sortBasis = DESC;
        cell.ascLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
    }
    SortFilterModel *sortData = [sortingArray objectAtIndex:0];
    sortingType = sortData.attributeValue;
    NSLog(@"basis = %@, type = %@",sortBasis,sortingType);
    //Display cell data
    sortData = [sortingArray objectAtIndex:indexPath.section];
    [cell displaySortData:_sortByTableView.frame.size sortData:sortData];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortByCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0) {
        sortBasis = DESC;
        cell.descLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        cell.ascLabel.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    } else {
        sortBasis = ASC;
        cell.ascLabel.textColor=[UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0];
        cell.descLabel.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    }
    SortFilterModel *sortData = [sortingArray objectAtIndex:indexPath.section];
    sortingType = sortData.attributeValue;
    NSLog(@"basis = %@, type = %@",sortBasis,sortingType);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortByCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.ascLabel.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
    cell.descLabel.textColor=[UIColor colorWithRed:26/255.0 green:26/255.0 blue:26/255.0 alpha:1.0];
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

#pragma mark - Get product list service
- (void)getSortListData {
    SortFilterModel *sortList = [SortFilterModel sharedUser];
    sortList.requestValues=[NSString stringWithFormat:@"%@,%@",NSLocalizedText(@"sortName"),NSLocalizedText(@"sortPrice")];
    [sortList getSortData:^(SortFilterModel *sortData) {
        sortingArray = [sortData.sortArray mutableCopy];
        [_sortByTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end
@end
