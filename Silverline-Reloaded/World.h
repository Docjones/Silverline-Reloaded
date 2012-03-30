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

@interface World : NSObject {
  Map *_map;
  TextureManager *_textureManager;
}

- (void) draw:(NSRect)rect withTimedDelta:(double)d;
@end
