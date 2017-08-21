//
//  SearchViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 03/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchListingViewController.h"
#import "SearchDataModel.h"

@interface SearchViewController () {
@private
    NSMutableArray *searchArray;
    NSString *searchKey;
}
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIImageView *closeImageIcon;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *noResultLabel;
@property (strong, nonatomic) NSTimer * searchTimer;
@end

@implementation SearchViewController

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    searchArray=[[NSMutableArray alloc]init];
    
    [_searchTextField becomeFirstResponder];
    [_searchTextField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    _closeImageIcon.hidden=YES;
    _closeButton.hidden=YES;
    _noResultLabel.hidden=YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=true;
    //add background color to status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:229.0/255.0 blue:233.0/255.0 alpha:1.0];
    [self.view addSubview:statusBarView];
    
    //remove extra lines
    _searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - end

#pragma mark - IBActions
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    _searchTextField.text=@"";
    _closeImageIcon.hidden=YES;
    _closeButton.hidden=YES;
}
#pragma mark - end

#pragma mark - Textfield delegates
// reset the search timer whenever the text field changes
-(void)textFieldDidChange :(UITextField *)textField {
    if (![textField.text isEqualToString:@""]) {
        _closeImageIcon.hidden=NO;
        _closeButton.hidden=NO;
    }
    else {
        _closeImageIcon.hidden=YES;
        _closeButton.hidden=YES;
    }
    // if a timer is already active, prevent it from firing
    if (_searchTimer != nil) {
        [_searchTimer invalidate];
        _searchTimer = nil;
    }
    // reschedule the search: in 1.0 second, call the searchForKeyword: method on the new textfield content
    _searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target: self
                                                  selector: @selector(searchForKeyword:)
                                                  userInfo:_searchTextField.text
                                                   repeats: NO];
}

- (void) searchForKeyword:(NSTimer *)timer {
    // retrieve the keyword from user info
    searchKey = (NSString*)timer.userInfo;
    // perform your search (stubbed here using NSLog)
    DLog(@"Searching for keyword %@", searchKey);
    if (![searchKey isEqualToString:@""]) {
        [self getSerachSuggestionListing:searchKey];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
        SearchListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchListingViewController"];
        obj.searchKeyword=searchKey;
        [self.navigationController pushViewController:obj animated:true];
    }
    return YES;
}
#pragma mark - end

#pragma mark - Webservice
- (void) getSerachSuggestionListing:(NSString *)keyword {
    SearchDataModel *serachData = [SearchDataModel sharedUser];
    serachData.serachKeyword=keyword;
    [serachData getSearchSuggestions:^(SearchDataModel *userData)  {
        if (userData.searchKeywordListingArray.count==0) {
            _noResultLabel.hidden=NO;
            searchArray=[NSMutableArray new];
            [_searchTableView reloadData];
        }
        else {
            _noResultLabel.hidden=YES;
            searchArray=[userData.searchKeywordListingArray mutableCopy];
            [_searchTableView reloadData];
        }
    } onfailure:^(NSError *error) {
        _noResultLabel.hidden=NO;
        _searchTableView.hidden=YES;
    }];
    
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return searchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"searchCell";
    UITableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UILabel *seacrhTextLabel=(UILabel *) [searchCell viewWithTag:1];
    seacrhTextLabel.text=[[searchArray objectAtIndex:indexPath.row] keywordName];
    return searchCell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_searchTextField resignFirstResponder];
    SearchListingViewController *obj = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchListingViewController"];
    obj.searchKeyword=[[searchArray objectAtIndex:indexPath.row] keywordName];
    [self.navigationController pushViewController:obj animated:true];
}
#pragma mark - end

@end
