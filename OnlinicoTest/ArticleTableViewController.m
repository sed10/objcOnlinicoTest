//
//  ArticleTableViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/7/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "ArticleTableViewController.h"
#import "FormatUtilities.h"
#import "Article.h"
#import "ArticleCell.h"

@interface ArticleTableViewController ()
@property (nonatomic, strong) Article *article;
@end

@implementation ArticleTableViewController

- (void)configureForArticle:(Article *)article
{
    if (self.article != article) {
        self.article = article;
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // automatic row height
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.article.imagesUrls.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleMainCell" forIndexPath:indexPath];
        [cell configureForArticle:self.article];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleImageCell" forIndexPath:indexPath];

        
        
        return cell;
    }
}

@end
