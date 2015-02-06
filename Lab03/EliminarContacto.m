//
//  EliminarContacto.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 06/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "EliminarContacto.h"
#import "ListasContactosCelda.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseD.h"

NSMutableArray *datos;
NSString *idTemp;
NSString *idSelect;
int indice;

@interface EliminarContacto ()

@end

@implementation EliminarContacto

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initController{
    
    datos = [[BaseD getSharedInstance]listDB:@"select id, nombre, estado, youtube, foto from personas"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datos count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cellBaja";
    ListasContactosCelda *cell = (ListasContactosCelda *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[ListasContactosCelda alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray *dato = datos[indexPath.row];
    cell.Nombre.text = [dato objectAtIndex:1];
    cell.Estado.text = [dato objectAtIndex:2];
    cell.imagen.image = [UIImage imageWithData:[dato objectAtIndex:4]];
    CALayer * l = [cell.imagen layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:30.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *dato = datos[indexPath.row];
    indice = indexPath.row;
    
    NSString *nombreTemp;
    
    idSelect = [dato objectAtIndex:0];
    idTemp = [dato objectAtIndex:0];
    nombreTemp = [[dato objectAtIndex:1] stringByAppendingString: @" fué seleccionado"];
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Seleccione accion"
                                                    message:nombreTemp
                                                   delegate:self
                                          cancelButtonTitle:@"Cancelar"
                                          otherButtonTitles:@"Eliminar", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Cancelar");
    }
    else if(buttonIndex == 1)
        {
            NSLog(@"Borrar");
            NSString *query = [NSString stringWithFormat: @"DELETE FROM personas WHERE id=%@;", idTemp];
            NSLog(query);
            if([[BaseD getSharedInstance]saveDB:query]){
                [self initController];
                self.Elimina.reloadData;
            }
        }

    
}


@end
