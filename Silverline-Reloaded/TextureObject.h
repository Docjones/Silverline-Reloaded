//
//  TextureObject.h
//  opengl-test
//
//  Created by Marc Rink on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <OpenGL/gl.h>

@interface TextureObject  :NSObject
{
	GLuint	 _textureID;			// Texture ID
	GLuint	_wrapS;					// Wrap S GL_CLAMP GL_REPEAT GL_CLAMP_TO_EDGE GL_CLAMP_TO_BORDER
	GLuint	_wrapT;					// Wrap T GL_CLAMP GL_REPEAT GL_CLAMP_TO_EDGE GL_CLAMP_TO_BORDER
	
	GLuint	_minFilter;				// Min Filter GL_NEAREST GL_LINEAR GL_NEAREST_MIPMAP_NEAREST GL_LINEAR_MIPMAP_NEAREST GL_NEAREST_MIPMAP_LINEAR GL_LINEAR_MIPMAP_LINEAR
	GLuint	_magFilter;				// Mag Filter GL_NEAREST GL_LINEAR
	
	GLuint	_envParam;				// Env Paramter	GL_MODULATE (standard) GL_DECAL GL_BLEND GL_REPLACE
	NSString *_textureName;			// Texture Name (Filename)
  
  int     width;
  int     height;
}

//@property GLuint _textureID;
//@property GLuint _wrapS;
//@property GLuint _wrapT;
//@property GLuint _minFilter;
//@property GLuint _magFilter;
//@property GLuint _envParam;
//@property NSString *_textureName;

@property int width;
@property int height;


/**
 Getter und Setter
 **/
- (void)setTextureID:(GLuint)newID;
- (GLuint)textureID;

- (NSString *)textureName;
- (void)setTextureName:(NSString *)value;

- (GLuint)wrapS;
- (void)setWrapS:(GLuint)value;

- (GLuint)wrapT;
- (void)setWrapT:(GLuint)value;

- (GLuint)minFilter;
- (void)setMinFilter:(GLuint)value;

- (GLuint)magFilter;
- (void)setMagFilter:(GLuint)value;

- (GLuint)envParam;
- (void)setEnvParam:(GLuint)value;


@end
