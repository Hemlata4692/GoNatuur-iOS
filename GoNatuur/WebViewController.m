//
//  WebViewController.m
//  GoNatuur
//
//  Created by Ranosys-Mac on 19/08/17.
//  Copyright © 2017 Hemlata Khajanchi. All rights reserved.
//

#import "WebViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "AddressAnnotation.h"

@interface WebViewController ()<MKMapViewDelegate> {
    AddressAnnotation *addAnnotation;
}
@property (weak, nonatomic) IBOutlet UIWebView *productDetailWebView;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *locationHeading;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@end

@implementation WebViewController
@synthesize navigationTitle;
@synthesize productDetaiData;
@synthesize isLocation;
@synthesize locationArray;

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.title=navigationTitle;
    self.navigationController.navigationBarHidden=false;
    [self addLeftBarButtonWithImage:true];
    _noDataLabel.text=NSLocalizedText(@"nodata");
    _locationHeading.text=NSLocalizedText(@"locationDetails");
    if ([isLocation isEqualToString:@"Yes"]) {
        _productDetailWebView.hidden=YES;
        NSDictionary *tempDict=[locationArray objectAtIndex:0];
        if (locationArray.count==0 || [tempDict objectForKey:@"location_lat"]==nil || [tempDict objectForKey:@"location_long"] ==nil || [[tempDict objectForKey:@"location_lat"]isEqualToString:@""] || [[tempDict objectForKey:@"location_long"]isEqualToString:@""]) {
            _noDataLabel.hidden=NO;
            _locationView.hidden=YES;
        }
        else {
            _noDataLabel.hidden=YES;
            _locationView.hidden=NO;
            [_mapView setCornerRadius:2.0];
            _addressTextView.text=[tempDict objectForKey:@"location_detail"];
            [self addMapPoints:tempDict];
        }
    }
    else {
        _locationView.hidden=YES;
        _productDetailWebView.backgroundColor = [UIColor colorWithRed:253.0/255.0 green:244.0/255.0 blue:246.0/255.0 alpha:1.0];
        _productDetailWebView.opaque=NO;
        
        if ([productDetaiData isEqualToString:@""] || productDetaiData==nil) {
            _noDataLabel.hidden=NO;
            _productDetailWebView.hidden=YES;
        }
        else {
            _noDataLabel.hidden=YES;
            [myDelegate showIndicator];
            if ([navigationTitle isEqualToString:NSLocalizedText(@"Where to buy")]) {
                [_productDetailWebView loadHTMLString:[NSString stringWithFormat:@"<div style='text-align:left; font-size:16px;font-family:Montserrat-Light;color:#000000;link:#B62546'>%@", productDetaiData] baseURL: nil];
            }
            else {
                [_productDetailWebView loadHTMLString:[NSString stringWithFormat:@"<div style='text-align:justify; font-size:16px;font-family:Montserrat-Light;color:#000000;link:#B62546;'>%@", productDetaiData] baseURL: nil];
            }
        }
    }
//    @"<html><body style='font-family: Montserrat-Light; color:'#000000' link='#B62546' text-align:'left' font-size:16px'>%@</body></html>";

}

- (void)addMapPoints:(NSDictionary *)locationDict {
    [_mapView setDelegate:self];
    _mapView.showsUserLocation=NO;
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta =0.05;     // 0.0 is min value u van provide for zooming
    span.longitudeDelta=0.05;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [[locationDict objectForKey:@"location_lat"] floatValue];
    coordinate.longitude = [[locationDict objectForKey:@"location_long"] floatValue];
    region.span=span;
    region.center =coordinate;
    addAnnotation = [[AddressAnnotation alloc] initWithTitle:[locationDict objectForKey:@"location_title"] andCoordinate:coordinate];
    [_mapView addAnnotation:addAnnotation];
    addAnnotation.myPinColor=MKPinAnnotationColorRed;
    [_mapView setRegion:region animated:TRUE];
    [_mapView regionThatFits:region];
}
#pragma mark - end

#pragma mark - Webview delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [myDelegate stopIndicator];
    NSString *padding = @"document.body.style.padding='5px 5px 5px 5px'";
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
