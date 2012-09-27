//
//  CaptureSessionManager.h
//  Camera
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
@interface CaptureSessionManager : NSObject


@property (strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong) AVCaptureSession *captureSession;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;

@end
