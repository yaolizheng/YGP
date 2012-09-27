//
//  ViewController.h
//  Demo
//
//  Created by Yaoli Zheng on 9/26/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) CLLocationManager *locManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
