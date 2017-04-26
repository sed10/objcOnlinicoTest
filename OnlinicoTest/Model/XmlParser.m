//
//  XmlParser.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "XmlParser.h"
#import "Article.h"
#import "AppDelegate.h"

@interface XmlParser()
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic, strong) NSMutableString *currentElement;
@end

@implementation XmlParser

- (NSMutableArray *)feedArray {
    if (!_feedArray) _feedArray = [[NSMutableArray alloc] init];
    return _feedArray;
}

- (void)parseXMLFile {
    NSURL *url = [NSURL URLWithString:@"http://www.telegraf.in.ua/rss.xml"];
    
    // local file
    //NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"rss" withExtension:@"xml"];
    
    // without NSURLSession
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];

    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            BOOL result = [parser parse];
            if (result) {
                NSLog(@"Successful parse");
            } else {
                NSLog(@"Failed parse");
            }
            
        }
    }];
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
        self.currentElement = [[NSMutableString alloc] initWithString:string];
    } else {
        [self.currentElement appendString:string];
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

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XmlParserDelegate)]) {
        [self.delegate xmlParserDidFinishParsingWithResults:self.feedArray];
    }
}

@end
