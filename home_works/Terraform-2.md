# ДЗ 7.2. Облачные провайдеры и синтаксис Терраформ.

### Задача 1. Регистрация в aws и знакомство с основами

```commandline
ascherba@~$ aws configure list
>>       Name                    Value             Type    Location
>>       ----                    -----             ----    --------
>>    profile                <not set>             None    None
>> access_key     ****************HENS              env
>> secret_key     ****************AGDs              env
>>     region                us-west-2      config-file    ~/.aws/config
```

### Задача 2. Созданием ec2 через терраформ

1) Ответ на вопрос: при помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami?  
__Answer__: кмк, это вопрос про Packer, который позволяет собирать готовые образы

2) Ссылку на репозиторий с исходной конфигурацией терраформа.  
   В отдельной ветке лежит: __terraform-02__:   
   https://github.com/sanya-nett/devops-netology/tree/terraform-02/terraform

Дополнительно, результат выполнения `terraform apply`:
```commandline
ascherba@~/Repositories/devops-netology/terraform(terraform-02)$ terraform apply
data.aws_caller_identity.caller_data: Refreshing state...
data.aws_region.region_data: Refreshing state...
aws_key_pair.home_laptop: Refreshing state... [id=home-laptop-key]
data.aws_ami.ubuntu: Refreshing state...
aws_security_group.allow_ssh: Refreshing state... [id=sg-04b5b0cd1e9e2835d]
aws_instance.web: Refreshing state... [id=i-01b2826355fc0dd74]

Warning: Provider source not supported in Terraform v0.12

  on versions.tf line 3, in terraform:
   3:     aws = {
   4:       source = "hashicorp/aws"
   5:       version = "~> 3.0"
   6:     }

A source was declared for provider aws. Terraform v0.12 does not support the
provider source attribute. It will be ignored.


Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

aws_account_id = 920874525695
aws_caller_user = AIDA5M2DGEP7TE7635QIP
aws_region_name = us-west-2
ec2_private_ip = 172.31.20.200
ec2_public_ip = 34.222.9.171
ec2_subnet_id = subnet-50da6f28
```
Изменений нет, так как конфигурация не менялась с последнего запуска