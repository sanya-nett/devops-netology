# ДЗ 7.6. Написание собственных провайдеров для Terraform

### Задача 1

1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.  
 __Result__: 
   [DataSources](https://github.com/hashicorp/terraform-provider-aws/blob/121a3e345be6f9404fdae287e6acab4e45e1a2c7/aws/provider.go#L186)
   и [Resoucres](https://github.com/hashicorp/terraform-provider-aws/blob/121a3e345be6f9404fdae287e6acab4e45e1a2c7/aws/provider.go#L447)
2. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`? Приложите строчку кода, в которой это указано.  
      __Result__: [name_prefix](https://github.com/hashicorp/terraform-provider-aws/blob/ac06ced75cba0daf09fef2938752ad13cc6fff6e/aws/resource_aws_sqs_queue.go#L65)
    * Какая максимальная длина имени?  
      __Result__: Maximum 80 characters
    * Какому регулярному выражению должно подчиняться имя?  
      __Result__: alphanumeric characters, hyphens (-), and underscores (_)
    
