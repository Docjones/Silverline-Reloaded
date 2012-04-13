//
//  World.m
//  Silverline-Reloaded
//
//  Created by Marc Rink on 29.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OpenGL/gl.h>
#import "World.h"

@implementation World

- (id)init
{
  self = [super init];
  if (self) {
    _textureManager=[TextureManager sharedManager];
    _map=[[Map alloc] init];
	  _myAppDelegate=(AppDelegate *)[[NSApplication sharedApplication] delegate];
  }
  return self;
}

- (void) draw:(NSRect)rect withTimedDelta:(double)d {
  GLint *t;
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, [_textureManager textureByName:@"blocks"]);
  glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

  for (int x=0; x<[_map getWidth] ; x++) {
    for (int y=0; y<[_map getHeight] ; y++) {
      GLint v[] = { 
        16*x   ,16*y,
        16*x+16,16*y,
        16*x+16,16*y+16,
        16*x   ,16*y+16
      };
      
      t=[_textureManager getBlockWithNumber:[_map getBlockAtX:x andY:y]];
      
      glVertexPointer(2, GL_INT, 0, v);
      glTexCoordPointer(2, GL_INT, 0, t);
      glDrawArrays(GL_QUADS, 0, 4);
      
    }
  }
}

- (void)dealloc {
  [_map release];
  [super dealloc];
}
@end
