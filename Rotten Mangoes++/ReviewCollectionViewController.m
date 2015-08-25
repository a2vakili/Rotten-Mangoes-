//
//  ReviewCollectionViewController.m
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-24.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import "ReviewCollectionViewController.h"
#import "Movie.h"
#import "ReviewCell.h"
#import "HeaderView.h"
#import "MapViewController.h"

@interface ReviewCollectionViewController ()

@property(nonatomic,strong) NSMutableArray *reviews;

@end

@implementation ReviewCollectionViewController

static NSString * const reuseIdentifier = @"ReviewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.movie.reviews];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSError *jsonError;
        
        NSDictionary *reviews = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (!reviews) {
            NSLog(@"There was an error %@",jsonError);
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.reviews = reviews[@"reviews"];
                [self.collectionView reloadData];
            });
        }
        
        
    }];
    
    [task resume];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.reviews.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ReviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSDictionary *reviewDict = self.reviews[indexPath.item];
    cell.criticReviewLabel.text = reviewDict[@"critic"];
    cell.dateReviewLabel.text = reviewDict[@"date"];
    cell.quoteTextView.text = reviewDict[@"quote"];
    
    
    // Configure the cell
    
    return cell;
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.movie.thumbnailString]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            UIImage *image = [UIImage imageWithData: data];
            headerView.movieImageView.image = image;
        });
    });
    
    return headerView;
}


- (IBAction)showMap:(id)sender {
    MapViewController *mapViewController = [[MapViewController alloc]init];
    
    mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showMap"];
    mapViewController.movie = self.movie;
 
    [self.navigationController pushViewController:mapViewController animated:YES];
 //  [self performSegueWithIdentifier:@"showMap" sender:sender];
    
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
