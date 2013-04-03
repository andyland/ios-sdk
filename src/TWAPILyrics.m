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

@interface TWAPILyrics()

- (BOOL) hasValidSync;

@end

#pragma mark -

@implementation TWAPILyrics

@synthesize lines = _lines;
@synthesize artist = _artist;
@synthesize title = _title;
@synthesize language = _language;

#pragma mark -
#pragma mark Public Methods

+ (TWAPILyrics*) lyricsWithJSON:(NSData*)json {
    TWAPILyrics *lyrics = [[TWAPILyrics new] autorelease];
    
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:json
                                                options:0
                                                  error:&error];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*) object;
        NSMutableArray *linesArray = [NSMutableArray array];

        for (NSUInteger i = 0, count = [dict count]; i < count; i++) {
            NSDictionary *lineDict = [dict valueForKey:[NSString stringWithFormat:@"%u", 1 + i]];
            TWAPILyricLine *line = [[[TWAPILyricLine alloc] initWithText:[lineDict valueForKey:@"text"]
                                                               timestamp:[[lineDict valueForKey:@"ts"] doubleValue] / 1000] autorelease];
            [linesArray addObject:line];
        }
        lyrics.lines = [NSArray arrayWithArray:linesArray];
    } else {
        lyrics.lines = [NSArray array];
    }
    return lyrics;
}

+ (TWAPILyrics*) lyrics {
    return [[TWAPILyrics new] autorelease];
}

- (NSData*) jsonData {
    BOOL hasValidSync = [self hasValidSync];
    NSMutableDictionary *topLevel = [NSMutableDictionary dictionary];
    NSDictionary *lineDict;
    TWAPILyricLine *line;

    for (NSUInteger i = 0, count = [self.lines count]; i < count; i++) {
        line = [self.lines objectAtIndex:i];
        if (hasValidSync) {
            NSString *timestamp = [NSString stringWithFormat:@"%u", (NSUInteger)(line.timestamp / 1000)];
            lineDict = [NSDictionary dictionaryWithObjectsAndKeys:line.text, @"text",
                                                                  timestamp, @"ts", nil];
        } else {
            lineDict = [NSDictionary dictionaryWithObjectsAndKeys:line.text,@"text", nil];
        }
        [topLevel setValue:lineDict
                    forKey:[NSString stringWithFormat:@"%u", i]];
    }

    NSError *error;
    return [NSJSONSerialization dataWithJSONObject:topLevel
                                           options:0
                                             error:&error];
}


#pragma mark -
#pragma mark Helpers

/*
 * Fairly simple check for validity here, just making sure
 * the lines are synced in order
 */
- (BOOL) hasValidSync {
    BOOL valid = YES;
    
    NSTimeInterval lastTimestamp = 0;

    for (TWAPILyricLine *line in self.lines) {
        NSTimeInterval thisTimestamp = line.timestamp;
        if (thisTimestamp <= lastTimestamp) {
            valid = NO;
            break;
        }
        lastTimestamp = thisTimestamp;
    }

    return valid;
}

- (void) dealloc {
    [_lines release];
    [_artist release];
    [_title release];
    [_language release];
    [super dealloc];
}

@end

#pragma mark -

@implementation TWAPILyricLine

@synthesize text = _text;
@synthesize timestamp = _timestamp;

- (id) initWithText:(NSString*)text timestamp:(NSTimeInterval)timestamp {
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