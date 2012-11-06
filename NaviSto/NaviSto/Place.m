//
//  Place.m
//  NaviSto
//
//  Created by Yaoli Zheng on 11/5/12.
//  Copyright (c) 2012 Tao Zong. All rights reserved.
//

#import "Place.h"

@implementation Place

@synthesize name;
@synthesize location;

- (id)init
{
    self = [super init];
    if (self) {
        name = nil;
        location = nil;
    }
    return self;
}

- (void)dealloc
{
	
	[location release];
	[super dealloc];
}

+ (Place *)placeAt:(CLLocation *)location withName:(NSString *)name{
	Place *p = [[[Place alloc] init] autorelease];
	p.name = name;
	p.location = location;
	return p;
}

@end
