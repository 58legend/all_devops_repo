additional_tags = {
  Owner       = "58Legend"
  Lesson      = "9"
  Description = "Work with Auto Scaling group and classic Load Ballancer"
}
#Sucurity Group
allow_ports = ["80", "22", "443"] #Allow ports Security Group of instance
cidr_blocks = ["0.0.0.0/0"]       #CIDR blocks Security Group of instance

#instance
image_id           = "ami-0e2031728ef69a466" #Amazon image
name_prefix        = "autoscaling_"          #Prefix of new instances
key_name           = "Frankfurt eu-central-1"
instance_type = "t2.micro"
availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"] #availability_zones of Auto Scalling Group

asg_max_size       = 3    #How max instance we need
asg_min_size       = 1    #How min instance we need
asg_start_size     = 2    #How many instance we started 
low_threshold      = "30" # % Low threshold in percent CPU when instance was destroyed
high_threshold     = "70" # % High threshold in percent CPU when instance was created
health_threshold   = 2    # Кількість запитів після якого сервер вважається здоровим
unhealth_threshold = 2    # Кількість запитів після якого сервер вважається мертвим
timeout_health     = 5    #Seconds За який час сервер повинен дати відповідь, інакше вважатиметься мертвим
interval_health    = 30   #Seconds За який проміжок часу сервер відправить наступний запит

adjustment_type           = "ChangeInCapacity"
policy_type               = "SimpleScaling"
metric_name               = "CPUUtilization"
namespace                 = "AWS/EC2"
period                    = "60" #second when aws_cloudwatch_metric_alarm check cpu and create or destroy instances
statistic                 = "Average"
autoscalingPolicyCooldown = "150" #Seconds of period between creation of instances. Default 150
alarm_description         = "This metric monitors ec2 cpu utilization"
instance_protocol         = "http"
lb_protocol               = "http"
target                    = "HTTP:80/"
evaluation_periods        = "2"