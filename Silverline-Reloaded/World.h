//
//  World.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "TextureManager.h"

@class AppDelegate;

@interface World : NSObject {
  Map *_map;
  TextureManager *_textureManager;
  NSMutableArray *_players;
  AppDelegate *_myAppDelegate;
}


- (void) draw:(NSRect)rect withTimedDelta:(double)d;
@end
