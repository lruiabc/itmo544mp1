#!/bin/bash
declare -a ELBURLARR
mapfile -t ELBURLARR < <(aws elb create-load-balancer --load-balancer-name itmo544-rui-lb  --listeners Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80 --subnets $5 --security-groups $4 --output=text); echo $ELBURLARR

echo -e "\nFinished launching ELB and sleeping 25 seconds"
for i in {0..25}; do echo -ne '.';sleep 1;done
echo "\n"
#declare an array in bash
declare -a instanceARR

mapfile -t instanceARR < <(aws ec2 run-instances --image-id $1 --count $2 --instance-type $3 --key-name $6 --security-group-ids $4 --subnet-id $5 --associate-public-ip-address --iam-instance-profile Name=$7 --user-data file://install-webserver.sh --output table | grep InstanceId | sed "s/|//g" | tr -d '' | sed "s/InstanceId//g")
			   

echo ${instanceARR[@]}
aws ec2 wait instance-running --instance-ids ${instanceARR[@]}

echo "instances are running"



aws elb register-instances-with-load-balancer --load-balancer-name itmo544-rui-lb --instances ${instanceARR[@]}


#auto

aws autoscaling create-launch-configuration --launch-configuration-name inmp1-2-lc --image-id $1 --key-name $6  --security-groups $4 --instance-type $3 --user-data file://install-webserver.sh --iam-instance-profile $7

aws autoscaling create-auto-scaling-group --auto-scaling-group-name itmo544-autoscaling-2 --launch-configuration-name inmp1-2-lc --load-balancer-names itmo544-rui-lb  --health-check-type ELB  --min-size 3 --max-size 6 --desired-capacity 3 --default-cooldown 600 --health-check-grace-period 120 --vpc-zone-identifier $5


#create cloudwatch alarms

aws cloudwatch put-metric-alarm --alarm-name cpu-ma --alarm-description "Alarm when CPU exceeds 30 percent" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 30 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions  Name=AutoScalingGroupName,Value=itmo544-autoscaling-2 --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:111122223333:MyTopic --unit Percent

aws cloudwatch put-metric-alarm --alarm-name cpu-mi --alarm-description "Alarm when CPU below 10 percent" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 10 --comparison-operator LessThanOrEqualToThreshold  --dimensions  Name=AutoScalingGroupName,Value=itmo544-autoscaling-2 --evaluation-periods 3 --alarm-actions arn:aws:sns:us-west-2:111122223333:MyTopic --unit Percent


# launch-rds.sh
#declare -a dbInstanceARR
#mapfile -t dbInstanceARR < <(aws rds describe-db-instances --output json | grep "\"DBInstanceIdentifier" | sed "s/[\"\:\, ]//g" | sed "s/DBInstanceIdentifier//g" )

#if [ ${#dbInstanceARR[@]} -gt 0 ]
#   then
#   echo "Deleting existing RDS database-instances"
#   LENGTH=${#dbInstanceARR[@]}

#      for (( i=0; i<${LENGTH}; i++));
#      do
#      if [ ${dbInstanceARR[i]} == "jrh-db" ] 
#     then 
#      echo "db exists"
#     else
     aws rds create-db-instance --db-instance-identifier itmo544grh-mp1 --db-name itmoruidb --db-instance-class db.t1.micro --engine MySQL --master-username rui --master-user-password 110224Fish --allocated-storage 5
#      fi  
#     done
#fi
aws rds wait db-instance-available --db-instance-identifier itmo544grh-mp1
aws rds create-db-instance-read-replica --db-instance-identifier itmo544-rui-sdb  --source-db-instance-identifier itmo544grh-mp1 --db-instance-class db.t2.micro

