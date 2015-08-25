//
//  ReviewCell.h
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-24.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *criticReviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateReviewLabel;
@property (weak, nonatomic) IBOutlet UITextView *quoteTextView;

@end
