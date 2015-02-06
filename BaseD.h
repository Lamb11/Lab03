//
//  BaseD.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

extern int valorNuevo;

@interface BaseD : NSObject
{
    NSString *databasePath;
}

+(BaseD*)getSharedInstance;

-(BOOL)createDB;
-(BOOL)saveData:(int)puntos fecha:(NSString*)fecha;
-(NSArray*) findByRegisterNumber:(NSString*)registerNumber;
-(NSArray*) listado;
-(NSMutableArray*) listar;

@end