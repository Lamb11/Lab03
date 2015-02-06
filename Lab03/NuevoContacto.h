//
//  NuevoContacto.h
//  Lab03
//
//  Created by Alberto Cordero Arellanes on 05/02/15.
//  Copyright (c) 2015 AlbertoCorderoArellanes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NuevoContacto : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)takePhoto:(UIButton *)sender;

- (IBAction)selectphoto:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UITextField *txtnombre;

@property (strong, nonatomic) IBOutlet UITextField *txtstatus;

@property (strong, nonatomic) IBOutlet UITextField *txtyoutube;

@property (strong, nonatomic) IBOutlet UIButton *guardar;
@property (strong, nonatomic) IBOutlet UIButton *actualizar;

- (IBAction)guardar:(id)sender;
- (IBAction)actualizar:(id)sender;
@end
