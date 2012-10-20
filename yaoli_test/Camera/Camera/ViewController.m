//
//  ViewController.m
//  Camera
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize captureManager;
@synthesize scanningLabel;
//@synthesize tag;
@synthesize motionManager;
@synthesize locationManager;
@synthesize angle;
@synthesize coordinate;
@synthesize count;
@synthesize name;
@synthesize oldPitch;
@synthesize deviceOrientation;
@synthesize fix;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    fix = false;
	[[self captureManager] addVideoInput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
    //[[[self captureManager] previewLayer] setFrame:CGRectMake(0, 0, 480, 300)];

	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    oldPitch = 0.0;
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 250, 30)];
    [self setScanningLabel:tempLabel];
    
	[scanningLabel setBackgroundColor:[UIColor clearColor]];
	[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[scanningLabel setTextColor:[UIColor whiteColor]];
	[scanningLabel setText:@"Scanning..."];
	[[self view] addSubview:scanningLabel];
    //scanningLabel.tag = 100;
    
    [[captureManager captureSession] startRunning];
    
    coordinate = [NSMutableArray array];
    name = [NSMutableArray array];
    angle = [NSMutableArray array];
    [coordinate addObject:[[CLLocation alloc] initWithLatitude: +37.7831 longitude: -122.4661]];
    [coordinate addObject:[[CLLocation alloc] initWithLatitude: +37.7820 longitude: -122.4505]];
    [name addObject: @"BOA1"];
    [name addObject: @"BOA2"];
    
    
    count = [coordinate count];
    
    for(int i = 0; i < count; i++) {
        UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
        //UILabel *tag;
        //[self setTag:tempLabel];
        [tag setBackgroundColor:[UIColor whiteColor]];
        [tag setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
        [tag setTextColor:[UIColor blackColor]];
        [tag setText:[name objectAtIndex:i]];
        [tag setHidden:YES];
        tag.tag = i + 1;
        [[self view] addSubview:tag];
        
    }
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];     
    
    /*UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
    //UILabel *tag;
    //[self setTag:tempLabel];
    [tag setBackgroundColor:[UIColor whiteColor]];
    [tag setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
    [tag setTextColor:[UIColor blackColor]];
    [tag setText:@"BOA"];
    [tag setHidden:NO];
    [[self view] addSubview:tag];
    tag.tag = 1;
    
    UILabel *tag2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
    //UILabel *tag;
    //[self setTag:tempLabel];
    [tag2 setBackgroundColor:[UIColor whiteColor]];
    [tag2 setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
    [tag2 setTextColor:[UIColor blackColor]];
    [tag2 setText:@"TAG2,10"];
    [tag2 setHidden:NO];
    [[self view] addSubview:tag2];
    tag2.tag = 2;*/

	[[captureManager captureSession] startRunning];
    
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100;
    locationManager.headingFilter = 0.5;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
    if ([motionManager isDeviceMotionAvailable]) {
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                           withHandler: ^(CMDeviceMotion *motion, NSError *error)
         {
             /*CMRotationRate rotate = motion.rotationRate;
             CMAcceleration acc = motion.userAcceleration;
             CMAcceleration gravity = motion.gravity;
             CMAttitude *attitude = motion.attitude;
             CMRotationMatrix rm = motionManager.deviceMotion.attitude.rotationMatrix;
             double header = M_PI + atan2(rm.m22, rm.m12);
             header = header * 180 / M_PI;
             //float yaw = (float)(attitude.yaw * 57.29577951f);
             float yaw = (float)(attitude.yaw * 180.0f / M_PI);
             //int positionIn360 = yaw;
             //if (positionIn360 < 0) {
             //    positionIn360 = 360 + positionIn360;
             //}
             int positionIn360 = header;
             [scanningLabel setText:[NSString stringWithFormat:@"Yaw: %.0f  Pos360: %d", yaw, positionIn360]];
             [self setPostion:tagAngle1 withPostion:positionIn360 withTag:tag];
             [self setPostion:tagAngle2 withPostion:positionIn360 withTag:tag2];*/
             /*CMAttitude *attitude = motion.attitude;
             CMRotationRate rotate = motion.rotationRate;
             double z = rotate.z;
             double pitch = attitude.pitch;
             NSString *head = [NSString stringWithFormat:@"d: %f", fabs(oldPitch - pitch)];
             //NSString *head = [NSString stringWithFormat:@"z: %f", z];
             [scanningLabel setText:head];
             //scanningLabel.transform = CGAffineTransformMakeRotation(z);
             if(fabs(oldPitch - pitch) > (M_PI * 1.0 / 180.0)) {
             if(pitch >= oldPitch )
                 scanningLabel.transform = CGAffineTransformMakeRotation(pitch - M_PI);
             else
                 scanningLabel.transform = CGAffineTransformMakeRotation(-pitch);
             oldPitch = pitch;
             }*/
             /*for(int i = 0; i < count; i ++) {
                 if(pitch >= oldPitch)
                     [self getLabelFromArrayAtIndex:i + 1].transform = CGAffineTransformMakeRotation(pitch - M_PI);
                 else
                     [self getLabelFromArrayAtIndex:i + 1].transform = CGAffineTransformMakeRotation(-pitch);
             }*/
             
         }];
        
    }
}

-(UILabel *)getLabelFromArrayAtIndex:(NSInteger)index{
    
    //Here, we are accessing the current view's subviews and looping through them
    for (UIView *v in self.view.subviews){
        
        //We are asking if the loop's current view (v) is a UILabel
        if ([v isKindOfClass:[UILabel class]]){
            
            //We know it's a label, now see if it has the correct tag (index)
            if (v.tag ==  index){
                
                //if so, return the UIView, cast as a UILabel
                return (UILabel *)v;
            }
        }
    }
    return nil;
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	// Get the current device angle
	float xx = -[acceleration x];
	float yy = [acceleration y];
	float angle = atan2(yy, xx);
	
	// Add 1.5 to the angle to keep the label constantly horizontal to the viewer.
	
    if(fix == false) {
	[scanningLabel setText: [NSString stringWithFormat:@"an: %f", angle ]];
    
 
        [scanningLabel setTransform:CGAffineTransformMakeRotation(angle+1.5)];}
    /*for(int i  = 0; i < count; i++) {
        [[self getLabelFromArrayAtIndex:i + 1] setTransform:CGAffineTransformMakeRotation(angle+1.5)];
        
    }*/
	// Read my blog for more details on the angles. It should be obvious that you
	// could fire a custom shouldAutorotateToInterfaceOrientation-event here.
	if(angle >= -2.25 && angle <= -0.25)
	{
       /* if(angle >= -1.7 && angle <= -1.3)
            fix = false;
        else
            fix = true;*/
		if(deviceOrientation != UIInterfaceOrientationPortrait)
		{
			deviceOrientation = UIInterfaceOrientationPortrait;
            if(angle >= -1.55 && angle <= -1.45) {
                
                self.view.transform = CGAffineTransformIdentity;
                //CGAffineTransform transform = CGAffineTransformMakeRotation(-M_PI/2.0f);
                //self.view.transform = transform;
                self.view.bounds = CGRectMake(0.0, 0.0, 320, 480);
                [scanningLabel setText:[NSString stringWithFormat:@" %f", self.view.bounds.size.width]];
                [[[self captureManager] previewLayer] setFrame:CGRectMake(0, 0, 320, 480)];
                [[self captureManager] previewLayer].orientation = UIInterfaceOrientationPortrait;
            }
			//[scanningLabel setText:@"UIInterfaceOrientationPortrait"];
		}
	}
	else if(angle >= -1.75 && angle <= 0.75)
	{
        /*if(angle >= -0.2 && angle <= 0.2)
            fix = false;
        else
            fix = true;*/
        if(angle >= -0.05 && angle <= 0.05) {
            
            self.view.transform = CGAffineTransformIdentity;
            //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2.0f);
            //self.view.transform = transform;
            self.view.bounds = CGRectMake(0.0, 0.0, 480, 320);
            [scanningLabel setText:[NSString stringWithFormat:@" %f", self.view.bounds.size.width]];
            [[[self captureManager] previewLayer] setFrame:CGRectMake(0, 0, 480, 320)];
            [[self captureManager] previewLayer].orientation = UIInterfaceOrientationLandscapeRight;
        }
        if(deviceOrientation != UIInterfaceOrientationLandscapeRight)
		{
			deviceOrientation = UIInterfaceOrientationLandscapeRight;
            
			//[scanningLabel setText:@"UIInterfaceOrientationLandscapeRight"];
        }
	}
	else if(angle >= 0.75 && angle <= 2.25)
	{
		if(deviceOrientation != UIInterfaceOrientationPortraitUpsideDown)
		{
			deviceOrientation = UIInterfaceOrientationPortraitUpsideDown;
			//[scanningLabel setText:@"UIInterfaceOrientationPortraitUpsideDown"];
		}
	}
	else if(angle <= -2.25 || angle >= 2.25)
	{
		if(deviceOrientation != UIInterfaceOrientationLandscapeLeft)
		{
			deviceOrientation = UIInterfaceOrientationLandscapeLeft;
			//[scanningLabel setText:@"UIInterfaceOrientationLandscapeLeft"];
		}
	}
}




-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    for(int i = 0; i < count; i++) {
        CLLocation *target = [coordinate objectAtIndex:i];
        [angle addObject: [NSNumber numberWithDouble: [self getAngleToEast:target withCurrentLocation:newLocation]]];
    }
    //CLLocation *target = [[CLLocation alloc] initWithLatitude: +37.7831 longitude: -122.4661];
    //CLLocation *target = [[CLLocation alloc] initWithLatitude: +37.7820 longitude: -122.4505];
    //self.angle = [self getAngleToEast:target withCurrentLocation:newLocation];
    //NSString *head = [NSString stringWithFormat:@"heading: %f", angle];
    //[scanningLabel setText:head];
}

- (void)locationManager:(CLLocationManager *) manager didUpdateHeading:(CLHeading *) newHeading {
    if (newHeading.headingAccuracy > 0) {
        
        
        CLLocationDirection theHeading = newHeading.trueHeading;
        NSString *head = [NSString stringWithFormat:@"heading: %d", (int)theHeading];
        int eastHeading = ((int)theHeading + 270) % 360;
        //[scanningLabel setText: head];
        //[scanningLabel setText: [NSString stringWithFormat:@"e: %d", eastHeading]];
        if(fix == false) {
            for(int i  = 0; i < count; i++) {
                [self setPostion:(360.0 - [[angle objectAtIndex:i] doubleValue]) withPostion:eastHeading withTag: [self getLabelFromArrayAtIndex:i + 1]];
            
            }
        }
        
        //[self setPostion:(360.0 - self.angle) withPostion:(int)theHeading withTag: [self getLabelFromArrayAtIndex:1]];
        //[self setPostion:tagAngle2 withPostion:(int)theHeading withTag: [self getLabelFromArrayAtIndex:2]];
        
        /*[headingLabel setText:head];
        [headingLabel setTextColor:[UIColor orangeColor]];
        [headingLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin];
        
        [[self view] addSubview: headingLabel];*/
    }
}

- (double)getAngleToEast: (CLLocation *)target withCurrentLocation: (CLLocation *)current{
    double dist = [current getDistanceFrom:target] / 1000;
    if(target.coordinate.latitude >= current.coordinate.latitude && target.coordinate.longitude >= current.coordinate.longitude) {
        double dif =  (target.coordinate.latitude - current.coordinate.latitude) * 111;
        double angle = asin(dif / dist);
    
        return angle * 180.0 / M_PI;
    }
    else if(target.coordinate.latitude >= current.coordinate.latitude && target.coordinate.longitude <= current.coordinate.longitude) {
        double dif =  (target.coordinate.latitude - current.coordinate.latitude) * 111;
        double angle = asin(dif / dist);
        
        return 180.0 - angle * 180.0 / M_PI;
    }
    else if(target.coordinate.latitude <= current.coordinate.latitude && target.coordinate.longitude <= current.coordinate.longitude) {
        double dif =  (current.coordinate.latitude - target.coordinate.latitude) * 111;
        double angle = asin(dif / dist);
        
        return 180.0 + angle * 180.0 / M_PI;
    }
    else {
        double dif =  (current.coordinate.latitude - target.coordinate.latitude) * 111;
        double angle = asin(dif / dist);
        
        return 360.0 - angle * 180.0 / M_PI;
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setPostion: (float)tagAngle withPostion: (int)positionIn360 withTag:(UILabel *)tag{
    //NSString *head = [NSString stringWithFormat:@"cahnge: %d", tag.tag];
    //[scanningLabel setText: head];
    if(tagAngle >= 23.0f && tagAngle <= 337.0f) {
        if(tagAngle + 23.0f >= positionIn360 && tagAngle - 23.0f <= positionIn360) {
            [self setAngleInCamera:tagAngle withPostion:positionIn360 withTag:tag];
        }
        else
            [tag setHidden:YES];
    }
    else if(tagAngle < 23.0f && tagAngle >= 0.0f) {
        
        if(tagAngle + 23.0f >= positionIn360 || (360.0f + tagAngle - 23.0f) <= positionIn360) {
            
            [self setAngleInCamera:tagAngle withPostion:positionIn360 withTag:tag];                 }
        else
            [tag setHidden:YES];
    }
    else if(tagAngle < 360.0f && tagAngle >= 337.0f) {
        
        if((tagAngle + 23.0f - 360.0f) >= positionIn360 || tagAngle - 23.0f <= positionIn360) {
            [self setAngleInCamera:tagAngle withPostion:positionIn360 withTag:tag];
        }
        else
            [tag setHidden:YES];
    }
}

- (void)setAngleInCamera: (float)tagAngle withPostion: (int)positionIn360 withTag:(UILabel *)tag{
    if(tagAngle - positionIn360 >= 0) {
        float offset = (float)tanf((tagAngle - (float)positionIn360) * M_PI / 180.0f) * 240.0f / (float)tanf(23.0f * M_PI / 180.0f);
        tag.center = CGPointMake(240 + offset, 160);
        //[tag setFrame:CGRectMake(240 + offset, 160, 50, 30)];
        //[tag setText:[NSString stringWithFormat:@"O: %.2f", tanf(23.0f * M_PI / 180.0f)]];
        [tag setHidden:NO];
    }
    else {
        float offset = (float)tanf(((float)positionIn360 - tagAngle) * M_PI / 180.0f) * 240.0f / (float)tanf(23.0f * M_PI / 180.0f);
        //[tag setFrame:CGRectMake(240 - offset, 160, 50, 30)];
        tag.center = CGPointMake(240 - offset, 160);
        [tag setHidden:NO];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
     
    ///}*/

    /*if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2.0f);
        self.view.transform = transform;
        self.view.center = CGPointMake(160, 240);        //[[self captureManager] previewLayer].orientation = UIInterfaceOrientationPortrait;
    }*/
//return interfaceOrientation == UIInterfaceOrientationPortrait;*/
    return NO;
}


@end
