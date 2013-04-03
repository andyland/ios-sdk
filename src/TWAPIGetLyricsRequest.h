//
//  TWAPIGetLyricsRequest.h
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWAPILyricRequest.h"

@interface TWAPIGetLyricsRequest : TWAPILyricRequest

/*
 * Creates a lyric request for the artist, title and language
 *
 * Language is formed with the format of the ISO 639-1 language code concatenated
 * optionally concatented with a hyphen and the ISO 3166-1 country code
 * Thus, valid values would be @"en", @"zh-CN", @"es-BR", @"es", etc.
 *
 * Pass nil for language to get lyrics in the song's native language
 */
+ (TWAPIGetLyricsRequest*) getLyricsRequestForArtist:(NSString*) artist
                                               title:(NSString*)title
                                            language:(NSString *)language
                                            delegate:(id<TWAPIDelegate>)delegate;

@end
