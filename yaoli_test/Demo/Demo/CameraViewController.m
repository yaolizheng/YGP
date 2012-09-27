//
//  CameraViewController.m
//  Demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize captureManager;
@synthesize label;
@synthesize locManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];
    
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    
	[[self captureManager] addVideoInput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 30)];
    [self setLabel:tempLabel];
    
	[label setBackgroundColor:[UIColor clearColor]];
	[label setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[label setTextColor:[UIColor whiteColor]];
	
	[[self view] addSubview:label];
    
	[[captureManager captureSession] startRunning];
    
    
	// Do any additional setup after loading the view.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    NSString *string = [[NSString alloc] initWithFormat:@"I am at %.2f, %.2f", longitude, latitude];
    [label setText:string];}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
