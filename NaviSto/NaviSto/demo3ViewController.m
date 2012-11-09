//
//  demo3ViewController.m
//  NaviSto
//
//  Created by Guangrui Su on 11/4/12.
//  Copyright (c) 2012 Guangrui Su. All rights reserved.
//

#import "demo3ViewController.h"
#import "PlaceOfInterest.h"
#import "demo3AppDelegate.h"
#import "WebService.h"

@interface demo3ViewController ()

@end

@implementation demo3ViewController

@synthesize locManager;

- (void)viewDidLoad
{
    [super viewDidLoad];
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];
        // Do any additional setup after loading the view, typically from a nib.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    if(longitude != 0.0 && latitude != 0.0) {
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    app.location = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
        NSLog(@"Response: %f", longitude);
        NSLog(@"Response: %f", latitude);
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.center = CGPointMake(160, 240);
        spinner.hidesWhenStopped = YES;
        [self.view addSubview:spinner];
        [spinner startAnimating];
        NSLog(@"spiner");
        [WebService getLocation:[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease] withType:@"all"];
        [spinner stopAnimating];
        [locManager stopUpdatingLocation];
        [locManager release];
        locManager = nil;
    }

}


- (void)dealloc {
    [locManager stopUpdatingLocation];
	[locManager release];
	locManager = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [locManager stopUpdatingLocation];
	[locManager release];
	locManager = nil;
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
