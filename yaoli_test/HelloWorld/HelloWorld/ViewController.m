//
//  ViewController.m
//  HelloWorld
//
//  Created by Yaoli Zheng on 9/24/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize Label;
@synthesize Text;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setLabel:nil];
    [self setText:nil];
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

- (BOOL) textFieldShouldReturn: (UITextField *) theTextField {
    if(theTextField == Text) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (IBAction)Greeting:(id)sender {
    NSString *name = Text.text;
    if([name length] == 0) {
        name = @"world";
    }
    NSString *string = [[NSString alloc] initWithFormat:@"hello %@", name];
    Label.text = string;
}
@end
