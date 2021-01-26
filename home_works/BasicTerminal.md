## 3.1. Работа в терминале, лекция 1

- Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит 
виртуальная машина, которую создал для вас Vagrant, какие аппаратные 
ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?  
__Answer__: `1 CPU, 1Gi Memory `

- Как добавить оперативной памяти или ресурсов процессора виртуальной машине?  
__Answer__:
    ```  
    config.vm.provider "virtualbox" do |vb|    
      vb.memory = 1024  
      vb.cpus = 1
    ```  

- Какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?  
__Answer__: `HISTSIZE` - The  number  of commands to remember in the command history.

- Что делает директива `ignoreboth` в `bash`?  
__Answer__: A value of `ignoreboth` is shorthand for `ignorespace` and `ignoredups` and use for `HISTCONTROL` variable.

- В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?  
__Answer__: Using in `Compound Commands`. 
Необходимо использовать, когда надо выполнить одинаковую команду для `N` параметров

- Основываясь на предыдущем вопросе, как создать однократным вызовом touch 100000 файлов?  
__Answer__: Create 100000 files: `touch {000001..100000}` 
 
- А получилось ли создать 300000?  
__Answer__: Командой `touch {1..300000}` не получилось (ошибка `-bash: /usr/bin/touch: Argument list too long`)  
Но получилось обойти ограничение `ARG_MAX` с помощью `xargs` выполнив команду: `echo {1..300000} | xargs -n 1000 touch`  
P.S.: но не уверен, что это честный и __однократный__ вызов `touch`

- Что делает конструкция `[[ -d /tmp ]]` ?  
__Answer__: логическое условие, которое проверяет, что `/tmp` директория существует

- Основываясь на знаниях о просмотре текущих (например, `PATH`) и установке новых переменных; командах, которые мы 
рассматривали, добейтесь в выводе `type -a bash` в виртуальной машине наличия первым пунктом в списке:  
__Answer__: 
    ```bash
    new_path=/tmp/new_path_directory
    mkdir ${new_path}
    cp /bin/bash ${new_path}
    export PATH="${new_path}:${PATH}"
    ```

- Чем отличается планирование команд с помощью `batch` и `at`?  
__Answer__:  
`at` executes commands at a specified time  
`batch` executes commands when system load levels permit
