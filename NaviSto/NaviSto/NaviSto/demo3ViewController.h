//
//  demo3ViewController.h
//  NaviSto
//
//  Created by Guangrui Su on 11/4/12.
//  Copyright (c) 2012 Guangrui Su. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface demo3ViewController : UIViewController
@property (retain, nonatomic) CLLocationManager *locManager;
//@property (retain, nonatomic) UIActivityIndicatorView *spinner;

@property (retain, nonatomic) IBOutlet UIButton *button1;

@property (retain, nonatomic) IBOutlet UIButton *button2;

-(IBAction) ARAfterLoading:(id)sender;
-(IBAction) MapAfterLoading:(id)sender;

@end
