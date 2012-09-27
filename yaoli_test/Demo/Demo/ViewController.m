//
//  ViewController.m
//  Demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize mapView;
@synthesize locManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    self.mapView.mapType = MKMapTypeStandard;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;
    newRegion.center.longitude = longitude;
    newRegion.span.latitudeDelta = 0.004;
    newRegion.span.longitudeDelta = 0.004;
    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation new] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"I am here"];
    [self.mapView removeAnnotation:self.mapView.annotations];
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:newRegion animated:YES];
}



- (void)viewDidUnload
{
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

@end
