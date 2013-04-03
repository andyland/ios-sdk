//
//  TWAPIGetLyricsRequest.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import "TWAPIGetLyricsRequest.h"
#import "TWAPILyrics.h"

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
    return @"GET";
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
