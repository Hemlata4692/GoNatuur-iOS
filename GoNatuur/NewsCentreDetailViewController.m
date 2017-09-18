//
//  NewsCentreDetailViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 12/09/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "NewsCentreDetailViewController.h"
#import "NewsCentreDetailTableViewCell.h"
#import "DashboardDataModel.h"
#import "DynamicHeightWidth.h"

@interface NewsCentreDetailViewController () {
@private
    NSMutableArray *newsDetailArray;
    NSArray *cellIdentifierArray;
    NSDictionary *newsDetailDict;
}
@property (weak, nonatomic) IBOutlet UITableView *newsDetailTableView;

@end

@implementation NewsCentreDetailViewController
@synthesize newsPostId;
@synthesize navigationTitle;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    newsDetailArray=[[NSMutableArray alloc]init];
    newsDetailDict=[[NSDictionary alloc]init];
    [myDelegate showIndicator];
    [self performSelector:@selector(getNewsDetailData) withObject:nil afterDelay:.1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=false;
    self.title=navigationTitle;
    [self addLeftBarButtonWithImage:true ];
    cellIdentifierArray = @[@"imageCell", @"dateCell", @"categoriesCell", @"tagsCell", @"byCell",@"contentCell"];
}
#pragma mark - end

#pragma mark - Webservice
//Get product list service
- (void)getNewsDetailData {
    DashboardDataModel *productList = [DashboardDataModel sharedUser];
    productList.productId=newsPostId;
    [productList getNewsDetailDataService:^(DashboardDataModel *productData)  {
        newsDetailDict=[productData.productDataArray objectAtIndex:0];
        [_newsDetailTableView reloadData];
        [myDelegate stopIndicator];
    } onfailure:^(NSError *error) {
    }];
}
#pragma mark - end

#pragma mark - Table view data source and delgate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        return 180;
    }
    else if (indexPath.row==1) {
        if ([[newsDetailDict objectForKey:@"publish_time"] isEqualToString:@""] || [newsDetailDict objectForKey:@"publish_time"]==nil) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[newsDetailDict objectForKey:@"publish_time"] font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-68]+2;
        }
    }
    else if (indexPath.row==2) {
        if ([[newsDetailDict objectForKey:@"categories"] isEqualToString:@""] || [newsDetailDict objectForKey:@"categories"]==nil) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[newsDetailDict objectForKey:@"categories"] font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-113]+2;
        }
    }
    else if (indexPath.row==3) {
        if ([[newsDetailDict objectForKey:@"tags"] isEqualToString:@""] || [newsDetailDict objectForKey:@"tags"]==nil) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[newsDetailDict objectForKey:@"tags"] font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-65]+2;
        }
    }
    else if (indexPath.row==4) {
        if ([[newsDetailDict objectForKey:@"author_name"] isEqualToString:@""] || [newsDetailDict objectForKey:@"author_name"]==nil) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[newsDetailDict objectForKey:@"author_name"] font:[UIFont montserratRegularWithSize:15] widthValue:[[UIScreen mainScreen] bounds].size.width-55]+2;
        }
    }
    else if (indexPath.row==5) {
        if ([[newsDetailDict objectForKey:@"content"] isEqualToString:@""] || [newsDetailDict objectForKey:@"content"]==nil) {
            return 0;
        }
        else {
            return [DynamicHeightWidth getDynamicLabelHeight:[newsDetailDict objectForKey:@"content"] font:[UIFont montserratLightWithSize:12] widthValue:[[UIScreen mainScreen] bounds].size.width-8];
        }
    }
    else {
        return 25;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [cellIdentifierArray objectAtIndex:indexPath.row];
    NewsCentreDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil){
        cell = [[NewsCentreDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row==0) {
        [cell displayNewsTitleImage:[newsDetailDict objectForKey:@"featured_image"] title:[newsDetailDict objectForKey:@"title"]];
    }
    else if (indexPath.row==1) {
        [cell displayNewsDate:[newsDetailDict objectForKey:@"publish_time"]];
    }
    else if (indexPath.row==2) {
        [cell displayNewsCategory:[newsDetailDict objectForKey:@"categories"]];
    }
    else if (indexPath.row==3) {
        [cell displayNewsTags:[newsDetailDict objectForKey:@"tags"]];
    }
    else if (indexPath.row==4) {
        [cell displayNewsAuthor:[newsDetailDict objectForKey:@"author_name"]];
    }
    else if (indexPath.row==5) {
        [cell displayWebView:[newsDetailDict objectForKey:@"content"]];
        [cell.contentWebView loadHTMLString:[NSString stringWithFormat:@"<html><body style='font-family: Montserrat-Light; color:'#000000' link='#B62546' text-align:'left' font-size:16px'>%@</body></html>", [newsDetailDict objectForKey:@"content"]] baseURL: nil];
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

@end
