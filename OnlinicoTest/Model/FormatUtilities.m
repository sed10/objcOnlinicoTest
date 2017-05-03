//
//  FormatUtilities.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/28/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "FormatUtilities.h"

@implementation FormatUtilities

+ (NSDateFormatter *) dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"uk_UA"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return dateFormatter;
}

+ (NSString *) stringFromDate:(NSDate *)date {
    return [[FormatUtilities dateFormatter] stringFromDate:date];
}

@end
