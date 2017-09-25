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

@interface FilterViewController () {
@private
    NSMutableArray *filterDataArray, *selectedSecArray;
    NSString *filterType, *filterTypeValue;
    BOOL isServiceCalled;
}
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end

@implementation FilterViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    filterDataArray = [NSMutableArray new];
    selectedSecArray = [NSMutableArray new];
    isServiceCalled=false;
    self.navigationController.navigationBarHidden=false;
    self.title=NSLocalizedText(@"filterTitle");
    //remove extra lines from table view
    _filterTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [myDelegate showIndicator];
    [self performSelector:@selector(getFilterData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)cancelButtonAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)applyfilterButtonAction:(id)sender {
    //    productListViewObj.sortingType = sortingType;
    //    productListViewObj.sortBasis = sortBasis;
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - end

#pragma mark - Webservice
- (void)getFilterData {
    SortFilterModel *sortList = [SortFilterModel sharedUser];
    sortList.requestValues=[NSString stringWithFormat:@"%@",NSLocalizedText(@"filterCountry")];
    [sortList getFilterServiceData:^(SortFilterModel *sortData) {
        isServiceCalled=true;
        filterDataArray = [sortData.filterArray mutableCopy];
        if (filterDataArray.count > 0) {
            for (int i=0; i<[filterDataArray count]; i++) {
                [selectedSecArray addObject:[NSNumber numberWithBool:NO]];
            }
        }
        [_filterTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (filterDataArray.count>0) {
        return filterDataArray.count+1;
    }
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if ([[selectedSecArray objectAtIndex:section-1] boolValue]) {
            return [[filterDataArray objectAtIndex:section-1] filterOptionsArray].count;
        }
        else {
            return 0;
        }
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    else if (section == 1) {
        return 50.0;
    }
    else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 130;
    }
    else  {
        return 50;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *simpleTableIdentifier;
    if (indexPath.section == 0) {
        simpleTableIdentifier=@"rangeSlider";
    }
    else if (indexPath.section == 1) {
        simpleTableIdentifier=@"countryFilter";
    }
    FilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.section == 0) {
      //  [cell displaySlider];
    }
    else if (indexPath.section==1) {
        [cell displayCountry:[[[filterDataArray objectAtIndex:indexPath.section-1] filterOptionsArray] objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,50)];
        sectionView.tag=section;
        sectionView.backgroundColor = [UIColor whiteColor];
    
        //country label
        UILabel *countryLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 5,tableView.frame.size.width-30, 40)];
        countryLabel.font = [UIFont montserratRegularWithSize:16];
        countryLabel.textAlignment=NSTextAlignmentLeft;
        countryLabel.text=[[filterDataArray objectAtIndex:section-1] filterLabelValue];
        [sectionView addSubview:countryLabel];
        
        UIImageView *arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(tableView.frame.size.width - 25, (sectionView.frame.size.height/2) - 6, 12, 12)];
        arrowView.image = [UIImage imageNamed:@"arrowGrey"];
        [sectionView addSubview:arrowView];
        if ([[selectedSecArray objectAtIndex:section-1] boolValue]) {
            arrowView.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
        else {
            arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
        }
        
        UILabel *seperatorLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 49,tableView.frame.size.width, 0.8)];
        seperatorLabel.backgroundColor=[UIColor lightGrayColor];
        [sectionView addSubview:seperatorLabel];
        
        //Add UITapGestureRecognizer to SectionView
        UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
        [sectionView addGestureRecognizer:headerTapped];
        return  sectionView;
    }
    else {
        UIView* sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,0)];
        return  sectionView;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
    } else {
    }
}
#pragma mark - end

#pragma mark - Table header gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.section == 1) {
        if (indexPath.row < filterDataArray.count) {
            BOOL collapsed  = [[selectedSecArray objectAtIndex:indexPath.section-1] boolValue];
            for (int i=0; i<[filterDataArray count]; i++) {
                if (indexPath.section-1 == i) {
                    [selectedSecArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:!collapsed]];
                } else {
                }
            }
            [_filterTableView reloadSections:[NSIndexSet indexSetWithIndex:gestureRecognizer.view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }
}
#pragma mark - end
@end
