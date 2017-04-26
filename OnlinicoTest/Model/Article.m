//
//  Article.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "Article.h"

@implementation Article
- (instancetype)init {
    self = [super init];
    if(self) {
        self.title = @"";
        self.shortText = @"";
        self.category = @"";
        self.fullText = @"";
    }
    return self;
}
@end
