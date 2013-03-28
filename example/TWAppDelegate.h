//
//  TWAppDelegate.h
//  ios-sdk
//
//  Created by Andrew McSherry on 3/27/13.
//  Copyright (c) 2013 TuneWiki, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWViewController;

@interface TWAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TWViewController *viewController;

@end
