//
//  XmlParser.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "XmlParser.h"
#import "Article.h"
#import "NetworkUtilities.h"
#import "GTMNSString+HTML.h"        // module to unescape HTML characters
#import "NSDate+InternetDateTime.h" // module to convert NSString to NSDate

@interface XmlParser()
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic, strong) NSMutableString *currentElement;
@property (nonatomic, strong) NSMutableArray *currentArticleImages;
@end

@implementation XmlParser

// Lazy init or parserDidStartDocument ???
- (NSMutableArray *)feedArray {
    if (!_feedArray) _feedArray = [[NSMutableArray alloc] init];
    return _feedArray;
}

- (void)parseXMLFile {
    // is this an appropriate place for RSS url?
    NSURL *url = [NSURL URLWithString:@"http://www.telegraf.in.ua/rss.xml"];
    
    // local file
    //NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"rss" withExtension:@"xml"];
    
    // without NSURLSession
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    [NetworkUtilities downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            BOOL result = [parser parse];
            if (!result) {
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
        NSString *type = [attributeDict objectForKey:@"type"];
        NSString *url = [attributeDict objectForKey:@"url"];
        
        if ([type hasPrefix:@"image/"]) {
            if (!self.currentArticleImages) {
                self.currentArticleImages = [NSMutableArray arrayWithObject:url];
            } else {
                [self.currentArticleImages addObject:url];
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!self.currentElement) {
        //self.currentElement = [[NSMutableString alloc] initWithString:string];
        self.currentElement = [NSMutableString stringWithString:string];
    } else {
        [self.currentElement appendString:string];
    }
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {
    
    NSString *currentElementText = [[self.currentElement stringByReplacingOccurrencesOfString:@"\n" withString:@""] gtm_stringByUnescapingFromHTML];
    
    if ([elementName isEqualToString:@"item"]) {
        self.currentArticle.imagesUrls = self.currentArticleImages;
        [self.feedArray addObject:self.currentArticle];
        self.currentArticle = nil;
        self.currentArticleImages = nil;
    } else
    if ([elementName isEqualToString:@"title"]) {
        self.currentArticle.title = currentElementText;
    } else
    if ([elementName isEqualToString:@"description"]) {
        self.currentArticle.shortText = currentElementText;
    } else
    if ([elementName isEqualToString:@"category"]) {
        self.currentArticle.category = currentElementText;
    } else
    if ([elementName isEqualToString:@"yandex:full-text"]) {
        self.currentArticle.fullText = currentElementText;
    } else
    if ([elementName isEqualToString:@"link"]) {
        self.currentArticle.link = currentElementText;
    } else
    if ([elementName isEqualToString:@"pubDate"]) {
        self.currentArticle.pubDate = [NSDate dateFromRFC822String:currentElementText];
    }

    self.currentElement = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XmlParserDelegate)]) {
        [self.delegate xmlParserDidFinishParsingWithResults:self.feedArray];
    }
}

@end
