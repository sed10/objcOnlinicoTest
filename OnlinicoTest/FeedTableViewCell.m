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
@end

@implementation FeedTableViewCell

- (void)updateUI {
    self.titleLabel.text = self.article.title;
    self.descriptionLabel.text = self.article.shortText;
    self.categoryLabel.text = self.article.category;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    self.dateLabel.text = [dateFormatter stringFromDate:self.article.pubDate];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == @selector(updateUI)) {
        [self updateUI];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addObserver:self forKeyPath:@"article" options:0 context:@selector(updateUI)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
