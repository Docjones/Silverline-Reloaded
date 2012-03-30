//
//  TextureManager.h
//  opengl-test
//
//  Created by Marc Rink on 28.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TextureObject.h"

@interface TextureManager:NSObject {
	NSMutableArray	*_textures;								// Array mit geladenen textur-Objekten
  TextureObject *_currentTextureObject;
}

+ (TextureManager*)sharedManager;						// Instanz
- (GLuint)textureByName:(NSString *)textureName;			// Liefert eine Textur-ID anhand des Pfads (Dateiname)
- (GLuint) textureByName:(NSString *)textureName needsAlpha:(BOOL)needsAlpha ; // fügt ALPHA Kanal zu
- (TextureObject*)textureObjectByID:(GLuint)textureID;	// Liefert ein Textur-Objekt anhand der ID
- (GLint *)getTileX:(int)x Y:(int)y;
- (GLint *)getBlockWithNumber:(int)b;
- (void)unloadTexture:(GLuint)textureID;					// Loescht die Textur mit der ID
- (void)cleanUp;											// Loescht alle Texturen
@end
