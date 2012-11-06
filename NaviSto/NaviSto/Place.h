//
//  Place.h
//  NaviSto
//
//  Created by Yaoli Zheng on 11/5/12.
//  Copyright (c) 2012 Tao Zong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Place : NSObject

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *name;

+ (Place *)placeAt:(CLLocation *)location withName:(NSString *)name;

@end
