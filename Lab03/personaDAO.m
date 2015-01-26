//
//  personaDAO.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 25/01/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "personaDAO.h"
#import "persona.h"
@implementation personaDAO

- (NSString *) obtenerRutaBD{
    NSString *dirDocs;
    NSArray *rutas;
    NSString *rutaBD;
    
    rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dirDocs = [rutas objectAtIndex:0];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    rutaBD = [[NSString alloc] initWithString:[dirDocs stringByAppendingPathComponent:@"contactos.sqlite"]];
    
    if([fileMgr fileExistsAtPath:rutaBD] == NO){
        [fileMgr copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"contactos.sqlite"] toPath:rutaBD error:NULL];
    }
    
    return rutaBD;
}
- (NSMutableArray *) obtenerPersona{
    NSMutableArray *listaPersona = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self obtenerRutaBD];
    
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    const char *sentenciaSQL = "SELECT id,foto,nombre,status,video FROM persona";
    sqlite3_stmt *sqlStatement;
    
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
    }
    
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        persona *persona = [persona  init];
        persona.identificadorID = sqlite3_column_int(sqlStatement, 0);
        persona.nombrePersona = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        persona.statusPersona = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        
        [listaPersona addObject:persona];
    }
    
    return listaPersona;
}
@end
