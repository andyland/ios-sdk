//
//  TWTWAPIStandardResponse.m
//  ios-sdk
//
//  Created by Andrew McSherry on 4/4/13.
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

#import "TWTWAPIStandardResponse.h"
#import "TWAPI.h"

@implementation TWTWAPIStandardResponse

@synthesize ok = _ok;
@synthesize acknowledged = _acknowledged;
@synthesize error = _error;

+ (TWTWAPIStandardResponse*) responseWithJSON:(NSData*)json {
    TWTWAPIStandardResponse *response = [[TWTWAPIStandardResponse new] autorelease];

    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:json
                                                options:0
                                                  error:&error];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*) object;

        response.ok = [[dict valueForKey:@"ok"] boolValue];
        response.acknowledged = [[dict valueForKey:@"acknowledged"] boolValue];
        NSDictionary *errorDict = [dict valueForKey:@"error"];
        if (error) {
            response.error = [NSError errorWithDomain:TWAPIErrorDomain
                                                 code:[[errorDict valueForKey:@"code"] intValue]
                                             userInfo:[NSDictionary dictionaryWithObject:[errorDict valueForKey:@"message"]
                                                                                  forKey:NSLocalizedDescriptionKey]];
        }
    }
    return response;
}


- (void) dealloc {
    [_error release];
    [super dealloc];
}

@end
