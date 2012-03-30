//
//  Player.h
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextureManager.h"

@interface Player : NSObject {
  TextureManager *_textureManager;
}
- (void) drawWithTimedDelta:(double)d atX:(int)x andY:(int)y;
@end
