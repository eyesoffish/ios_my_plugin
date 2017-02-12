//
//  LocationViewController.m
//  UBaby
//
//  Created by fengei on 17/1/5.
//  Copyright © 2017年 fengei. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface LocationViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}
@end

@implementation LocationViewController

- (void)startLocating
{
    if([CLLocationManager locationServicesEnabled])
    {
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        _locationManager.distanceFilter = 100.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
    [_locationManager stopUpdatingLocation];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *test = [placemark addressDictionary];
            //  Country(国家)  State(城市)  SubLocality(区)
            NSLog(@"%@", [test objectForKey:@"Country"]);
            NSLog(@"%@", [test objectForKey:@"State"]);
            NSLog(@"%@", [test objectForKey:@"SubLocality"]);
            NSLog(@"%@", [test objectForKey:@"Street"]);
            if(self.callBackCity){
                self.callBackCity([test objectForKey:@"City"]);
            }
        }
    }];
}
@end
