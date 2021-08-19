//Commented since the training account does not allow Route 53

/* resource "aws_route53_zone" "private_zone" {
  name = "movie-analyst.internal"
  vpc {
    vpc_id = var.existing_resources["vpc_id"]
  }
}

// Gives an alias for the Internal ELB to be used in every 
// image and instance into the vpc
resource "aws_route53_record" "api-lb-alias" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = var.AWS_INTERNAL_LB
  type    = "A"

  alias {
    name                   = module.api_elb.elb_name
    zone_id                = module.api_elb.elb_zone_id
    evaluate_target_health = true
  }
}
 */
