//
//  TWViewController.m
//  iphone-sdk
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

#import "TWViewController.h"
#import "TWAPILyrics.h"

@interface TWViewController ()

@property (nonatomic, retain) TWAPIContext *context;
@property (nonatomic, retain) TWAPILyrics *lyrics;

@end

@implementation TWViewController

@synthesize context = _context;
@synthesize lyrics = _lyrics;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.context = [[TWAPI sharedApi] getLyricsForArtist:@"Of Montreal"
                                                   title:@"An Eluardian Instance"
                                                delegate:self];
    
}

- (void) dealloc {
    [[TWAPI sharedApi] cancelRequest:_context];
    [_context release];
    [super dealloc];
}

- (void) receivedResponse:(id)response context:(TWAPIContext*)context {
    self.lyrics = response;
    [self.tableView reloadData];
}

- (void) failedWithContext:(TWAPIContext*)context error:(NSError*)error {
    NSLog(@"Error code: %d", error.code);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    return self.lyrics.lines.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellIdentifier = @"TableCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }

    TWAPILyricLine *line = [self.lyrics.lines objectAtIndex:indexPath.row];

    cell.textLabel.text = [line text];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", [line timestamp]];
    
    return cell;
}

@end
