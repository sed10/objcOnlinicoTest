//
//  ArticleViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/27/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()
@property (nonatomic, strong) Article *article;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation ArticleViewController

- (void)setNewArticle:(Article *)newArticle
{
    if (self.article != newArticle) {
        self.article = newArticle;
        [self updateUI];
    }
}

- (void)updateUI {
    if (self.article) {
        self.titleLabel.text = self.article.title;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // [self addObserver:self forKeyPath:@"article" options:0 context:@selector(updateUI)];
    
    [self updateUI];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [self removeObserver:self forKeyPath:@"article"];
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
//    if (context == @selector(updateUI)) {
//        [self updateUI];
//    }
//}

@end
