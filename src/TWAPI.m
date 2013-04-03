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

NSString * const TWAPIResourceLyrics = @"lyrics";
NSString * const TWAPIErrorDomain = @"TWAPIErrorDomain";

NSString * const TWAPIScheme = @"http";
NSString * const TWAPIHost = @"twapi.tunewiki.com";

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

- (TWAPIContext*) getLyricsForArtist:(NSString*) artist
                               title:(NSString*)title
                              language:(NSString *)language
                            delegate:(id<TWAPIDelegate>)delegate {
    NSString *resourcePath = [NSString stringWithFormat:@"/%@/%@/%@",
                                                       TWAPIResourceLyrics,
                                                       [artist urlEncodedString],
                                                       [title urlEncodedString]];
    NSURL *url = [self urlWithHTTPMethod:@"GET"
                                  scheme:TWAPIScheme
                                    host:TWAPIHost
                            resourcePath:resourcePath
                               getParams:nil
                              postParams:nil];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLCacheStorageNotAllowed
                                                       timeoutInterval:30];

    if (language) {
        [request setValue:language forHTTPHeaderField:@"Accept-Language"];
    }

    TWAPIContext *context = [[[TWAPIContext alloc] init] autorelease];
    context.resource = TWAPIResourceLyrics;
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

    if ([context.resource isEqualToString:TWAPIResourceLyrics]) {
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

- (NSURL*) urlWithHTTPMethod:(NSString*)method
                      scheme:(NSString*)scheme
                        host:(NSString*)host
                resourcePath:(NSString*)resourcePath
                   getParams:(NSDictionary*)getParams
                  postParams:(NSDictionary*)postParams {
    NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@://%@%@?", scheme, host, resourcePath];

    [requestUrl appendFormat:@"apiKey=%@", self.apiKey];
    
    NSString *timestamp = [NSString stringWithFormat:@"%u", (NSUInteger)[[NSDate date] timeIntervalSince1970]];
    [requestUrl appendFormat:@"&ts=%@", timestamp];
    


    NSMutableArray *paramValues = [NSMutableArray arrayWithObjects:self.apiKey, timestamp, nil];
    
    for (NSString *key in getParams) {
        NSString *value = [getParams valueForKey:key];
        [paramValues addObject:key];
        [requestUrl appendFormat:@"&%@=%@", key, value];
    }
    for (NSString *key in postParams) {
        [paramValues addObject:[postParams objectForKey:key]];
    }
    [requestUrl appendFormat:@"&apiPass=%@", [self apiPassForHTTPMethod:method
                                                           resourcePath:resourcePath
                                                            paramValues:paramValues]];
    return [NSURL URLWithString:requestUrl];
}

- (NSString*) apiPassForHTTPMethod:(NSString*)method
                      resourcePath:(NSString*)resourcePath
                       paramValues:(NSArray*)paramValues {
    NSMutableString *toHash = [NSMutableString string];//]WithFormat:@"%@\\n%@\\n", method, resourcePath];
    for (NSString *value in paramValues) {
        [toHash appendString:value];
    }
    return [toHash hmacStringWithSecret:self.apiSecret];
}

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
