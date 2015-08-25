//
//  Theatre.h
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-25.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit;

@interface Theatre : NSObject<MKAnnotation>

@property(nonatomic,assign) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;


@end
