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
    
    NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xmlfile.xml"];
    //取得数据
    NSData *XMLData = [NSData dataWithContentsOfFile:XMLPath];
    //生成CXMLDocument对象
    CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                        options:0
                                                          error:nil
                              ];
    NSLog (@"Document  :%@ \n",document);
    NSArray *location = NULL;
    NSDictionary *mappings = [NSDictionary dictionaryWithObject:@"http://www.mfoundry.com/GBML/Schema" forKey:@"gbmluri"];
    location = [document nodesForXPath:@"//gbmluri:searchLocationsResponse/gbmluri:location" namespaceMappings:mappings error:nil];
    
    //books = [document nodesForXPath:@"//searchLocationsResponse" error:nil];
    NSLog (@"err  :%@ \n",location);
    NSString *strValue;
    NSString *strName;
    for (CXMLElement *element in location)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
            NSLog(@"--------------------------------");  
            NSMutableDictionary *objectAttributes=[[NSMutableDictionary alloc] init];
            NSArray *arAttr=[element attributes];
            NSUInteger i, countAttr = [arAttr count];
            for (i = 0; i < countAttr; i++) {
                strValue=[[arAttr objectAtIndex:i] stringValue];
                strName=[[arAttr objectAtIndex:i] name];
                if(strValue && strName){
                    [objectAttributes setValue:strValue forKey:strName];
                    NSLog(@"name: %@", strName);
                    NSLog(@"value: %@", strValue);
                }
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
        }
    }

    
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
