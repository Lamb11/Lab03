//
//  BaseD.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "BaseD.h"

//Inicializar valores
NSString *dbname = @"registros.db";
const char *createStatment = "create table if not exists personas (id integer primary key AUTOINCREMENT, nombre text, estado text, youtube text, foto blob)";

static BaseD *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;


@implementation BaseD
+(BaseD*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance crearDB];
    }
    return sharedInstance;
}

-(NSMutableArray*) listado{
    return nil;
}

//Crear Base de Datos
-(BOOL)crearDB{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: dbname]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO){
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK){
            char *errMsg;
            if (sqlite3_exec(database, createStatment, NULL, NULL, &errMsg) != SQLITE_OK){
                isSuccess = NO;
                NSLog(@"Error al crear la tabla");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Error al abrir/crear la base de datos");
        }
    }
    return isSuccess;
}

- (BOOL) insertaDB:(NSString*)nombre estado:(NSString*)estado youtube:(NSString*)youtube foto:(NSData*)foto{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char* sqliteQuery = "INSERT INTO personas (nombre, estado, youtube, foto) VALUES (?, ?, ?, ?)";
        sqlite3_stmt* statement;
        if( sqlite3_prepare_v2(database, sqliteQuery,-1, &statement, NULL) == SQLITE_OK ){
            sqlite3_bind_text(statement, 1, [nombre UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [estado UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [youtube UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(statement, 4, [foto bytes], [foto length], SQLITE_TRANSIENT);
            if (sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_reset(statement);
                NSLog(@"Registro Insertado");
                return YES;
            }else{
                return NO;
            }
        } else {
            NSLog(@"Registro FALLO (%s)", sqlite3_errmsg(database));
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

@end

