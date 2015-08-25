//
//  MapViewController.m
//  Rotten Mangoes++
//
//  Created by Arsalan Vakili on 2015-08-25.
//  Copyright (c) 2015 Arsalan Vakili. All rights reserved.
//

#import "MapViewController.h"
#import "ReviewCollectionViewController.h"
#import "Theatre.h"

@interface MapViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong) CLLocationManager *locationManager;
@property(nonatomic,assign) BOOL initialLocationInset;
@property(nonatomic,strong) NSString *postalCode;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.initialLocationInset = NO;
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (status == kCLAuthorizationStatusNotDetermined) {
            [self.locationManager requestWhenInUseAuthorization];
            
            [self showTheatreInfomation];
            
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
        self.mapView.showsUserLocation = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLoacation = [locations lastObject];
    if (!self.initialLocationInset) {
        self.initialLocationInset = YES;
        MKCoordinateRegion region = MKCoordinateRegionMake(currentLoacation.coordinate, MKCoordinateSpanMake(0.1, 0.1));
        [self.mapView setRegion:region animated:YES];
        
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:currentLoacation completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *placeMark = [placemarks firstObject];
            self.postalCode = placeMark.postalCode;
           
            [self showTheatreInfomation];
        }];
    }
}


-(void)showTheatreInfomation{
    
//    ReviewCollectionViewController *reviewController = [[ReviewCollectionViewController alloc]init];
    
    NSString *apiString = [NSString stringWithFormat:@"http://lighthouse-movie-showtimes.herokuapp.com/theatres.json?address=%@&movie=%@",self.postalCode,self.movie.title];
    
    NSString *formattedString = [apiString stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSURL *url = [NSURL URLWithString:formattedString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error = nil;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
   // NSLog(@"%@",jsonDictionary);
    
    if (!error) {
        NSArray *theatres = jsonDictionary[@"theatres"];
     
        
        for (NSDictionary *theatre in theatres) {
            Theatre *aTheatre = [[Theatre alloc]init];
           // MKPointAnnotation *aTheatre = [[MKPointAnnotation alloc]init];
            
            aTheatre.coordinate = CLLocationCoordinate2DMake([theatre[@"lat"] doubleValue], [theatre[@"lng"] doubleValue]);
            aTheatre.title = theatre[@"name"];
            aTheatre.subtitle = theatre[@"address"];
            
            [self.mapView addAnnotation:aTheatre];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
