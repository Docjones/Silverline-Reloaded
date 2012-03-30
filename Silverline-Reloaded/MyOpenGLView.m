//
//  MyOpenGLView.m
//  Silverline Server
//
//  Created by Marc on 23.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MyOpenGLView.h"

@implementation MyOpenGLView

#define TARGET_FPS 60.0f

////////////////////////////////////////////
// OpenGL
////////////////////////////////////////////
- (id)init {
  self = [super init];
  if (self) {
    //    _textureManager=[TextureManager sharedManager];
    _player=[[Player alloc] init];
    _world=[[World alloc] init];
  }
  return self;
}

- (void)awakeFromNib {
  //  _textureManager=[TextureManager sharedManager];
  _player=[[Player alloc] init];
  _world=[[World alloc] init];
}

- (void)dealloc {
  [_player release];
  [_world release];

  [super dealloc];
}

- (void) reshape {
  
  NSRect rect=[self bounds];
  
  glViewport(0, 0, (GLsizei) rect.size.width , (GLsizei) rect.size.height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  
  glOrtho(0, rect.size.width, rect.size.height, 0,-1,1); // heigth + zero exchanged (turn upside down) 
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

}

- (void) prepareOpenGL {
  [[self window] makeFirstResponder:self];
  
  // GLuint units;
  // glGetIntegerv(GL_MAX_TEXTURE_UNITS, &units);
  // NSLog(@"Texture Units: %d",units);
  // => 8 Units
  
  glDisable(GL_DEPTH_TEST);
  glEnable(GL_BLEND);
  glEnable(GL_TEXTURE_2D);
  
  // activate pointer to vertex & texture array
  glEnableClientState(GL_VERTEX_ARRAY);
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  
  aTimer=[[NSTimer timerWithTimeInterval:1.0f/TARGET_FPS target:self selector:@selector(animationTrigger:) userInfo:self repeats:YES] retain];	
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSEventTrackingRunLoopMode];
  [[NSRunLoop currentRunLoop] addTimer:aTimer forMode:NSDefaultRunLoopMode];
  
  startTime=0.0f;
  lastTime=0.0f;
  framedelta=0.0f;
  delta=0.0f;
}	

-(void)animationTrigger:(NSTimer*)timer {
  [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
  lastTime=(double)CFAbsoluteTimeGetCurrent();
  delta=(lastTime-startTime);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor4f(1.0,1.0,1.0,1.0);

  [_world draw:rect withTimedDelta:delta];
  glBlendFunc(GL_ONE,GL_ONE_MINUS_SRC_ALPHA);
  [_player drawWithTimedDelta:delta atX:10 andY:10];
  
  glFlush();
  startTime=lastTime;
  //  [FPS setDoubleValue:1.0f/delta];
}
@end
