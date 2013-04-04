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

#import "TWAPIRequest.h"
#import "NSString+TWUtils.h"
#import "TWAPI.h"

#pragma mark -

@interface TWAPIRequest()


#pragma mark -

- (NSString*) apiPassForHTTPMethod:(NSString*)method
                      resourcePath:(NSString*)resourcePath
                       paramValues:(NSArray*)paramValues;

- (NSURL*) urlWithHTTPMethod:(NSString*)method
                      scheme:(NSString*)scheme
                        host:(NSString*)host
                resourcePath:(NSString*)resourcePath
                   getParams:(NSDictionary*)getParams
                  postParams:(NSDictionary*)postParams;

@end

#pragma mark -

@implementation TWAPIRequest

@synthesize connection = _connection;
@synthesize delegate = _delegate;
@synthesize data = _data;

#pragma mark -
#pragma mark Public Methods

- (id) initWithDelegate:(id<TWAPIDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
    }
    return self;
}

- (void) start {
    NSString *httpMethod = [self httpMethod];
    
    NSURL *url = [self urlWithHTTPMethod:httpMethod
                                  scheme:TWAPIScheme
                                    host:TWAPIHost
                            resourcePath:[self resourcePath]
                               getParams:[self getParams]
                              postParams:[self postParams]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    NSDictionary *headers = [self httpHeaders];
    if (headers) {
        [request setAllHTTPHeaderFields:headers];
    }

    if ([@"POST" isEqualToString:httpMethod]) {
        NSData *postBody = [self postBody];
        if (postBody) {
            [request setHTTPBody:postBody];
        }
    }
    
    self.connection = [NSURLConnection connectionWithRequest:request
                                                    delegate:self];
    [self.connection start];
}

- (void) cancel {
    self.delegate = nil;
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate protocol support

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        int status = [httpResponse statusCode];

        if (!((status >= 200) && (status < 300))) {
            NSError *error = [NSError errorWithDomain:TWAPIErrorDomain
                                                 code:status
                                             userInfo:nil];
            [self.delegate failedWithError:error];
            self.delegate = nil;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (self.data) {
        [self.data appendData:data];
    } else {
        self.data = [[data mutableCopy] autorelease];
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

    [requestUrl appendFormat:@"apiKey=%@", TWAPIKey];
    
    NSString *timestamp = [NSString stringWithFormat:@"%u", (NSUInteger)[[NSDate date] timeIntervalSince1970]];
    [requestUrl appendFormat:@"&ts=%@", timestamp];
    


    NSMutableArray *paramValues = [NSMutableArray arrayWithObjects:TWAPIKey, timestamp, nil];
    
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
    return [toHash hmacStringWithSecret:TWAPISecret];
}

#pragma mark -
#pragma mark Subclass Defaults


- (NSDictionary*) getParams {
    return nil;
}

- (NSDictionary*) postParams {
    return nil;
}

- (NSDictionary*) httpHeaders {
    return nil;
}

- (NSString*) httpMethod {
    return nil;
}

-(NSString*) resourcePath {
    return nil;
}

- (NSData*) postBody {
    return nil;
}

- (void) dealloc {
    [_connection release];
    [_data release];
    [super dealloc];
}

@end
