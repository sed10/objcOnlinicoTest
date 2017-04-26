//
//  XmlParser.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "XmlParser.h"
#import "Article.h"

@interface XmlParser()
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic, strong) NSString *currentElement;
@end

@implementation XmlParser

- (instancetype)initWithArray: (NSMutableArray *)feedArray {
    self = [super init];
    if (self) {
        self.feedArray = feedArray;
    }
    return self;
}

- (void)parseXMLFile {
    NSURL *xmlPath = [[NSURL alloc] initWithString:@"http://www.telegraf.in.ua/rss.xml"];

    // local file
    //NSURL *xmlPath = [[NSBundle mainBundle] URLForResource:@"rss" withExtension:@"xml"];

    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlPath];
    parser.delegate = self;
    
    if (![parser parse]){
        NSLog(@"Parser failed!");
    }
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"item"]) {
        self.currentArticle = [[Article alloc] init];
    } else
    if ([elementName isEqualToString:@"enclosure"]) {
        //NSString *type = [attributeDict objectForKey:@"type"];
        //NSString *url = [attributeDict objectForKey:@"url"];
        
        //self.currentArticle.imageUrl =
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!self.currentElement) {
        self.currentElement = string;
    } else {
        self.currentElement = [self.currentElement stringByAppendingString:string];
    }
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [self.feedArray addObject:self.currentArticle];
        self.currentArticle = nil;
    } else
    if ([elementName isEqualToString:@"title"]) {
        self.currentArticle.title = [self.currentElement stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }

    self.currentElement = nil;
}

@end
