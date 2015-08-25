//
//  Movie.h
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-24.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject


@property(nonatomic,strong) NSString *thumbnailString;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSNumber *runTime;
@property(nonatomic,strong) NSString *movieRating;
@property(nonatomic,strong) NSString *synopsis;
@property(nonatomic,strong) NSString *reviews;

@end
