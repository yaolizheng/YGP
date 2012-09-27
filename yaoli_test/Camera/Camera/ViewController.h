//
//  ViewController.h
//  Camera
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaptureSessionManager.h"
@interface ViewController : UIViewController

@property (strong) CaptureSessionManager *captureManager;
@property (nonatomic, strong) UILabel *scanningLabel;
@end
