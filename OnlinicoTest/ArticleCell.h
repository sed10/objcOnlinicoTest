//
//  ArticleCell.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/7/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article;

@interface ArticleCell : UITableViewCell
- (void)configureForArticle:(Article *)article;
@end
