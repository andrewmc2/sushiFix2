//
//  AddSushiViewController.m
//  Sushi2
//
//  Created by Andrew McCallum14 on 2013-05-31.
//  Copyright (c) 2013 Andrew McCallum. All rights reserved.
//

#import "AddSushiViewController.h"
#import "AddSushiCustomCell.h"

//flat
#import "UIColor+FlatUI.h"
#import "UITabBar+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "FUIButton.h"
#import "FUISwitch.h"
#import "UIFont+FlatUI.h"
#import "FUIAlertView.h"
#import "UIBarButtonItem+FlatUI.h"
#import "UIProgressView+FlatUI.h"
#import "FUISegmentedControl.h"
#import "UITableViewCell+FlatUI.h"

//assetsLibrary
#import <AssetsLibrary/AssetsLibrary.h>

//location

//#import "NSMutableDictionary+ImageMetadata.h"


@interface AddSushiViewController ()



- (IBAction)randomButton:(id)sender;

@end

@implementation AddSushiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor japaneseTurqoiseColor]];
        NSLog(@"1");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSLog(@"2");
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.addPictureLabelView addGestureRecognizer:singleFingerTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSourceMethods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    AddSushiCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

//    cell = [UITableViewCell configureFlatCellWithColor:[UIColor japaneseSalmonColor] selectedColor:[UIColor japanesePinkColor] style:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
//    if (cell == nil){
//        cell = [[AddSushiCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    
    if (indexPath.section == 0) {
        cell.cellName.text = @"name";
        cell.cellTextField.placeholder = @"insert name here";
    }
    
    if (indexPath.section == 1) {
        cell.cellName.text = @"description";
        cell.cellTextField.placeholder = @"insert description here";
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark delegate method

- (IBAction)confirmEntry:(id)sender {

}

#pragma mark add picture 

- (IBAction)addPic:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Select from Library", nil];
    [actionSheet showInView:self.view];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        } else
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else if (buttonIndex == 1) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
//    [metadata setDescription:@"shitty"];
    
UIImage *imageTaken  = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.selectedImage =imageTaken;
    self.addedImage.image = imageTaken;
//
//    NSData *imageJpeg = UIImageJPEGRepresentation(image, 1);
//    
//    
//    
//    
//    
//    NSLog(@"%@",info);
//
    
    
    CLLocationDegrees chicagoLat = 41.8500;
    CLLocationDegrees chicagoLong = -87.6500;

    CLLocation *clLocation = [[CLLocation alloc] initWithLatitude:chicagoLat longitude:chicagoLong];
    
    
    
    NSMutableDictionary *newDict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    
    NSDictionary *gpsDict = [self getGPSDictionaryForLocation:clLocation];
    
    [newDict setObject:gpsDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
    
    
    
//    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
//
//    
//    [library writeImageToSavedPhotosAlbum:[image CGImage] metadata:newDict completionBlock:^(NSURL *assetURL, NSError *error) {
//    }];
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library addAssetsGroupAlbumWithName:@"Sushi" resultBlock:^(ALAssetsGroup *group) {
        //yo
    } failureBlock:^(NSError *error) {
        //yoyo
    }];
//
    //why?
    __block ALAssetsGroup *assetsGroup;
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Sushi"]) {
            assetsGroup = group;
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"fail");
    }];
    
    CGImageRef img = [imageTaken CGImage];
//    NSLog(@"yo");
//    NSDictionary *metadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
//    
    [library writeImageToSavedPhotosAlbum:img metadata:newDict completionBlock:^(NSURL *assetURL, NSError *error) {

        if (error.code == 0) {
            [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                [assetsGroup addAsset:asset];
            } failureBlock:^(NSError *error) {
                NSLog(@"fail");
            }];
        } else {
            NSLog(@"fail");
        }
    }];
//
//    [assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//
//        NSLog(@"%@",result);
//     //CLLocation *loc = [result valueForProperty:ALAssetPropertyLocation];
//
//     }];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //self.addPictureLabelView.hidden = YES;
}

- (NSDictionary *)getGPSDictionaryForLocation:(CLLocation *)location {
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];
    
    // GPS tag version
    [gps setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
    
    // Time and date must be provided as strings, not as an NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];
    
    // Latitude
    CGFloat latitude = location.coordinate.latitude;
    if (latitude < 0) {
        latitude = -latitude;
        [gps setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [gps setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    
    // Longitude
    CGFloat longitude = location.coordinate.longitude;
    if (longitude < 0) {
        longitude = -longitude;
        [gps setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    } else {
        [gps setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    
    // Altitude
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [gps setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [gps setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [gps setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Speed, must be converted from m/s to km/h
    if (location.speed >= 0){
        [gps setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
        [gps setObject:[NSNumber numberWithFloat:location.speed*3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
    }
    
    // Heading
    if (location.course >= 0){
        [gps setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
        [gps setObject:[NSNumber numberWithFloat:location.course] forKey:(NSString *)kCGImagePropertyGPSTrack];
    }
    
    return gps;
}



- (IBAction)doneAddingSushi:(id)sender {
    NSString *sushiNameString = ((AddSushiCustomCell*)([self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]])).cellTextField.text;
    NSString *sushiDescriptionString = ((AddSushiCustomCell*)([self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]])).cellTextField.text;
    
    [self.addSushiDelegate addName:sushiNameString
                    addDescription:sushiDescriptionString
                          addImage:self.selectedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAddSushi:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    NSLog(@"%@",NSStringFromSelector(_cmd));
    
    if ([touch view] == self.addedImage)
    {
        //add your code for image touch here

    }
    
}
- (IBAction)randomButton:(id)sender {
    NSLog(@"%@",NSStringFromSelector(_cmd));
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Select from Library", nil];
    [actionSheet showInView:self.view];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
}

-(void)handleSingleTap: (UITapGestureRecognizer*)recognizer
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"addedIMage");
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Select from Library", nil];
    [actionSheet showInView:self.view];
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
}
@end
