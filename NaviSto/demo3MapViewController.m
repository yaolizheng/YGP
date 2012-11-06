//
//  demo3MapViewController.m
//  demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "demo3MapViewController.h"
#import "Place.h"
#import "demo3AppDelegate.h"
#import "WebService.h"

@interface demo3MapViewController ()

@end

@implementation demo3MapViewController
@synthesize mapView;
//@synthesize locManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *arr = [NSArray arrayWithObjects:@"All",@"ATM",@"Bank",nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:arr];
    seg.segmentedControlStyle = UISegmentedControlSegmentCenter;
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    /*locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];*/
    
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    float longitude = app.location.coordinate.longitude;
    float latitude = app.location.coordinate.latitude;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;//app.location.coordinate.latitude;
    newRegion.center.longitude = longitude;//app.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.05;
    newRegion.span.longitudeDelta = 0.05;
    [self.mapView setRegion:newRegion animated:YES];
    NSLog(@"aaaa %f", longitude);
    NSLog(@"bbbb %f", latitude);
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    
    MKPointAnnotation *annotation1 = [[MKPointAnnotation new] init];
    [annotation1 setCoordinate:coordinate];
    [annotation1 setTitle:@"Your current location"];
    //[self.mapView removeAnnotation:self.mapView.annotations];
    [self.mapView addAnnotation:annotation1];
    
    NSLog(@"11111");
    for(int i = 0; i < [app.places count]; i++) {
        Place *p = [app.places objectAtIndex:i];
        NSLog(@"%f",p.location.coordinate.latitude);
        NSLog(@"%f",p.location.coordinate.longitude);
        MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
        [annotation2 setCoordinate:p.location.coordinate];
        [annotation2 setTitle:p.name];
        [self.mapView addAnnotation:annotation2];    }
    
}

/*-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    /*NSString *poiNames[] = {@"BoA ATM2",
        @"BoA ATM",
        @"Citibank",
        @"Citibank ATM",
        @"Wells Fargo",
        @"Chase",
        @"Chase",
        @"Wells Fargo"};
	
    CLLocationCoordinate2D poiCoords[] = {{37.780630, -122.466052},
        {37.780630, -122.466052},
        {37.786861, -122.447032},
        {37.776533, -122.461293},
        {37.785836, -122.461073},
        {37.797488, -122.464395},
        {37.795316, -122.478155},
        {37.782676, -122.483373}};
    
    int numPois = sizeof(poiCoords) / sizeof(CLLocationCoordinate2D);
    for (int i = 0; i < numPois; i++) {
        MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
        [annotation2 setCoordinate:poiCoords[i]];
        [annotation2 setTitle:poiNames[i]];
        [self.mapView addAnnotation:annotation2];
    }
    
    
    
}*/



- (void)viewDidUnload
{
    //[locManager stopUpdatingLocation];
	//[locManager release];
	//locManager = nil;
    [self setMapView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    //[locManager stopUpdatingLocation];
	//[locManager release];
	//locManager = nil;
    [mapView release];
    [super dealloc];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *v = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if([[v.annotation title] isEqualToString:@"Your current location"]) {
        v.pinColor = MKPinAnnotationColorGreen;
        
    }
    return v;
}

- (void)segmentAction:(id)sender{
    switch ([sender selectedSegmentIndex]){
        case 0:{
        }
            break;
            
        case 1:{
        }
            break;
        case 2:{
        }
            break;
        default:
            break;
    }
}

@end
