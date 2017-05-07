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
#import "ImageCell.h"

@interface ArticleTableViewController ()
@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation ArticleTableViewController

- (void)configureForArticle:(Article *)article
{
    if (self.article != article) {
        self.article = article;
        self.images = [[NSMutableArray alloc] init];
        
        // not sure if this solution is fine
        for (int imageNum = 0; imageNum < article.imagesUrls.count ; imageNum++ ) {
            [self.images addObject:[NSNull null]];
            
            NSURL *imageUrl = [NSURL URLWithString:article.imagesUrls[imageNum]];

            ArticleTableViewController * __weak weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL:imageUrl];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.images replaceObjectAtIndex:imageNum withObject:[UIImage imageWithData:data]];
                        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:imageNum+1 inSection:0];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[rowToReload] withRowAnimation:UITableViewRowAnimationNone];
                    });
                }
            });
        }
        
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
        ImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"articleImageCell" forIndexPath:indexPath];
        [cell configureForImage:self.images[indexPath.row-1]];
        return cell;
    }
}

@end
