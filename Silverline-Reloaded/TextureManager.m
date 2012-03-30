//
//  TextureManager.h
//  opengl-test
//
//  Created by Marc Rink on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TextureManager.h"
#import "TextureObject.h"
#import <OpenGL/glu.h>

#define TILE_WIDTH  16
#define TILE_HEIGTH 16

@implementation TextureManager

+ (TextureManager*)sharedManager {
  static TextureManager* magTextureManager = nil;
  
  if( !magTextureManager ) {
    magTextureManager = [[TextureManager alloc] init];
  }
  
  return magTextureManager;
}

-(id)init {
	self = [super init];
	if(self) {
		_textures = [[NSMutableArray alloc]init];
		return self;
	}
	return nil;
}

-(void)cleanUp
{
  // Texture suchen
  for (id e in _textures) {
    GLuint tmp = [e textureID];
    glDeleteTextures(1, &tmp);
  }
    
	[_textures removeAllObjects];
	[_textures release];	
}

-(void)dealloc {
  [self cleanUp];
  [super dealloc];
}

- (GLuint) textureByName:(NSString *)textureName {
  return [self textureByName:textureName needsAlpha:NO];
}

- (GLuint) textureByName:(NSString *)textureName needsAlpha:(BOOL)needsAlpha {

  // Texture suchen
  for (id e in _textures) {
    if([[e textureName] isEqualToString:textureName]) {
      _currentTextureObject=e;
			return [e textureID];
    }
  }
  // nicht gefunden -> laden und einfuegen
  // Load the texture .png from the bundle file and get the Bitmap representativ off of it
  NSString* imageName = [[NSBundle mainBundle] pathForResource:textureName ofType:@"png"];
  NSImage *blocks = [[NSImage alloc ]initWithContentsOfFile:imageName];
  NSRect sz= NSMakeRect(0,0,[blocks size].width, [blocks size].height);
  NSBitmapImageRep *result=[[NSBitmapImageRep alloc] initWithCGImage:[blocks CGImageForProposedRect:&sz
                                                                                            context:NULL
                                                                                              hints:NULL]];
  [blocks release];
  
  // Check if ALPHA exists or has to be added
  int samplesPerPixel = [result samplesPerPixel];
  int pixelsWide = [result pixelsWide];
  int pixelsHigh = [result pixelsHigh];
  int bytesPerRow = [result bytesPerRow];
  
  void * myData;
  if (samplesPerPixel==4 || needsAlpha==YES)  {
    samplesPerPixel=4;
    bytesPerRow=pixelsWide*samplesPerPixel;
    // Setup Rendering area
    CGRect rect = {{0, 0}, {pixelsWide, pixelsHigh}};
    myData = calloc(pixelsWide * samplesPerPixel, pixelsHigh);
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGContextRef myBitmapContext = CGBitmapContextCreate (myData,
                                                          pixelsWide, pixelsHigh, 8,
                                                          bytesPerRow, space,
                                                          kCGBitmapByteOrder32Host |
                                                          kCGImageAlphaPremultipliedFirst);
    
    CGContextSetBlendMode(myBitmapContext, kCGBlendModeCopy);
    CGContextDrawImage(myBitmapContext, rect, [result CGImage]);
    CGContextRelease(myBitmapContext);
    CGColorSpaceRelease(space);
  }
  
  glMatrixMode(GL_TEXTURE);
  glLoadIdentity();
  glScalef(1/(float)pixelsWide, 1/(float)pixelsHigh, 1); // scaling the texture to get pixel coordinates  
  	
  glMatrixMode(GL_MODELVIEW);
  glPixelStorei(GL_UNPACK_ROW_LENGTH, (int)bytesPerRow/(int)samplesPerPixel); 
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);   
  
  GLuint tmpTexture;
  glGenTextures (1, &tmpTexture);
  
  glBindTexture(GL_TEXTURE_2D, tmpTexture); 
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER, GL_NEAREST); // Blurry mode OFF
  glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER, GL_NEAREST); // Blurry mode OFF
  
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);   // Clamped to 0.0 or 1.0
  glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
  
  glTexImage2D(GL_TEXTURE_2D,0,
               (samplesPerPixel==4)?GL_RGBA8:GL_RGB,
               pixelsWide,
               pixelsHigh,
               0,
               (samplesPerPixel==4)?GL_BGRA_EXT:GL_RGB,
               (samplesPerPixel==4)?GL_UNSIGNED_INT_8_8_8_8_REV:GL_UNSIGNED_BYTE,
               (samplesPerPixel==4)?myData:[result bitmapData]);
	
	//Neues Textureobjekt erzeugen
	TextureObject *t = [[TextureObject alloc]init];
	[t setTextureID:tmpTexture];
	[t setTextureName:textureName];
  [t setWidth:pixelsWide];
  [t setHeight:pixelsHigh];
	[_textures addObject:t];
	_currentTextureObject=t;

  [result release];
	[t release];
  
	return tmpTexture;	
}

- (GLint *)getTileX:(int)x Y:(int)y {
  static GLint *t=NULL;
  if (!t) {
    t=malloc(sizeof(GLint)*8);
  }
  t[0]=TILE_WIDTH*x;            t[1]=TILE_HEIGTH*y;
  t[2]=TILE_WIDTH*x+TILE_WIDTH; t[3]=TILE_HEIGTH*y;
  t[4]=TILE_WIDTH*x+TILE_WIDTH; t[5]=TILE_HEIGTH*y+TILE_HEIGTH;
  t[6]=TILE_WIDTH*x;            t[7]=TILE_HEIGTH*y+TILE_HEIGTH;
  return t;
}

- (GLint *)getBlockWithNumber:(int)b {
  static GLint *t=NULL;
  if (!t) {
    t=malloc(sizeof(GLint)*8);
  } 
  int x=b%([_currentTextureObject width]/TILE_WIDTH), y=b/([_currentTextureObject width]/TILE_WIDTH);	

  t[0]=TILE_WIDTH*x;            t[1]=TILE_HEIGTH*y;
  t[2]=TILE_WIDTH*x+TILE_WIDTH; t[3]=TILE_HEIGTH*y;
  t[4]=TILE_WIDTH*x+TILE_WIDTH; t[5]=TILE_HEIGTH*y+TILE_HEIGTH;
  t[6]=TILE_WIDTH*x;            t[7]=TILE_HEIGTH*y+TILE_HEIGTH;
  return t;
}

- (GLint *)getVertexPositionForBlock:(int)b {
  int x=0,y=0;
  
  static GLint *v=NULL;
  if (!v) {
    v=malloc(sizeof(GLint)*8);
  }
  v[0]=TILE_WIDTH*x;            v[1]=TILE_HEIGTH*y;
  v[2]=TILE_WIDTH*x+TILE_WIDTH; v[3]=TILE_HEIGTH*y;
  v[4]=TILE_WIDTH*x+TILE_WIDTH; v[5]=TILE_HEIGTH*y+TILE_HEIGTH;
  v[6]=TILE_WIDTH*x;            v[7]=TILE_HEIGTH*y+TILE_HEIGTH;
  return v;
}

- (TextureObject*)textureObjectByID:(GLuint)textureID
{
	NSEnumerator *enumerator = [_textures objectEnumerator];
	TextureObject *element;
	while(element = [enumerator nextObject])
  {
		if([element textureID] == textureID)
		{		
			return element;
		}
  }
	return nil;
}

- (void)unloadTexture:(GLuint)textureID
{
	NSEnumerator *enumerator = [_textures objectEnumerator];
	TextureObject *element;
	while(element = [enumerator nextObject])
  {
		GLuint texID = [element textureID];
		if(texID == textureID)
		{
			GLuint tmpTexture = [element textureID];
			glDeleteTextures(1, &tmpTexture);
			[_textures removeObject:element];			
			return;
		}
  }
}

@end
