//
//  TWAPISongSearchResult.m
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

#import "TWAPISearchResult.h"

@implementation TWAPISearchResult

@synthesize hasMore = _hasMore;
@synthesize results = _results;

+ (TWAPISearchResult*) searchResultWithJSON:(NSData*)json {
    TWAPISearchResult *result = [[TWAPISearchResult new] autorelease];

    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:json
                                                options:0
                                                  error:&error];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary*) object;

        result.hasMore = [[dict valueForKey:@"hasMore"] boolValue];
        NSString *type = [dict valueForKey:@"type"];

        NSArray *jsonResults = [dict valueForKey:@"results"];
        if ([@"songs" isEqualToString:type] ||
            [@"lyrics" isEqualToString:type] ||
            [@"artistsongs" isEqualToString:type] ||
            [@"artists" isEqualToString:type]) {
            NSMutableArray *songs = [NSMutableArray array];
            for (NSDictionary *songDict in jsonResults) {
                TWAPIMusicSearchHit *song = [[TWAPIMusicSearchHit new] autorelease];
                song.playCount = [[songDict valueForKey:@"playcount"] unsignedIntegerValue];
                song.score = [[songDict valueForKey:@"score"] doubleValue];
                NSDictionary *artistDict = [songDict valueForKey:@"artist"];
                song.artist = [artistDict valueForKey:@"name"];
                NSDictionary *titleDict = [songDict valueForKey:@"song"];
                song.title = [titleDict valueForKey:@"name"];
                [songs addObject:song];
            }
            result.results = songs;
        } else if ([@"hashtags" isEqualToString:type] ||
                   [@"shares" isEqualToString:type]) {
            NSMutableArray *comments = [NSMutableArray array];
            for (NSDictionary *commentDictOuter in jsonResults) {
                NSDictionary *commentDict = [commentDictOuter valueForKey:@"comment"];
                
                TWAPICommentHit *comment = [[TWAPICommentHit new] autorelease];
                comment.commentId = [commentDict valueForKey:@"id"];
                comment.text = [commentDict valueForKey:@"text"];

                NSDictionary *shareDict = [commentDict valueForKey:@"share"];
                TWAPIShare *share = [[TWAPIShare new] autorelease];
                share.shareId = [shareDict valueForKey:@"id"];
                share.commentCount = [[shareDict valueForKey:@"comment_count"] unsignedIntValue];
                share.likeCount = [[shareDict valueForKey:@"like_count"] unsignedIntValue];

                NSDictionary *shareUserDict = [shareDict valueForKey:@"user"];
                TWAPIUser *shareUser = [[TWAPIUser new] autorelease];
                shareUser.uuid = [shareUserDict valueForKey:@"id"];
                shareUser.handle = [shareUserDict valueForKey:@"name"];
                share.user = shareUser;

                NSDictionary *shareArtistDict = [shareDict valueForKey:@"artist"];
                share.artist = [shareArtistDict valueForKey:@"name"];

                NSDictionary *shareTitleDict = [shareDict valueForKey:@"song"];
                share.title = [shareTitleDict valueForKey:@"name"];

                comment.share = share;

                NSDictionary *commentUserDict = [commentDict valueForKey:@"user"];
                TWAPIUser *commentUser = [[TWAPIUser new] autorelease];
                commentUser.uuid = [commentUserDict valueForKey:@"id"];
                commentUser.handle = [commentUserDict valueForKey:@"name"];
                comment.user = commentUser;
                
                [comments addObject:comment];
            }
            result.results = comments;
        }
    }
    return result;
}

- (void) dealloc {
    [_results release];
    [super dealloc];
}

@end

#pragma mark 0

@implementation TWAPIMusicSearchHit

@synthesize playCount = _playCount;
@synthesize score = _score;
@synthesize artist = _artist;
@synthesize title = _title;

- (void) dealloc {
    [_artist release];
    [_title release];
    [super dealloc];
}

@end

#pragma mark -

@implementation TWAPICommentHit

@synthesize commentId = _commentId;
@synthesize text = _text;
@synthesize share = _share;
@synthesize user = _user;

- (void) dealloc {
    [_commentId release];
    [_text release];
    [_share release];
    [_user release];
    [super dealloc];
}

@end

#pragma mark -

@implementation TWAPIShare

@synthesize shareId = _shareId;
@synthesize artist = _artist;
@synthesize title = _title;
@synthesize user = _user;
@synthesize likeCount = _likeCount;
@synthesize commentCount = _commentCount;

- (void) dealloc {
    [_shareId release];
    [_artist release];
    [_title release];
    [_user release];
    [super dealloc];
}

@end


#pragma mark -

@implementation TWAPIUser

@synthesize uuid = _uuid;
@synthesize handle = _handle;


- (void) dealloc {
    [_uuid release];
    [_handle release];
    [super dealloc];
}

@end