//
//  tObject.m
//  opengl-test
//
//  Created by Marc Rink on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "TextureObject.h"

@implementation TextureObject

@synthesize width,height;

- (id)init
{
	self = [super init];
	if(self)
	{
		return self;
	}
	return nil;	
}

- (NSString *)textureName 
{
  return _textureName;
}

- (void)setTextureName:(NSString *)value 
{
  if (_textureName != value) 
	{
    [_textureName release];
    _textureName = [value retain];
  }
}

- (GLuint)textureID
{
	return _textureID;	
}

- (void)setTextureID:(GLuint)newID
{
	_textureID =newID;
}

- (GLuint)wrapS 
{
  return _wrapS;
}

- (void)setWrapS:(GLuint)value 
{
	glBindTexture(GL_TEXTURE_2D, _textureID);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, value);
	_wrapS = value;
}

- (GLuint)wrapT 
{
  return _wrapT;
}

- (void)setWrapT:(GLuint)value 
{
	glBindTexture(GL_TEXTURE_2D, _textureID);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, value);
	_wrapT = value;
}

- (GLuint)minFilter 
{
  return _minFilter;
}

- (void)setMinFilter:(GLuint)value 
{
	glBindTexture(GL_TEXTURE_2D, _textureID);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, value );
	_minFilter = value;
}

- (GLuint)magFilter 
{
  return _magFilter;
}

- (void)setMagFilter:(GLuint)value 
{
	glBindTexture(GL_TEXTURE_2D, _textureID);
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, value );
	_magFilter = value;
}

- (GLuint)envParam 
{
  return _envParam;
}

- (void)setEnvParam:(GLuint)value 
{
	glBindTexture(GL_TEXTURE_2D, _textureID);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, value);
	_envParam = value;
}

@end
