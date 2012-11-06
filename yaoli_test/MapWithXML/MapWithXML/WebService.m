//
//  WebService.m
//  MapWithXML
//
//  Created by Yaoli Zheng on 11/4/12.
//  Copyright (c) 2012 Yaoli Zheng. All rights reserved.
//

#import "WebService.h"
#import "TouchXML.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
@implementation WebService



+ (void) getLocation {

NSString *XMLPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xmlfile.xml"];
//取得数据
NSData *XMLData = [NSData dataWithContentsOfFile:XMLPath];
//生成CXMLDocument对象
CXMLDocument *document = [[CXMLDocument alloc] initWithData:XMLData
                                                    options:0
                                                      error:nil
                          ];

NSArray *location = NULL;
NSDictionary *mappings = [NSDictionary dictionaryWithObject:@"http://www.mfoundry.com/GBML/Schema" forKey:@"gbmluri"];
location = [document nodesForXPath:@"//gbmluri:searchLocationsResponse/gbmluri:location" namespaceMappings:mappings error:nil];
    NSString *strValue;
    NSString *strName;
    AppDelegate *app=[[UIApplication sharedApplication] delegate];
    int count = 0;
    for (CXMLElement *element in location)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            count = count + 1;
        }
    }
    NSLog(@"%d", count);
    app.places = [NSMutableArray arrayWithCapacity:count] ;
    int j = 0;
    for (CXMLElement *element in location)
    {
        if ([element isKindOfClass:[CXMLElement class]])
        {
            NSMutableDictionary *object=[[NSMutableDictionary alloc] init];
            
            NSMutableDictionary *objectAttributes=[[NSMutableDictionary alloc] init];
            NSArray *arAttr=[element attributes];
            NSUInteger i, countAttr = [arAttr count];
            double lon;
            double lat;
            NSString *name;
            for (i = 0; i < countAttr; i++) {
                strValue=[[arAttr objectAtIndex:i] stringValue];
                strName=[[arAttr objectAtIndex:i] name];
                if(strValue && strName){
                    [objectAttributes setValue:strValue forKey:strName];
                    if(strValue && strName){
                        if([strName isEqualToString:@"lon"] == 1) {
                            lon = [strValue doubleValue];
                        }
                        if([strName isEqualToString:@"lat"] == 1) {
                            lat = [strValue doubleValue];
                        }
                        if([strName isEqualToString: @"name"] == 1) {
                            name = strValue;
                        }
                    }
                    
                }
            }
            
            PlaceOfInterest *poi = [PlaceOfInterest placeOfInterestWithView:[[CLLocation alloc] initWithLatitude:lat longitude:lon] withName:name];
            [app.places insertObject:poi atIndex:j];
            j++;
            NSLog(@"%d", j);
        }
    }

}

@end
