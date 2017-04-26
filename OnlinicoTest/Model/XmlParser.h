//
//  xmlParser.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/25/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlParser : NSObject <NSXMLParserDelegate>
- (instancetype)initWithArray: (NSMutableArray *)feedArray;
- (void)parseXMLFile;
@end
