//
//  MyOpenGLView.h
//  Silverline Server
//
//  Created by Marc on 23.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import "TextureManager.h"
#import "World.h"
#import "Player.h"

@interface MyOpenGLView : NSOpenGLView   {
  // OpenGL
  double startTime;
  double lastTime;
  double delta;
  double framedelta;
  
  World *_world;
  NSMutableArray *_players;
  NSTimer *aTimer;
}

@end
