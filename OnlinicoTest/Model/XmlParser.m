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

// should use constants here

@interface XmlParser()
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) Article *currentArticle;
@property (nonatomic, strong) NSMutableString *currentElementText;
@property (nonatomic, strong) NSMutableArray *currentArticleImages;
@property (nonatomic, strong) NSDate *lastArticleDate;
@end

@implementation XmlParser

// returns new XmlParser, which only fetches new articles since last fetched article
- (XmlParser *)newer {
    if (self.lastArticleDate) {
        XmlParser *newXmlParser = [[XmlParser alloc] init];
        newXmlParser.sinceDate = self.lastArticleDate;
        return newXmlParser;
    }
    return self;
}

// fetches articles and invokes handler for them
- (void)fetchArticlesWithHandler:(void (^) (NSArray *articles))handler {
    
    // is this an appropriate place for RSS url?
    NSURL *url = [NSURL URLWithString:@"http://www.telegraf.in.ua/rss.xml"];
    
    // local file
    //NSURL *xmlURL = [[NSBundle mainBundle] URLForResource:@"rss" withExtension:@"xml"];
    
    // without NSURLSession
    //NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
    
    // parse XML
    [NetworkUtilities downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
            [parser setDelegate:self];
            BOOL result = [parser parse];
            if (!result) {
                NSLog(@"Parsing is failed or aborted");
            }
        }
        // handle articles array
        handler(self.articles);
    }];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    if (!self.articles) {
        self.articles = [[NSMutableArray alloc] init];
    }
    [self.articles removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:@"item"]) {
        // item - new article
        self.currentArticle = [[Article alloc] init];
    } else
    if ([elementName isEqualToString:@"enclosure"]) {
        // enclosure - enclosed files
        // <enclosure url="fileurl" type="image/jpeg"/>
        // types: "image/jpeg", "image/png"
        
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
    
    if (!self.currentElementText) {
        //self.currentElement = [[NSMutableString alloc] initWithString:string];
        self.currentElementText = [NSMutableString stringWithString:string];
    } else {
        [self.currentElementText appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {
    
    NSString *currentElementText = [[self.currentElementText stringByReplacingOccurrencesOfString:@"\n" withString:@""] gtm_stringByUnescapingFromHTML];
    
    if ([elementName isEqualToString:@"item"]) {
        // end of current article
        self.currentArticle.imagesUrls = self.currentArticleImages;
        [self.articles addObject:self.currentArticle];
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
        NSDate *curArticleDate = [NSDate dateFromRFC822String:currentElementText];
        
        // abort parsing if the article's date is earlier than fetching date
        if (self.sinceDate && self.sinceDate>=curArticleDate) {
            self.currentArticle = nil;
            self.currentArticleImages = nil;
            [parser abortParsing];
        } else {
            self.currentArticle.pubDate = curArticleDate;
            // fix latest date
            self.lastArticleDate = self.lastArticleDate ? [self.lastArticleDate laterDate:curArticleDate] : curArticleDate;
        }
    }

    self.currentElementText = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
//    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XmlParserDelegate)]) {
//        [self.delegate xmlParserDidFinishParsingWithResults:self.articles];
//    }
}

@end
