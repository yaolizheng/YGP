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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setCaptureManager:[[CaptureSessionManager alloc] init]];
    
	[[self captureManager] addVideoInput];
    
	[[self captureManager] addVideoPreviewLayer];
	CGRect layerRect = [[[self view] layer] bounds];
	[[[self captureManager] previewLayer] setBounds:layerRect];
	//[[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
    //                                                              CGRectGetMidY(layerRect))];
    [[[self captureManager] previewLayer] setFrame:CGRectMake(0, 0, 480, 300)];

	[[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
    
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 250, 30)];
    [self setScanningLabel:tempLabel];
    
	[scanningLabel setBackgroundColor:[UIColor clearColor]];
	[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[scanningLabel setTextColor:[UIColor whiteColor]];
	[scanningLabel setText:@"Scanning..."];
	[[self view] addSubview:scanningLabel];
    
	[[captureManager captureSession] startRunning];
    
    UILabel *tag = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
    //UILabel *tag;
    //[self setTag:tempLabel];
	[tag setBackgroundColor:[UIColor whiteColor]];
	[tag setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[tag setTextColor:[UIColor blackColor]];
    [tag setText:@"TAG1,340"];
    [tag setHidden:NO];
    [tag setHidden:YES];
	[[self view] addSubview:tag];
    
    UILabel *tag2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 50, 30)];
    //UILabel *tag;
    //[self setTag:tempLabel];
	[tag2 setBackgroundColor:[UIColor whiteColor]];
	[tag2 setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
	[tag2 setTextColor:[UIColor blackColor]];
    [tag2 setText:@"TAG2,10"];
    [tag2 setHidden:NO];
    [tag2 setHidden:YES];
	[[self view] addSubview:tag2];
    //float tagPosition = 15.0f;
    
	[[captureManager captureSession] startRunning];
    
    float tagAngle1 = 340.0f;
    float tagAngle2 = 10.0f;
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
             //float yaw = (float)(attitude.yaw * 57.29577951f);
             float yaw = (float)(attitude.yaw * 180.0f / M_PI);
             int positionIn360 = yaw;
             if (positionIn360 < 0) {
                 positionIn360 = 360 + positionIn360;
             }
             [scanningLabel setText:[NSString stringWithFormat:@"Yaw: %.0f  Pos360: %d", yaw, positionIn360]];
             [self setPostion:tagAngle1 withPostion:positionIn360 withTag:tag];
             [self setPostion:tagAngle2 withPostion:positionIn360 withTag:tag2];
         }];
        
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setPostion: (float)tagAngle withPostion: (int)positionIn360 withTag:(UILabel *)tag{
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
        [tag setFrame:CGRectMake(240 - offset, 250, 50, 30)];
        //[tag setText:[NSString stringWithFormat:@"O: %.2f", tanf(23.0f * M_PI / 180.0f)]];
        [tag setHidden:NO];
    }
    else {
        float offset = (float)tanf(((float)positionIn360 - tagAngle) * M_PI / 180.0f) * 240.0f / (float)tanf(23.0f * M_PI / 180.0f);
        [tag setFrame:CGRectMake(240 + offset, 250, 50, 30)];
        [tag setHidden:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    /*if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
     
    }*/
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [[self captureManager] previewLayer].orientation = UIInterfaceOrientationLandscapeLeft;
    }
    if(interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [[self captureManager] previewLayer].orientation = UIInterfaceOrientationLandscapeRight;
    }
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}


@end
