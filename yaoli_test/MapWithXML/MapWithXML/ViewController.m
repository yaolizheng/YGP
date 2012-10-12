//
//  ViewController.m
//  MapWithXML
//
//  Created by Yaoli Zheng on 10/11/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"
#import "TouchXML.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locManager;
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    locManager = [[CLLocationManager alloc]init];
    locManager.delegate = self;
    locManager.desiredAccuracy = kCLLocationAccuracyBest;
    locManager.distanceFilter = 100;
    [locManager startUpdatingLocation];
    
    /*NSString *urlAddress=@"http://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&api_key=f3d3c93cac8adde7a46fc984158cd0e6&photo_id=3350763400&secret=2287e11458829fa5";
     
     NSURL *url = [NSURL URLWithString:urlAddress];
     //NSURLRequest *requestObj=[NSURLRequest requestWithURL:url];
     NSError *error;
     NSString *page = [NSString stringWithContentsOfURL:url
     encoding:NSASCIIStringEncoding error:&error];
     
     page = [page stringByReplacingOccurrencesOfString:@"jsonFlickrApi("
     withString:@""];
     page = [page stringByReplacingOccurrencesOfString:@")"
     withString:@""];
     NSLog(@"%@", page);
     NSData *jsonData = [page dataUsingEncoding:NSUTF32BigEndianStringEncoding];
     error = nil;
     NSDictionary *items = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
     NSLog(@"total items: %d", [items count]);
     NSLog(@"error: %@", [error localizedDescription]);
     
     NSDictionary *photo = [items objectForKey:@"photo"];
     NSString *id = [photo objectForKey:@"id"];
     NSString *date = [photo objectForKey:@"dateuploaded"];*/
    
}

- (void)viewDidUnload
{
    
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D loc = [newLocation coordinate];
    float longitude = loc.longitude;
    float latitude = loc.latitude;
    //self.lonLabel.text = [NSString stringWithFormat:@"longtitude:  %f",longitude];
    //self.latLabel.text = [NSString stringWithFormat:@"latitude:  %f",latitude];
    self.mapView.mapType = MKMapTypeStandard;
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = latitude;
    newRegion.center.longitude = longitude;
    newRegion.span.latitudeDelta = 0.004;
    newRegion.span.longitudeDelta = 0.004;
    NSString *xml = @"<searchLocationsResponse> <location distance=\"0.71\" phone=\"(415) 339-8890\" state=\"CA\" city=\"Sausalito\" address=\"80 Liberty Ship Way\" name=\"Fenzi Designs\" id=\"25416105\"/> <location distance=\"0.73\" phone=\"(415) 331-0444\" state=\"CA\" city=\"Sausalito\" address=\"85 Liberty Ship Way, #110a\" name=\"Bay Adventures\" id=\"21540217\"/></searchLocationsResponse>";
    
    NSString *error = nil;
    
    NSLog(@"String data: %@ \n", xml);
    
    NSError *theError = NULL;
    CXMLDocument *theXMLDocument = [[[CXMLDocument alloc] initWithXMLString:xml options:0 error:&theError] autorelease];
    NSLog (@"Err  :%@ \n",theError);
    NSLog (@"Document  :%@ \n",theXMLDocument);

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation new] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"I am here"];
    [self.mapView removeAnnotation:self.mapView.annotations];
    /*int i;
     for(i = 0; i < 3; i++) {
     CLLocationCoordinate2D coordinate2;
     coordinate2.latitude = la[i]	;
     coordinate2.longitude = lo[i];
     MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
     [annotation2 setCoordinate:coordinate2];
     [annotation2 setTitle: [NSString stringWithFormat:@"Bank %d", i]];
     [self.mapView addAnnotation:annotation2];
     }
     //[self.mapView removeAnnotation:self.mapView.annotations];
     [self.mapView addAnnotation:annotation];*/
    
    //[self.mapView setRegion:newRegion animated:YES];
}

@end
