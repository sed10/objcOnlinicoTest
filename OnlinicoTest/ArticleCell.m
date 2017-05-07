//
//  ArticleCell.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/7/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "ArticleCell.h"
#import "Article.h"
#import "FormatUtilities.h"

@interface ArticleCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *linkTextView;
@end

@implementation ArticleCell

- (void)configureForArticle:(Article *)article {
    if (article != nil) {
        self.titleLabel.text = article.title;
        self.mainTextLabel.text = article.fullText;
        self.categoryLabel.text = article.category;
        self.linkTextView.text = article.link;
        self.dateLabel.text = [FormatUtilities stringFromDate:article.pubDate];
    }
}

@end
