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

@end
