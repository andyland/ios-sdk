//
//  TWAPILyricRequest.h
//  ios-sdk
//
//  Created by Andrew McSherry on 4/3/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TWAPIRequest.h"

@interface TWAPILyricRequest : TWAPIRequest

@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *language;

- (id) initWithArtist:(NSString*)artist
                title:(NSString*)title
             language:(NSString*)language
             delegate:(id<TWAPIDelegate>)delegate;

@end
