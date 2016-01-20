//
//  RootViewController.m
//  Alchimage
//
//  Created by Lopez, Julio on 8/19/15.
//
//
#import "RootViewController.h"
#import "UIElements.h"
#import <AppKit/AppKit.h>

NSString *const fileKeyConst = @"fileName";
NSString *const widthConst = @"width";
NSString *const heightConst = @"height";
NSString *const sourceConst = @"Source";
NSString *const destinationConst = @"Destination";

@interface RootViewController (){
    
    NSString *sourcePath;
    NSString *destinationPath;
    NSMutableArray *sourceArray;
    NSMutableArray *destinationArray;
    NSProgressIndicator *progressIndicator;
    NSTextField *activityLabel;
    NSTextField *sourceFolderPath;
    NSTextField *destinationFolderPath;
}

@property (strong, nonatomic) id btnParam;
@property (strong, nonatomic) NSTextField *titleLabel;
@property (strong, nonatomic) NSButton *sourceFolderButton;
@property (strong, nonatomic) NSButton *destinationFolderButton;
@property (strong, nonatomic) NSButton *initiateButton;

-(void)initiateCopy;
-(void)dialogBoxType:(id)sender;
-(void)startActivityIndicator;
-(void)stopActivityIndicator;
-(void)setDictionaryType:(NSString *)dictionaryType;

@property (weak) IBOutlet NSWindow *window;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIElements *element = [[UIElements alloc] init];
    self.titleLabel = [element setLabelTitle:@"Source folder (unzipped assets) / Destination folder (template assets)" xCoord:50 yCoord:210 width:300 height:50];
    [self.titleLabel setTextColor:[NSColor whiteColor]];
    [self.view addSubview:self.titleLabel];
    
    activityLabel = [element setLabelTitle:@"Ready for images!" xCoord:0 yCoord:-15 width:self.view.bounds.size.width height:50];
    [activityLabel setTextColor:[NSColor whiteColor]];
    [self.view addSubview:activityLabel];
    
    self.sourceFolderButton = [[NSButton alloc] initWithFrame:NSMakeRect(130, 170, 140, 50)];
    [self.sourceFolderButton setTitle: @"Source Folder"];
    [self.sourceFolderButton setButtonType:NSMomentaryLightButton];
    [self.sourceFolderButton setBezelStyle:NSRoundedBezelStyle];
    [self.sourceFolderButton setTarget:self];
    [self.sourceFolderButton setTag:1];
    [self.sourceFolderButton setAction:@selector(dialogBoxType:)];
    [self.view addSubview:self.sourceFolderButton];
    
    sourceFolderPath = [element setLabelTitle:@"Path to Source Folder" xCoord:0 yCoord:120 width:self.view.bounds.size.width height:50];
    [sourceFolderPath setTextColor:[NSColor whiteColor]];
    [self.view addSubview:sourceFolderPath];
    
    self.destinationFolderButton = [[NSButton alloc] initWithFrame:NSMakeRect(130, 100, 140, 50)];
    [self.destinationFolderButton setTitle: @"Destination Folder"];
    [self.destinationFolderButton setButtonType:NSMomentaryLightButton];
    [self.destinationFolderButton setBezelStyle:NSRoundedBezelStyle];
    [self.destinationFolderButton setTarget:self];
    [self.destinationFolderButton setTag:2];
    [self.destinationFolderButton setAction:@selector(dialogBoxType:)];
    [self.view addSubview:self.destinationFolderButton];
    
    destinationFolderPath = [element setLabelTitle:@"Path to Desination Folder" xCoord:0 yCoord:50 width:self.view.bounds.size.width height:50];
    [destinationFolderPath setTextColor:[NSColor whiteColor]];
    [self.view addSubview:destinationFolderPath];
    
    self.initiateButton = [[NSButton alloc] initWithFrame:NSMakeRect(130, 30, 140, 50)];
    [self.initiateButton setTitle: @"Start Alchimage"];
    [self.initiateButton setButtonType:NSMomentaryLightButton];
    [self.initiateButton setBezelStyle:NSRoundedBezelStyle];
    [self.initiateButton setTarget:self];
    [self.initiateButton setAction:@selector(initiateCopy)];
    [self.view addSubview:self.initiateButton];
}

#pragma mark - initiate alchimage

-(void)initiateCopy {
    
    [self setDictionaryType:sourceConst];
    [self setDictionaryType:destinationConst];
    
    [self startActivityIndicator];
    
    for (NSMutableDictionary *sourceDict in sourceArray){
        
        for (NSMutableDictionary *destDict in destinationArray) {
            
                if ([sourceDict valueForKey:heightConst] == [destDict valueForKey:heightConst] && [sourceDict valueForKey:widthConst] == [destDict valueForKey:widthConst]) {
                    [[NSFileManager defaultManager] replaceItemAtURL:[NSURL fileURLWithPath:[destDict valueForKey:fileKeyConst]] withItemAtURL:[NSURL fileURLWithPath:[sourceDict valueForKey:fileKeyConst]] backupItemName:@"backup" options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:nil];
            }
        }
    }
    [self stopActivityIndicator];
    [activityLabel setStringValue:@"Alchimage Complete"];
}

#pragma mark - Set dictionaries

-(void)setDictionaryType:(NSString *)dictionaryType{

    if ([dictionaryType isEqualTo:sourceConst]) {
        
        sourceArray = [[NSMutableArray alloc] init];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *sourceFiles = [fileManager contentsOfDirectoryAtPath:sourcePath error:nil];
        
        for (NSString *file in sourceFiles) {
            
            NSString *sourceFile = [sourcePath stringByAppendingPathComponent:file];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:sourceFile];
            
            if (!image) {
                continue;
            }
            
            NSImageRep *rep = [[image representations] objectAtIndex:0];
            
            NSDictionary *tempDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            sourceFile, fileKeyConst,
                                            [NSNumber numberWithLong:rep.pixelsWide], widthConst,
                                            [NSNumber numberWithLong:rep.pixelsHigh], heightConst,
                                            nil];
            [sourceArray addObject:tempDictionary];
            
            BOOL isDir;
            
            if (![fileManager fileExistsAtPath:sourceFile isDirectory:&isDir] || isDir) {
                continue;
            }
            
            NSError  *error  = nil;
            if (error) {
                
            }
        
        }

    } else {
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *destinationFiles = [fileManager contentsOfDirectoryAtPath:destinationPath error:nil];
        destinationArray = [[NSMutableArray alloc] init];
        
        for (NSString *file in destinationFiles) {
            
            NSString *sourceFile = [destinationPath stringByAppendingPathComponent:file];
            NSImage *image = [[NSImage alloc] initWithContentsOfFile:sourceFile];
            
            if (!image) {
                continue;
            }
            
            NSImageRep *rep = [[image representations] objectAtIndex:0];
            
            NSDictionary *tempDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            sourceFile, fileKeyConst,
                                            [NSNumber numberWithLong:rep.pixelsWide], widthConst,
                                            [NSNumber numberWithLong:rep.pixelsHigh], heightConst,
                                            nil];
            [destinationArray addObject:tempDictionary];
            
            BOOL isDir;
            
            if (![fileManager fileExistsAtPath:sourceFile isDirectory:&isDir] || isDir) {
                continue;
            }
            
            NSError  *error  = nil;
            if (error) {
                
            }
        }
    }
}

# pragma mark - Dialog Box

-(void)dialogBoxType:(id)sender {
    
    long boxType = [sender tag];
    
    if (boxType == 1) {
        
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanCreateDirectories:YES];
        [panel setCanChooseFiles:NO];
        
        [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                NSArray* urls = [panel URLs];
                for (NSURL *url in urls) {
                    sourcePath = [url path];
                    [sourceFolderPath setStringValue:[url path]];
                }
            }
        }];
        
    } else {
     
        NSOpenPanel* panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanCreateDirectories:YES];
        [panel setCanChooseFiles:NO];
        
        [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result){
            if (result == NSFileHandlingPanelOKButton) {
                NSArray* urls = [panel URLs];
                for (NSURL *url in urls) {
                    destinationPath = [url path];
                    [destinationFolderPath setStringValue:[url path]];
                }
            }
        }];
    }
}

#pragma mark - Activity Indicator

-(void)startActivityIndicator {
    
    [activityLabel setStringValue:@"Copying images..."];
    progressIndicator = [[NSProgressIndicator alloc] initWithFrame:CGRectMake(125, 17, 20, 20)];
    [progressIndicator setStyle:NSProgressIndicatorSpinningStyle];
    [progressIndicator displayIfNeeded];
    [self.view addSubview:progressIndicator];
    [progressIndicator startAnimation:self];
}

-(void)stopActivityIndicator {
    
    [progressIndicator stopAnimation:self];
    [progressIndicator removeFromSuperview];
    
}
@end