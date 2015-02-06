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

-(BOOL)crearDB;
-(BOOL)saveDB:(NSString*)query;
-(NSMutableArray*)listDB:(NSString*)query;
-(NSMutableArray*)consultaDB:(NSString*)query;
-(BOOL)insertaDB:(NSString*)nombre estado:(NSString*)estado youtube:(NSString*)youtube foto:(NSData*)foto;
-(BOOL)actualizaDB:(NSString*)nombre estado:(NSString*)estado youtube:(NSString*)youtube foto:(NSData*)foto idagenda:(NSString*)idagenda;
-(NSMutableArray*) executeQueryWithString:(NSString*)querySQL;

@end