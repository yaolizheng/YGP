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
#import "demo3DetailedController.h"

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
    newRegion.span.latitudeDelta = 0.01;
    newRegion.span.longitudeDelta = 0.01;
    [self.mapView setRegion:newRegion animated:YES];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.delegate = self;
    [self reloadPin];
    
    /*CLLocationCoordinate2D coordinate;
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
        [self.mapView addAnnotation:annotation2];    }*/
    
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

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[[annotation title] lowercaseString] isEqualToString:@"your current location"]) {
        return nil;
    }
    NSArray *t = [[annotation title] componentsSeparatedByString:@"|"];
    NSString *title = [t objectAtIndex:0];
    int ID = [[t objectAtIndex:1] intValue];
    ((MKUserLocation *)annotation).title = title;
    title = [title lowercaseString];
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
  
    if ([title rangeOfString:@"citibank"].location != NSNotFound) {
        if ([title rangeOfString:@"atm"].location != NSNotFound) {
            UIImage *image = [self imageWithImage:[UIImage imageNamed:@"AtmIcon.gif"] scaledToSize:CGSizeMake(30, 30)];
            annView.image =  image;
        }
        else {
            
            UIImage *image = [self imageWithImage:[UIImage imageNamed:@"CitiIcon.gif"] scaledToSize:CGSizeMake(30, 30)];
            
            annView.image = image;//[UIImage imageNamed:@"CitiIcon.gif"] ;
        }
        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[self imageWithImage:[UIImage imageNamed:@"CitiButton.png"] scaledToSize:CGSizeMake(23, 23)]];
        [leftCAV addSubview : imageView];
        UILabel *FirstLine = [[UILabel alloc] init];
        [FirstLine setText: @"line1"];
        [leftCAV addSubview : FirstLine];
        UILabel *SecondLine = [[UILabel alloc] init];
        [SecondLine setText: @"line2"];
        [leftCAV addSubview : SecondLine];
        annView.leftCalloutAccessoryView = leftCAV;
        
    }
    else if ([title rangeOfString:@"ATM"].location != NSNotFound) {
        annView.image = [ UIImage imageNamed:@"AtmIcon.gif" ];
    }
    else
        annView.image = [ UIImage imageNamed:@"BankButton.gif" ];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    infoButton.tag = ID;
    [infoButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = infoButton;
    annView.canShowCallout = YES;
    return annView;
}

-(void)btnClick:(id)sender
{
    UIButton* btn = (UIButton *) sender;
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    app.ID = btn.tag;
    demo3DetailedController *detail = [[demo3DetailedController alloc]init];
    //detail.navigationItem.title = @"Location Information";
    [self.navigationController pushViewController:detail animated:YES];
}

-(void)reloadPin {
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    float longitude = app.location.coordinate.longitude;
    float latitude = app.location.coordinate.latitude;
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    NSArray *oldAnnotations=[self.mapView annotations];
    [self.mapView removeAnnotations:oldAnnotations];
    MKPointAnnotation *annotation1 = [[MKPointAnnotation new] init];
    
    [annotation1 setCoordinate:coordinate];
    [annotation1 setTitle:@"Your current location"];
    //[self.mapView removeAnnotation:self.mapView.annotations];
    [self.mapView addAnnotation:annotation1];
    for(int i = 0; i < [app.places count]; i++) {
        Place *p = [app.places objectAtIndex:i];
        MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
        
        [annotation2 setCoordinate:p.location.coordinate];
        NSString *title = [NSString stringWithFormat:@"%@%@%d", p.name, @"|", i];
        [annotation2 setTitle: title];
        [self.mapView addAnnotation:annotation2]; }
}

- (void)segmentAction:(id)sender{
    switch ([sender selectedSegmentIndex]){
        case 0:{
            demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
            [WebService getLocation:app.location withType:@"all"];
            [self reloadPin];
        }
            break;
            
        case 1:{
            demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
            [WebService getLocation:app.location withType:@"atm"];
            [self reloadPin];

        }
            break;
        case 2:{
            demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
            [WebService getLocation:app.location withType:@"bank"];
            [self reloadPin];
        }
            break;
        default:
            break;
    }
}

@end
