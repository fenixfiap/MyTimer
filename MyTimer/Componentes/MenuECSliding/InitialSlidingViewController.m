//
//  InitialSlidingViewController.m
//  HeroiDaCidade
//
//  View inicial de referência para implementação do Slide.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    
  [super viewDidLoad];
    
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:14.0f/255.0f green:74.0f/255.0f blue:128.0f/255.0f alpha:1.0f]];
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  
  self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"SolicitacoesProximas"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return YES;
}

@end
