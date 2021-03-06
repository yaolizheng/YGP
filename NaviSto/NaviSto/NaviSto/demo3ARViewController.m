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
#import "demo3DetailedController.h"
#import "WebService.h"

@implementation demo3ARViewController


@synthesize placesOfInterest;
@synthesize hud;

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
    [self showLoading:@"all"];
}

- (void) reload
{
    ARView *arView = (ARView *)self.view;
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    
    
	placesOfInterest = [NSMutableArray arrayWithCapacity:[app.places count]];
	for (int i = 0; i < [app.places count]; i++) {
        Place *p = [app.places objectAtIndex:i];
        UIImage *image = [UIImage imageNamed:@"button(2).png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.center = CGPointMake(200.0f, 200.0f);
        [button setTitle:p.name forState:(UIControlStateNormal)];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
        
        button.titleLabel.font = [UIFont fontWithName:@"Courier" size:20];
        [button setBackgroundColor:[UIColor clearColor]];
        CGSize size = [button.titleLabel.text sizeWithFont:button.titleLabel.font];
        button.bounds = CGRectMake(0.0f, 0.0f, size.width + 10, size.height + 2);
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        PlaceOfInterest *poi = [PlaceOfInterest placeOfInterestWithView:button at:[[[CLLocation alloc] initWithLatitude:p.location.coordinate.latitude longitude:p.location.coordinate.longitude] autorelease]];
        button.tag = i;
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
    
    
    
    
    
    
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    CLLocation *loc = app.location;
    float latitude = loc.coordinate.latitude;
    float longitude = loc.coordinate.longitude;
    [WebService getLocation:[[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease] withType:@"all"];
    NSArray *arr = [NSArray arrayWithObjects:@"All",@"ATM",@"Bank",nil];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:arr];
    seg.segmentedControlStyle = UISegmentedControlSegmentCenter;
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    [self reload];
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

-(IBAction)buttonPress:(id)sender{
    UIButton* btn = (UIButton *) sender;
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    app.ID = btn.tag;

    demo3DetailedController *detail = [[demo3DetailedController alloc]init];
    //detail.navigationItem.title = @"Location Information";
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)showLoading: (NSString *)type {
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:hud];
    hud.delegate = self;
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [indicator startAnimating];
    hud.customView = indicator;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"Loading...";
    [hud showWhileExecuting:@selector(sendRequest:) onTarget:self withObject:type animated:YES];
    
}

- (void)sendRequest: (NSString *)type {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    demo3AppDelegate *app=[[UIApplication sharedApplication] delegate];
    [WebService getLocation:app.location withType:type];
    [self reload];
    
}



- (void)segmentAction:(id)sender{
    switch ([sender selectedSegmentIndex]){
        case 0:{
            [self showLoading:@"all"];
        }
            break;
            
        case 1:{
            [self showLoading:@"atm"];
        }
            break;
        case 2:{
            [self showLoading:@"bank"];
        }
            break;
        default:
            break;
    }
}

@end
