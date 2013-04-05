//
//  TWAPIGetLyricsRequest.m
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

#import "TWAPIGetLyricsRequest.h"
#import "TWAPILyrics.h"
#import "TWAPI.h"

@implementation TWAPIGetLyricsRequest

+ (TWAPIGetLyricsRequest*) getLyricsRequestForArtist:(NSString*) artist
                                               title:(NSString*)title
                                            language:(NSString *)language
                                            delegate:(id<TWAPIDelegate>)delegate {

    TWAPIGetLyricsRequest *request = [[[TWAPIGetLyricsRequest alloc] initWithArtist:artist
                                                                              title:title
                                                                           language:language
                                                                           delegate:delegate] autorelease];
    return request;
}

- (NSString*) httpMethod {
    return TWAPIHTTPMethodGET;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TWAPILyrics *lyrics = [TWAPILyrics lyricsWithJSON:self.data];
    lyrics.artist = self.artist;
    lyrics.title = self.title;
    lyrics.language = self.language;
    
    [self.delegate receivedResponse:lyrics];
    self.delegate = nil;
}

@end
