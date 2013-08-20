//
//  CustomPin.m
//  CustomPin
//
//  Created by William Gomes on 8/2/13.
//  Copyright (c) 2013 Call. All rights reserved.
//

#import "AnnotationView.h"


@implementation AnnotationView

@synthesize mapView = _mapView;

- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
	
        CGRect frame = self.frame;
        frame.size = CGSizeMake(275, 130);
        self.frame = frame;
        self.centerOffset = CGPointMake(self.frame.origin.x, self.frame.origin.y - 115);
        
        UIImage *imgBackground = [UIImage imageNamed:@"tooltip_background.png"];
        UIImageView *vwImgBackground = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
        vwImgBackground.image = imgBackground;
        [self addSubview:vwImgBackground];
        
        UIActivityIndicatorView *aiCarregandoImagem = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        aiCarregandoImagem.frame = CGRectMake(15, 30, 40, 40);
        [aiCarregandoImagem startAnimating];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
        
        [self addSubview:aiCarregandoImagem];
        
        UIImageView *vwImgToolTip = [[UIImageView alloc] initWithFrame:CGRectMake(15, 30, 40, 40)];
        
        Annotation* ann = annotation;
            dispatch_async(queue, ^{
                UIImage *img = nil;
                    img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ann.urlImagemPin]]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [aiCarregandoImagem removeFromSuperview];
                    vwImgToolTip.image = img;
                    [self addSubview:vwImgToolTip];
                    
                });
            });
        
        
        UILabel *lblTitulo = [[UILabel alloc] initWithFrame:CGRectMake(65, 20, 155, 20)];
        lblTitulo.font = [UIFont boldSystemFontOfSize:13];
        lblTitulo.backgroundColor = [UIColor clearColor];
        lblTitulo.textColor = [UIColor whiteColor];
        lblTitulo.text = self.annotation.title;
        [self addSubview:lblTitulo];
        
        UILabel *lblDescricao = [[UILabel alloc] initWithFrame:CGRectMake(65, 30, 155, 60)];
        lblDescricao.numberOfLines = 3;
        lblDescricao.font = [UIFont boldSystemFontOfSize:12];
        lblDescricao.backgroundColor = [UIColor clearColor];
        lblDescricao.textColor = [UIColor whiteColor];
        lblDescricao.text = self.annotation.subtitle;
        [self addSubview:lblDescricao];

	}
	return self;
}

@end
