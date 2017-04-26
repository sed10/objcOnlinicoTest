//
//  xmlParser.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XmlParserDelegate <NSObject>
- (void)xmlParserDidFinishParsingWithResults: (NSArray *)results;
@end

@interface XmlParser : NSObject <NSXMLParserDelegate>
@property (nonatomic, weak) id <XmlParserDelegate> delegate;
- (void)parseXMLFile;
@end
