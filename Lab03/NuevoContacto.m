//
//  NuevoContacto.m
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import "NuevoContacto.h"
#import <QuartzCore/QuartzCore.h>
#import "BaseD.h"
@interface NuevoContacto ()

@end

@implementation NuevoContacto

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)takePhoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)selectphoto:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (IBAction)guardar:(id)sender {
    NSString *nombre = [self.txtnombre.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *estado = [self.txtstatus.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *youtube = [self.txtyoutube.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    UIImage* image = [self.imageView image];
    NSData *imageData=UIImagePNGRepresentation(image);
    NSLog(@"Las variables son: %@, %@, %@", nombre, estado, youtube);
    
    if([[BaseD getSharedInstance]insertaDB:nombre estado:estado youtube:youtube foto:imageData]){
        [self performSegueWithIdentifier:@"" sender:self];
    }
    
    }
@end
