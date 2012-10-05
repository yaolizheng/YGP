//
//  ViewController.m
//  map
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"
#import "CJSONDeserializer.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize lonLabel;
@synthesize latLabel;
@synthesize locManager;
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];
    NSString *urlAddress=@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&api_key=f3d3c93cac8adde7a46fc984158cd0e6&photo_id=3350763400&secret=2287e11458829fa5";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    //NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
    NSError *error;
    NSString *page = [NSString stringWithContentsOfURL:url
                                                    encoding:NSASCIIStringEncoding error:&error];
    
    page = [page stringByReplacingOccurrencesOfString:@"jsonFlickrApi("
                                         withString:@""];
    page = [page stringByReplacingOccurrencesOfString:@")"
                                           withString:@""];
    NSLog(@"%@", page);
    NSData *jsonData = [page dataUsingEncoding:NSUTF32BigEndianStringEncoding];
    error = nil;
    NSDictionary *items = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
    NSLog(@"total items: %d", [items count]);
    NSLog(@"error: %@", [error localizedDescription]);
    
    NSDictionary *photo = [items objectForKey:@"photo"];
    NSString *id = [photo objectForKey:@"id"];
    self.lonLabel.text = [NSString stringWithFormat: @"ID: %@", id];
    NSString *date = [photo objectForKey:@"dateuploaded"];
    self.latLabel.text = [NSString stringWithFormat: @"Update Date: %@", date];
}

- (void)viewDidUnload
{
    [self setLonLabel:nil];
    [self setLatLabel:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    //self.lonLabel.text = [NSString stringWithFormat:@"longtitude:  %f",longitude];
    //self.latLabel.text = [NSString stringWithFormat:@"latitude:  %f",latitude];
    self.mapView.mapType = MKMapTypeStandard;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;
    newRegion.center.longitude = longitude;
    newRegion.span.latitudeDelta = 0.004;
    newRegion.span.longitudeDelta = 0.004;
    float lo[3];
    float la[3];
    lo[0] = -122.4509;
    lo[1] = -122.4505;
    lo[2] = -122.4513;
    la[0] = 37.7807;
    la[1] = 37.7801;
    la[2] = 37.7812;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation new] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"I am here"];
    //[self.mapView removeAnnotation:self.mapView.annotations];
    int i;
    for(i = 0; i < 3; i++) {
        CLLocationCoordinate2D coordinate2;
        coordinate2.latitude = la[i]	;
        coordinate2.longitude = lo[i];
        MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
        [annotation2 setCoordinate:coordinate2];
        [annotation2 setTitle: [NSString stringWithFormat:@"Bank %d", i]];
        [self.mapView addAnnotation:annotation2];
    }
        //[self.mapView removeAnnotation:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    
    [self.mapView setRegion:newRegion animated:YES];
}

@end
