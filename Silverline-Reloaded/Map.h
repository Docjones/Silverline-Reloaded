//
//  Map.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAP_WIDTH 30
#define MAP_HEIGHT 23



@interface Map : NSObject {
}

-(int) getWidth;
-(int) getHeight;

-(int) getBlockAtX:(int)x andY:(int)y;
@end
