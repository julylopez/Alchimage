//
//  UIElements.m
//  Alchemator
//
//  Created by Lopez, Julio on 8/19/15.
//
//

#import "UIElements.h"

@implementation UIElements

-(NSTextField *)setLabelTitle:(NSString *)title xCoord:(CGFloat)x yCoord:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [textField setStringValue:title];
    [textField setAlignment:NSCenterTextAlignment];
    [textField setEditable:NO];
    [textField setDrawsBackground:NO];
    [textField setSelectable:NO];
    [textField setBezeled:NO];
    return textField;
}

@end

