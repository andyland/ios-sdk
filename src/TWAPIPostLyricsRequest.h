//
//  TWAPIPostLyricsRequest.h
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import "TWAPILyricRequest.h"
#import "TWAPIDelegate.h"
#import "TWAPILyrics.h"

/*
 * TODO: This doesn't work yet
 */
@interface TWAPIPostLyricsRequest : TWAPILyricRequest

/*
 * Posts lyrics
 *
 */
+ (TWAPIPostLyricsRequest*) postLyrics:(TWAPILyrics*) lyrics
                              delegate:(id<TWAPIDelegate>) delegate;

@end
