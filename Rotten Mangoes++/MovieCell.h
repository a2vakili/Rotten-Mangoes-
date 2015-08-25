//
//  MovieCell.h
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-24.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Movie;

@interface MovieCell : UICollectionViewCell

-(void)displayMovies:(Movie *)movie;

@end
