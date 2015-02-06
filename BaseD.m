//
//  BaseD.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "BaseD.h"


static BaseD *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation BaseD
+(BaseD*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(NSMutableArray*) listado{
    return nil;
}

//Crear Base de Datos
-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"game.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "create table if not exists resultados (id integer primary key AUTOINCREMENT, puntos integer, fecha text)";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
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

//Guardar datos
- (BOOL) saveData:(int)puntos fecha:(NSString*)fecha;
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into resultados (puntos,fecha) values (\"%d\",\"%@\" )",puntos, fecha];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_reset(statement);
            NSLog(@"Statement SUCCESS");
            return YES;
        } else {
            NSLog(@"Statement FAILED (%s)", sqlite3_errmsg(database));
            sqlite3_reset(statement);
            return NO;
        }
    }
    return NO;
}

//seleccionar datos
- (NSMutableArray*) listar{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"select puntos, fecha from resultados order by puntos DESC LIMIT 15"];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *ar_result = [[NSMutableArray alloc] initWithCapacity:10];
        if (sqlite3_prepare_v2(database,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            int columns = sqlite3_column_count(statement);
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSMutableArray *arc = [[NSMutableArray alloc] initWithCapacity:columns];
                for(int i=0; i < columns; i++){
                    if (sqlite3_column_text(statement, i) == NULL)
                        [arc addObject:@""];
                    else
                        [arc addObject:[NSString stringWithCString:(char *)sqlite3_column_text(statement, i)
                                                          encoding:NSUTF8StringEncoding]
                         ];
                }
                [ar_result addObject:arc];
            }
            sqlite3_reset(statement);
            return ar_result;
        }
    }
    return nil;
}


@end

