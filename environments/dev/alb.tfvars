alb_config = {
  internal    = false
  load_balancer_type = "application"

  listeners = {
    http-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
      rules = {}
    }
    https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = "arn:aws:acm:us-west-2:187091248012:certificate/f4bfe7c7-2a86-46fc-8d02-728435c793ff"
      forward = {
        type = "forward"
        target_group_key = "cagent"
      }
      rules = {
        s3-explorer = {
          priority = 1
          conditions = [{
            host_header = {
              values = ["s3-explorer.user-domain"]
            }
          }]
          actions = [{
            type = "forward"
            target_group_key = "s3-explorer"
          }]
        }
        cagent = {
          priority = 2
          conditions = [{
            host_header = {
              values = ["cagent.user-domain"]
            }
          }]
          actions = [{
            type = "forward"
            target_group_key = "cagent"
          }]
        }
      }
    }
  }

  target_groups = {
    s3-explorer = {
      name_prefix      = "s3ex"
      protocol         = "HTTP"
      port             = 3001
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval           = 30
        path              = "/health"
        port              = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout           = 5
        protocol          = "HTTP"
        matcher           = "200-399"
      }
      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = false
      }
    }
    cagent = {
      name_prefix      = "cagt"
      protocol         = "HTTP"
      port             = 3000
      target_type      = "instance"
      health_check = {
        enabled             = true
        interval           = 30
        path              = "/health"
        port              = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout           = 5
        protocol          = "HTTP"
        matcher           = "200-399"
      }
      stickiness = {
        type            = "lb_cookie"
        cookie_duration = 86400
        enabled         = false
      }
    }
  }

  enable_deletion_protection = false
  tags = {}
}
