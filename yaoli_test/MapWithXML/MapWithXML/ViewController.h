//
//  ViewController.h
//  MapWithXML
//
//  Created by Yaoli Zheng on 10/11/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController


@property (retain, nonatomic) CLLocationManager *locManager;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@end
