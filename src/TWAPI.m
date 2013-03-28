//
//  TWAPI.m
//  SDK
//
//  Created by Andrew McSherry on 3/27/13.
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

#import "TWAPI.h"
#import "TWAPILyrics.h"
#import "NSString+TWUtils.h"

NSString * const TWAPIMethodLyrics = @"lyrics";
NSString * const TWAPIErrorDomain = @"TWAPIErrorDomain";

NSString * const TWAPIScheme = @"http://";
NSString * const TWAPIHost = @"betaapi.tunewiki.com";
NSString * const TWAPIPathPrefix = @"tunewiki-public-api";

#pragma mark -

@interface TWAPI()

@property (nonatomic, retain) NSMutableArray *requests;

- (TWAPIContext*) contextForConnection:(NSURLConnection*)connection;
- (void) clearContext:(TWAPIContext*)context;

@end

#pragma mark -

@implementation TWAPI

@synthesize requests = _requests;

#pragma mark -
#pragma mark Singleton Support

static TWAPI *api = nil;

+(TWAPI*) sharedApi {
    @synchronized(self) {
		if (api == nil) {
            api = [[self alloc] init];
		}
	}
	return api;
}

- (id) init {
    if (self = [super init]) {
        _requests = [[NSMutableArray alloc] init];
    }
    return self;
}

- (oneway void) release { }

- (id) autorelease { return self; }

#pragma mark -
#pragma mark Public Methods

- (TWAPIContext*) getLyricsForArtist:(NSString*) artist title:(NSString*)title delegate:(id<TWAPIDelegate>)delegate {
    NSString *urlPath = [NSString stringWithFormat:@"%@%@/%@/%@/%@/%@",
                                                   TWAPIScheme,
                                                   TWAPIHost,
                                                   TWAPIPathPrefix,
                                                   TWAPIMethodLyrics,
                                                   [artist encodeString],
                                                   [title encodeString]];
    NSLog(@"%@", urlPath);
    NSURL *url = [NSURL URLWithString:urlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLCacheStorageNotAllowed
                                         timeoutInterval:30];

    TWAPIContext *context = [[[TWAPIContext alloc] init] autorelease];
    context.method = TWAPIMethodLyrics;
    context.delegate = delegate;
    context.connection = [NSURLConnection connectionWithRequest:request
                                                       delegate:self];

    [self.requests addObject:context];

    return context;
}

- (void) cancelRequest:(TWAPIContext*)context {
    context.delegate = nil;
    [context.connection cancel];
    [self clearContext:context];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate protocol support

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int status = [httpResponse statusCode];

        TWAPIContext *context = [self contextForConnection:connection];

        if (!((status >= 200) && (status < 300))) {
            NSError *error = [NSError errorWithDomain:TWAPIErrorDomain
                                                 code:status
                                             userInfo:nil];
            [context.delegate failedWithContext:context
                                          error:error];
            [self clearContext:context];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    TWAPIContext *context = [self contextForConnection:connection];

    if ([context.method isEqualToString:TWAPIMethodLyrics]) {
        TWAPILyrics *lyrics = [[[TWAPILyrics alloc] initWithJSON:context.data] autorelease];
        [context.delegate receivedResponse:lyrics context:context];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    TWAPIContext *context = [self contextForConnection:connection];
    if (nil == context.data) {
        context.data = [[data mutableCopy] autorelease];
    } else {
        [context.data appendData:data];
    }
}

#pragma mark -
#pragma mark Helpers

- (void) clearContext:(TWAPIContext*)context {
    [self.requests removeObject:context];
}

- (TWAPIContext*) contextForConnection:(NSURLConnection*)connection {
    for (TWAPIContext *context in self.requests) {
        if (context.connection == connection) {
            return context;
        }
    }
    return nil;
}

@end
