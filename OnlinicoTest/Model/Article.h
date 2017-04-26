//
//  Article.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *link;
@property (nonatomic, strong) NSString *shortText;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate *pubDate;
@property (nonatomic, strong) NSString *fullText;
@property (nonatomic, strong) NSURL *imageUrl;
@end
