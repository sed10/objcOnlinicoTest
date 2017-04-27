//
//  FeedTableViewCell.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/27/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "FeedTableViewCell.h"

@interface FeedTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UIImageView *articleImageView;
@end

@implementation FeedTableViewCell

- (void)updateUI {
    if (!self.article) return;
    
    // text
    self.titleLabel.text = self.article.title;
    self.descriptionLabel.text = self.article.shortText;
    self.categoryLabel.text = self.article.category;
    
    // date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.article.pubDate];
    
    // CHECK THIS CODE!!!
    // image
    if (self.article.imagesUrls) {
        // save current article for multithread checking
        Article *currentArticle = self.article;
        
        // get url of the first image in current article
        NSURL *firstArticleImage = [NSURL URLWithString:currentArticle.imagesUrls[0]];
        
        // make weak pointer to self
        FeedTableViewCell * __weak weakSelf = self;
        
        // get image data
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL:firstArticleImage];
            if (data) {
                // update image in the cell
                dispatch_async(dispatch_get_main_queue(), ^{
                    // check if the cell article is the same article image was requested for
                    if (weakSelf.article == currentArticle) {
                        weakSelf.articleImageView.image = [UIImage imageWithData: data];
                    }
                });
            }
        });
    }
}

// Can't use KVO here because the cell is reusable and can be deallocated
// just updateUI from the VC

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if (context == @selector(updateUI)) {
//        [self updateUI];
//    }
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //[self addObserver:self forKeyPath:@"article" options:0 context:@selector(updateUI)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
