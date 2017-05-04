//
//  FeedTableViewCell.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/27/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Article.h"
@class Article;

@interface FeedTableViewCell : UITableViewCell
- (void)setNewArticle:(Article *)newArticle;
@end
