//
//  TWAPIPostLyricsRequest.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import "TWAPIPostLyricsRequest.h"

@interface TWAPIPostLyricsRequest()

@property (nonatomic, retain) TWAPILyrics *lyrics;

@end

#pragma mark -

@implementation TWAPIPostLyricsRequest

@synthesize lyrics = _lyrics;

+ (TWAPIPostLyricsRequest*) postLyrics:(TWAPILyrics*) lyrics
                              delegate:(id<TWAPIDelegate>) delegate {

    TWAPIPostLyricsRequest *request = [[[TWAPIPostLyricsRequest alloc] initWithArtist:lyrics.artist
                                                                                title:lyrics.title
                                                                             language:lyrics.language
                                                                             delegate:delegate] autorelease];

    request.lyrics = lyrics;

    return request;
}

- (NSString*) httpMethod {
    return @"POST";
}

- (void) dealloc {
    [_lyrics release];
    [super dealloc];
}

@end
