//
//  MovieCollectionViewController.m
//  
//
//  Created by Arsalan Vakili on 2015-08-24.
//
//

#import "MovieCollectionViewController.h"
#import "Movie.h"
#import "MovieCell.h"
#import "ReviewCollectionViewController.h"

static NSString * const reuseIdentifier = @"MovieCell";

static NSString *apiKey = @"sr9tdu3checdyayjz85mff8j";
static NSString *identifier = @"showDetails";

@interface MovieCollectionViewController ()

@property(nonatomic,strong) NSArray *movies;

@end

@implementation MovieCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=%@&page_limit=50",apiKey];
    
    NSURL *url = [NSURL URLWithString:urlString];
    //NSLog(@"%@",url);
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        
        NSDictionary *movieDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError != nil) {
            NSLog(@"There was an error decoding the json %@",jsonError.localizedFailureReason);
            return;
        }
        
        else{
            NSArray *listOfMovies = movieDict[@"movies"];
           // NSLog(@"%@",listOfMovies);
            if (!listOfMovies) {
                NSLog(@"There was an error %@",error);
            }
            else{
                NSMutableArray *movies = [[NSMutableArray alloc]init];
                for (NSDictionary *movieDict in listOfMovies) {
                    
                    // setting up the movies info from each dictionary
                    Movie *aMovie = [[Movie alloc]init];
                    aMovie.title = movieDict[@"title"];
                    aMovie.runTime = movieDict[@"runtime"];
                    aMovie.synopsis = movieDict[@"synopsis"];
                    aMovie.movieRating = movieDict[@"mpaa_rating"];
                    
                    NSString *temporaryReviewString = movieDict[@"links"][@"reviews"];
                    
                    //NSLog(@"%@",temporaryReviewString);
                    NSString *reviewLimitString = [NSString stringWithFormat:@"?apikey=%@&page_limit=3",apiKey];
                    
                    NSString *reviewString = [temporaryReviewString stringByAppendingString:reviewLimitString];
                    
                    
                    
                    aMovie.reviews = reviewString;
                    
                    aMovie.thumbnailString = movieDict[@"posters"][@"thumbnail"];
                    [movies addObject:aMovie]; // adding the movie information to the array
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.movies = movies;
                    [self.collectionView reloadData];
                });
                
            }
        }
        
    }];
    
    [task resume];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetails"]) {
        NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] objectAtIndex:0];
        Movie *movie = self.movies[indexPath.item];
        
        
        ReviewCollectionViewController *detailVc = [segue destinationViewController];
        detailVc.movie = movie;
    }

}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.movies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    Movie *movie = self.movies[indexPath.item];
    [cell displayMovies:movie];

    
    return cell;
}





@end
