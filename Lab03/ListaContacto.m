//
//  ListaContacto.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "ListaContacto.h"
#import "ListasContactosCelda.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseD.h"
#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

NSMutableArray *datos;
NSString *idTemp;
NSString *idSelect;
int indice;

@interface ListaContacto ()

@end

@implementation ListaContacto

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
    static NSString *CellIdentifier = @"ListasContactosCelda";
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
                                          otherButtonTitles:@"Compartir",@"Ver mas", nil];
    [alert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        NSLog(@"Cancelar");
    }
    else if(buttonIndex == 1){
        
        NSMutableArray *dato = datos[indice];
        
        NSString                    *strMsg;
        NSArray                     *activityItems;
        UIImage                     *imgShare;
        UIActivityViewController    *actVC;
       
        imgShare =  [UIImage imageWithData:[dato objectAtIndex:4]];
        strMsg = [NSString stringWithFormat: @"Mi contacto, se llama %@ y su estado es: %@", [dato objectAtIndex:1], [dato objectAtIndex:2]];
        activityItems = @[imgShare, strMsg];
        
        //Init activity view controller
        //Init activity view controller
        actVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        actVC.excludedActivityTypes = [NSArray arrayWithObjects:UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeAirDrop, nil];
        
        [self presentViewController:actVC animated:YES completion:nil];
        
    }
    else if(buttonIndex == 2){
        [self performSegueWithIdentifier:@"Detalle" sender:self];
    }
    
}


@end
