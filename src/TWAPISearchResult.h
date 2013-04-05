//
//  TWAPISongSearchResult.h
//  ios-sdk
//
//  Created by Andrew McSherry on 4/5/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
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

@interface TWAPISearchResult : NSObject

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, copy) NSArray *results;

+ (TWAPISearchResult*) searchResultWithJSON:(NSData*)json;

@end

#pragma mark -

@interface TWAPIMusicSearchHit : NSObject

@property (nonatomic, assign) NSUInteger playCount;
@property (nonatomic, assign) double score;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;

@end

#pragma mark -

@class TWAPIUser;
@class TWAPIShare;

@interface TWAPICommentHit : NSObject

@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) TWAPIShare *share;
@property (nonatomic, retain) TWAPIUser *user;

@end

#pragma mark -


@interface TWAPIShare : NSObject

@property (nonatomic, copy) NSString *shareId;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger likeCount;
@property (nonatomic, assign) NSUInteger commentCount;
@property (nonatomic, retain) TWAPIUser *user;

@end

#pragma mark -

@interface TWAPIUser : NSObject

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *handle;

@end