//
//  CameraViewController.m
//  Demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "CameraViewController.h"
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * M_PI*180.0f)
@interface CameraViewController ()

@end

@implementation CameraViewController

@synthesize captureManager;
@synthesize label;
@synthesize tag;
@synthesize locManager;
@synthesize motionManager;

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
    [label setText:@"inital..."];
    
	[[self view] addSubview:label];
    
    
    tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
    [self setTag:tempLabel];
    
	[tag setBackgroundColor:[UIColor whiteColor]];
	[tag setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[tag setTextColor:[UIColor blackColor]];
    [tag setText:@"TAG"];
    [tag setHidden:NO];
	[[self view] addSubview:tag];
    
    float tagPosition = 15.0f;
    
	[[captureManager captureSession] startRunning];
    

    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    if ([motionManager isDeviceMotionAvailable]) {
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                           withHandler: ^(CMDeviceMotion *motion, NSError *error)
         {
             CMRotationRate rotate = motion.rotationRate;
             CMAcceleration acc = motion.userAcceleration;
             CMAcceleration gravity = motion.gravity;
             CMAttitude *attitude = motion.attitude;
             float yaw = (float)(attitude.yaw * 57.29577951f);
             
             int positionIn360 = yaw;
             if (positionIn360 < 0) {
                 positionIn360 = 360 + positionIn360;
             }
             [label setText:[NSString stringWithFormat:@"Yaw: %.0f  PositionIn360: %d", yaw, positionIn360]];
             if(yaw  > tagPosition + 150.0f||yaw < tagPosition - 100.0f)
                 [tag setHidden:YES];
             else {
                 [tag setFrame:CGRectMake(yaw + 160.0f - tagPosition - 50.0f, 250, 50, 30)];
                 [tag setHidden:NO];
             }
         
         }];
        
    }
    
}



-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    //NSString *string = [[NSString alloc] initWithFormat:@"I am at %.2f, %.2f", longitude, latitude];
    //[label setText:string];
}


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
