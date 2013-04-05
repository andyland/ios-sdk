//
//  TWAPISearchRequest.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/5/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
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

#import "TWAPISearchRequest.h"
#import "NSString+TWUtils.h"
#import "TWAPI.h"
#import "TWAPISearchResult.h"

@interface TWAPISearchRequest()

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *query;

@end

#pragma mark -

@implementation TWAPISearchRequest

@synthesize type = _type;
@synthesize query = _query;

+ (TWAPISearchRequest*) songsSearchRequestForLyrics:(NSString*)lyrics
                                           delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"lyrics"
                                               query:lyrics
                                            delegate:delegate] autorelease];
}

+ (TWAPISearchRequest*) songsSearchRequestForTitle:(NSString*)title
                                          delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"songs"
                                               query:title
                                            delegate:delegate] autorelease];
}

+ (TWAPISearchRequest*) songsSearchRequestForArtist:(NSString*)artist
                                                    title:(NSString*)title
                                                 delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"artistsongs"
                                               query:[NSString stringWithFormat:@"%@ %@", artist, title]
                                            delegate:delegate] autorelease];
}

+ (TWAPISearchRequest*) artistsSearchRequestForArtist:(NSString*)artist
                                             delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"artists"
                                               query:artist
                                            delegate:delegate] autorelease];
}


+ (TWAPISearchRequest*) commentsSearchRequestForHashtag:(NSString*)hashtag
                                              delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"hashtags"
                                               query:hashtag
                                            delegate:delegate] autorelease];
    
}

+ (TWAPISearchRequest*) commentsSearchRequestForText:(NSString*)text
                                            delegate:(id<TWAPIDelegate>)delegate {
    return [[[TWAPISearchRequest alloc] initWithType:@"shares"
                                               query:text
                                            delegate:delegate] autorelease];
}


- (id) initWithType:(NSString*)type
              query:(NSString*)query
           delegate:(id<TWAPIDelegate>)delegate{
    if (self = [super initWithDelegate:delegate]) {
        _type = [type copy];
        _query = [query copy];
    }
    return self;
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TWAPISearchResult *result = [TWAPISearchResult searchResultWithJSON:self.data];
    [self.delegate receivedResponse:result];
}

- (NSDictionary*) getParams {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.type, @"type",
                                                      self.query, @"q", nil];
}

- (NSString*) resourcePath {
    return [NSString stringWithFormat:@"/%@", TWAPIResourceSearch];
}

- (NSString*) httpMethod {
    return TWAPIHTTPMethodGET;
}

- (void) dealloc {
    [_type release];
    [_query release];
    [super dealloc];
}

@end
