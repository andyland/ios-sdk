//
//  TWAPILyricRequest.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
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
                                      [self.artist urlEncodedString],
                                      [self.title urlEncodedString]];
}

- (NSDictionary*) headers {
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
