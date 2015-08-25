//
//  MovieCell.m
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-24.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import "MovieCell.h"
#import "Movie.h"

@interface MovieCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieLengthLabel;

@property (weak, nonatomic) IBOutlet UITextView *synopsisTextView;
@end

@implementation MovieCell


-(void)displayMovies:(Movie *)movie{
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:movie.thumbnailString]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            UIImage *image = [UIImage imageWithData: data];
            self.thumbnailImageView.image = image;
        });
    });
    
    self.movieTitleLabel.text = movie.title;
    self.movieRatingLabel.text = movie.movieRating;
    self.movieLengthLabel.text = [NSString stringWithFormat:@"Length: %@ min",movie.runTime];
    self.synopsisTextView.text = movie.synopsis;
}

@end
