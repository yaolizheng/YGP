//
//  ViewController.m
//  MapWithXML
//
//  Created by Yaoli Zheng on 10/11/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"
#import "TouchXML.h"
#import "DetailViewController.h"
#import "WebService.h"
#import "AppDelegate.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize NavigationBar;
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
    mapView.delegate = self;
 
    /*NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xmlfile.xml"];
    //取得数据
    NSData *XMLData = [NSData dataWithContentsOfFile:XMLPath];
    //生成CXMLDocument对象
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                        options:0
                                                          error:nil
                              ];
    
    NSArray *location = NULL;
    NSDictionary *mappings = [NSDictionary dictionaryWithObject:@"http://www.mfoundry.com/GBML/Schema" forKey:@"gbmluri"];
    location = [document nodesForXPath:@"//gbmluri:searchLocationsResponse/gbmluri:location" namespaceMappings:mappings error:nil];    //books = [document nodesForXPath:@"//searchLocationsResponse" error:nil];*/
    WebService.getLocation;
    AppDelegate *app=[[UIApplication sharedApplication] delegate];
    
    for(int i = 0; i < [app.places count]; i++) {
        PlaceOfInterest *poi = [app.places objectAtIndex:i];
    NSLog(@"%f",poi.location.coordinate.latitude);
    NSLog(@"%f",poi.location.coordinate.longitude);
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = poi.location.coordinate.latitude;
    coordinate.longitude = poi.location.coordinate.longitude;
    MKPointAnnotation *annotation2 = [[MKPointAnnotation new] init];
            [annotation2 setCoordinate:coordinate];
            [annotation2 setTitle: poi.name];
            [self.mapView addAnnotation:annotation2];
    }
            /*for (int i = 0; i < [element childCount]; i++)
            {
                if (![[[element children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    [item setObject:[[element childAtIndex:i] stringValue]
                             forKey:[[element childAtIndex:i] name]
                     ];
                    NSLog(@"%@", [[element childAtIndex:i] stringValue]);
                }
            }*/
            //NSLog(@"%@", item);
        //}
   // }

    
}

- (void)viewDidUnload
{
    
    [self setMapView:nil];
    [self setNavigationBar:nil];
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

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if ([[annotation title] isEqualToString:@"I am here"]) {
        return nil;
    }
    
    MKAnnotationView *annView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"currentloc"];
    if ([[annotation title] isEqualToString:@"Citibank ATM"]) {
        annView.image = [UIImage imageNamed:@"citibank.bmp"] ;
        UIView *leftCAV = [[UIView alloc] initWithFrame:CGRectMake(0,0,23,23)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"citibank.bmp"]];
        [leftCAV addSubview : imageView];
        UILabel *FirstLine = [[UILabel alloc] init];
        [FirstLine setText: @"line1"];
        [leftCAV addSubview : FirstLine];
        UILabel *SecondLine = [[UILabel alloc] init];
        [SecondLine setText: @"line2"];
        [leftCAV addSubview : SecondLine];
        annView.leftCalloutAccessoryView = leftCAV;
        
    }
    else if ([[annotation title] isEqualToString:@"Apple store"])
        annView.image = [ UIImage imageNamed:@"applestore.png" ];
    else
        annView.image = [ UIImage imageNamed:@"marker.png" ];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [infoButton addTarget:self action:@selector(infoButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    annView.rightCalloutAccessoryView = infoButton;
    annView.canShowCallout = YES;
    return annView;
}

-(void) infoButtonPressed
{
    NSLog(@"--------------------------------");
    DetailViewController *destinationController = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:destinationController animated:YES];

/*UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                  bundle:nil];
    DetailViewController *vc = [sb instantiateViewControllerWithIdentifier:@"DetailViewController"];
    //[self.view addSubview: vc.view];
    [self.navigationController presentModalViewController:vc animated:TRUE];*/
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

    
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = latitude;
    coordinate.longitude = longitude;
    MKPointAnnotation *annotation = [[MKPointAnnotation new] init];
    [annotation setCoordinate:coordinate];
    [annotation setTitle:@"I am here"];
    [self.mapView addAnnotation:annotation];
    //[self.mapView removeAnnotation:self.mapView.annotations];
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
    
    [self.mapView setRegion:newRegion animated:YES];
}

@end
