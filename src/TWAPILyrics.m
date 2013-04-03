//
//  TWAPILyricsResponse.m
//  SDK
//
//  Created by Andrew McSherry on 3/27/13.
//  Copyright (c) 2013 TuneWiki, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
//  persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
//  Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "TWAPILyrics.h"


@implementation TWAPILyrics

@synthesize lines = _lines;

- (id) initWithJSON:(NSData*)json {
    if (self = [super init]) {
        NSError *error;
        id object = [NSJSONSerialization JSONObjectWithData:json
                                                    options:0
                                                      error:&error];
        if ([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*) object;
            NSMutableArray *linesArray = [NSMutableArray array];

            NSArray *keys = [dict allKeys];
            keys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                return [obj1 compare:obj2];
            }];

            for (NSString *key in keys) {
                NSDictionary *lineDict = [dict valueForKey:key];
                TWAPILyricLine *line = [[[TWAPILyricLine alloc] initWithText:[lineDict valueForKey:@"text"]
                                                                   timestamp:[[lineDict valueForKey:@"ts"] unsignedIntValue]] autorelease];
                [linesArray addObject:line];
            }
            _lines = [linesArray copy];
        } else {
            _lines = [NSArray new];
        }
    }
    return self;
}

- (void) dealloc {
    [_lines release];
    [super dealloc];
}

@end

#pragma mark -

@implementation TWAPILyricLine

@synthesize text = _text;
@synthesize timestamp = _timestamp;

- (id) initWithText:(NSString*)text timestamp:(NSUInteger)timestamp {
    if (self = [super init]) {
        _text = [text copy];
        _timestamp = timestamp;
    }
    return self;
}

- (void) dealloc {
    [_text release];
    [super dealloc];
}

@end