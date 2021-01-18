#### Homework __'Git tools'__

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
Command: `git show aefea`  
Result: `commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Update CHANGELOG.md`

2. Какому тегу соответствует коммит 85024d3?  
Command: `git show -q 85024d3`  
Result: `commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)...`

3. Сколько родителей у коммита b8d720? Напишите их хеши.  
Command: `git log --pretty=%P -n 1 b8d720`  
Result: `56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b`  

4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.  
Command: `git log --oneline v0.12.23..v0.12.24`  
Result:
    - b14b74c49 [Website] vmc provider links  
    - 3f235065b Update CHANGELOG.md
    - 6ae64e247 registry: Fix panic when server is unreachable
    - 5c619ca1b website: Remove links to the getting started guide's old location
    - 06275647e Update CHANGELOG.md
    - d5f9411f5 command: Fix bug when using terraform login on Windows
    - 4b6d06cc5 Update CHANGELOG.md
    - dd01a3507 Update CHANGELOG.md
    - 225466bc3 Cleanup after v0.12.23 release  

5. Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).  
Command: `git log -S "func providerSource(" --pretty=%h`  
Result: `8c928e835`

6. Найдите все коммиты в которых была изменена функция globalPluginDirs.  
Command: `git log --oneline -L :globalPluginDirs:plugins.go`  
Result:
    - 78b122055 Remove config.go and update things using its aliases
    - 52dbf9483 keep .terraform.d/plugins for discovery
    - 41ab0aef7 Add missing OS_ARCH dir to global plugin paths
    - 66ebff90c move some more plugin search path logic to command
    - 8364383c3 Push plugin discovery down into command package

7. Кто автор функции synchronizedWriters?  
Command: `git log -SsynchronizedWriters --pretty="%h %s (%aN - %aE)" --reverse | head -1`  
Result: `5ac311e2a main: synchronize writes to VT100-faker on Windows (Martin Atkins - mart@degeneration.co.uk)`