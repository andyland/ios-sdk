//
//  TWAPILyricRequest.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
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

#import "TWAPILyricRequest.h"
#import "NSString+TWUtils.h"
#import "TWAPI.h"

@implementation TWAPILyricRequest

@synthesize artist = _artist;
@synthesize title = _title;
@synthesize language = _language;

- (id) initWithArtist:(NSString*)artist
                title:(NSString*)title
             language:(NSString*)language
             delegate:(id<TWAPIDelegate>)delegate {
    if (self = [super initWithDelegate:delegate]) {
        _artist = [artist copy];
        _title = [title copy];
        _language = [language copy];
    }
    return self;
}

- (NSString*) resourcePath {
    return [NSString stringWithFormat:@"/%@/%@/%@",
                                      TWAPIResourceLyrics,
                                      [self.artist stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                                      [self.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSDictionary*) httpHeaders {
    if (self.language) {
        return [NSDictionary dictionaryWithObject:self.language forKey:@"Accept-Language"];
    }
    return nil;
}

- (void) dealloc {
    [_artist release];
    [_title release];
    [_language release];
    [super dealloc];
}

@end
