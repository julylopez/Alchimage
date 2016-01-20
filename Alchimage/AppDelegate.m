//
//  AppDelegate.m
//  Alchimage
//
//  Created by Lopez, Julio on 8/19/15.
//
//

#import "AppDelegate.h"
#include "RootViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) IBOutlet RootViewController *rootViewController;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    NSRect frame = [self.window frame];
    frame.size = CGSizeMake(400, 290);
    [self.window setFrame: frame display: YES animate: NO];
    [self.window setBackgroundColor:[NSColor colorWithRed:240.0/255.0 green:113.0/255.0 blue:113.0/255.0 alpha:0.9]];
    [self.window.contentView addSubview:self.rootViewController.view];
    self.rootViewController.view.frame = CGRectMake(0, 0, 400, 290);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
}

@end
