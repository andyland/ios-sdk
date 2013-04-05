//
//  TWAPIPostLyricsRequest.m
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

#import "TWAPIPostLyricsRequest.h"
#import "TWAPI.h"

@interface TWAPIPostLyricsRequest()

@property (nonatomic, retain) TWAPILyrics *lyrics;

@end

#pragma mark -

@implementation TWAPIPostLyricsRequest

@synthesize lyrics = _lyrics;

+ (TWAPIPostLyricsRequest*) postLyricsRequest:(TWAPILyrics*) lyrics
                                 withDelegate:(id<TWAPIDelegate>) delegate {

    TWAPIPostLyricsRequest *request = [[[TWAPIPostLyricsRequest alloc] initWithArtist:lyrics.artist
                                                                                title:lyrics.title
                                                                             language:lyrics.language
                                                                             delegate:delegate] autorelease];

    request.lyrics = lyrics;

    return request;
}

- (NSData*) postBody {
    return [self.lyrics jsonData];
}

- (NSDictionary*) postParams {
    return [NSDictionary dictionaryWithObject:[[[NSString alloc] initWithData:[self.lyrics jsonData]
                                                                     encoding:NSUTF8StringEncoding] autorelease]
                                       forKey:@"value"];
}

- (NSString*) httpMethod {
    return TWAPIHTTPMethodPOST;
}

- (void) dealloc {
    [_lyrics release];
    [super dealloc];
}

@end
