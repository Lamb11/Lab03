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

- (NSMutableArray*) listDB:(NSString*)query;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *query_stmt = [query UTF8String];
        NSMutableArray *ar_result = [[NSMutableArray alloc] initWithCapacity:10];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            int columns = sqlite3_column_count(statement);
            while (sqlite3_step(statement) == SQLITE_ROW){
                NSMutableArray *arc = [[NSMutableArray alloc] initWithCapacity:columns];
                for(int i=0; i < (columns-1); i++){
                    if (sqlite3_column_text(statement, i) == NULL){
                        [arc addObject:@""];
                    }
                    else{
                        [arc addObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, i)
                                                          encoding:NSUTF8StringEncoding]
                         ];
                    }
                }
                if (sqlite3_column_blob(statement, 4) != NULL) {
                    NSData *dataimg = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
                    [arc addObject:dataimg];
                }
                [ar_result addObject:arc];
            }
            sqlite3_reset(statement);
            return ar_result;
        }
    }
    return nil;
}

- (BOOL) saveDB:(NSString*)query;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *insert_stmt = [query UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE){
            sqlite3_reset(statement);
            NSLog(@"Registro actualizado");
            return YES;
        } else {
            NSLog(@"Registro FALLO (%s)", sqlite3_errmsg(database));
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

- (BOOL) actualizaDB:(NSString*)nombre estado:(NSString*)estado youtube:(NSString*)youtube foto:(NSData*)foto idagenda:(NSString*)idagenda{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char* sqliteQuery = "UPDATE personas SET nombre = ?, estado = ?, youtube = ?, foto = ? WHERE id = ?";
        sqlite3_stmt* statement;
        if( sqlite3_prepare_v2(database, sqliteQuery,-1, &statement, NULL) == SQLITE_OK ){
            sqlite3_bind_text(statement, 1, [nombre UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 2, [estado UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 3, [youtube UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_bind_blob(statement, 4, [foto bytes], [foto length], SQLITE_TRANSIENT);
            sqlite3_bind_text(statement, 5, [idagenda UTF8String], -1, SQLITE_TRANSIENT);
            if (sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_reset(statement);
                NSLog(@"Registro actualizado");
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

- (NSMutableArray*) consultaDB:(NSString*)query;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK){
        const char *query_stmt = [query UTF8String];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK){
            int columns = sqlite3_column_count(statement);
            NSMutableArray *arc = [[NSMutableArray alloc] initWithCapacity:columns];
            while (sqlite3_step(statement) == SQLITE_ROW){
                for(int i=0; i < (columns-1); i++){
                    if (sqlite3_column_text(statement, i) == NULL){
                        [arc addObject:@""];
                    }
                    else{
                        [arc addObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, i)
                                                          encoding:NSUTF8StringEncoding]
                         ];
                    }
                }
                if (sqlite3_column_blob(statement, 4) != NULL) {
                    NSData *dataimg = [[NSData alloc] initWithBytes:sqlite3_column_blob(statement, 4) length:sqlite3_column_bytes(statement, 4)];
                    [arc addObject:dataimg];
                }
            }
            sqlite3_reset(statement);
            return arc;
        }
    }
    return nil;
}

@end

