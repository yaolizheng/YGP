//
//  demo3ARViewController.m
//  demo
//
//  Created by Tao Zong on 10/15/12.
//  Copyright (c) 2012 Tao Zong. All rights reserved.
//

#import "demo3ARViewController.h"

#import "PlaceOfInterest.h"
#import "ARView.h"
#import "demo3AppDelegate.h"
#import "Place.h"
#import <CoreLocation/CoreLocation.h>

@implementation demo3ARViewController

//@synthesize arView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    NSArray *arr = [NSArray arrayWithObjects:@"All",@"ATM",@"Bank",nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:arr];
    seg.segmentedControlStyle = UISegmentedControlSegmentCenter;
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
	ARView *arView = (ARView *)self.view;
	
	// Create array of hard-coded places-of-interest, in this case some famous parks
    /*const char *poiNames[] = {"Bank of America1",
        "BoA ATM",
        "Citibank",
        "Citibank ATM",
        "Wells Fargo",
        "Chase",
        "Bank Of America2",
        "Wells Fargo"};
	
    CLLocationCoordinate2D poiCoords[] = {{37.780630, -122.466052},
        {37.781608, -122.458136},
        {37.786861, -122.447032},
        {37.776533, -122.461293},
        {37.785836, -122.461073},
        {37.797488, -122.464395},
        {37.780630, -122.466052},
        {37.782676, -122.483373}};
    
    int numPois = sizeof(poiCoords) / sizeof(CLLocationCoordinate2D);*/
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    
    
	NSMutableArray *placesOfInterest = [NSMutableArray arrayWithCapacity:[app.places count]];
	for (int i = 0; i < [app.places count]; i++) {
        Place *p = [app.places objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:@"button(2).png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.center = CGPointMake(200.0f, 200.0f);
        [button setTitle:p.name forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont fontWithName:@"Courier" size:20];
        [button setBackgroundColor:[UIColor clearColor]];
        CGSize size = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
        button.bounds = CGRectMake(0.0f, 0.0f, size.width + 10, size.height + 2);
        [button setBackgroundImage:image forState:UIControlStateNormal];
               PlaceOfInterest *poi = [PlaceOfInterest placeOfInterestWithView:button at:[[[CLLocation alloc] initWithLatitude:p.location.coordinate.latitude longitude:p.location.coordinate.longitude] autorelease]];
        [placesOfInterest insertObject:poi atIndex:i];
	}
	[arView setPlacesOfInterest:placesOfInterest];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	ARView *arView = (ARView *)self.view;
	[arView start];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	ARView *arView = (ARView *)self.view;
	[arView stop];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)segmentAction:(id)sender{
    switch ([sender selectedSegmentIndex]){
        case 0:{
        }
            break;
            
        case 1:{
        }
            break;
        case 2:{
        }
            break;
        default:
            break;
    }
}

@end
