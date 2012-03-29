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

@interface MyOpenGLView : NSOpenGLView   {
  // OpenGL
  double startTime;
  double lastTime;
  double delta;
  double framedelta;
  
  TextureManager *_textureManager;
  NSTimer *aTimer;
}

// OpenGL
-(void)draw:(double)d;

@end
