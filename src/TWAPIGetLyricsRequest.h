//
//  TWAPIGetLyricsRequest.h
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
