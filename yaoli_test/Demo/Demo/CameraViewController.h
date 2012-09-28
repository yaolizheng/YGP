//
//  CameraViewController.h
//  Demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
#import <CoreLocation/CoreLocation.h>
#include <CoreMotion/CoreMotion.h>
#import <CoreFoundation/CoreFoundation.h>

@interface CameraViewController : UIViewController

@property (strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *tag;
@property (retain, nonatomic) CLLocationManager *locManager;
@property (retain, nonatomic) CMMotionManager *motionManager;
@end
