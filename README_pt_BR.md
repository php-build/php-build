
Plugin do Composer para php-build
=================================

[en](README.md) | [pt_BR](README_pt_BR.md)

## O que é?

Este pequeno script se liga no [php-build](https://github.com/CHH/php-build)
para instalar o [Composer](https://getcomposer.org/) automaticamente em cada
Build, assim você não precisa se preocupar com isso.

## Para o que ele é bom?

Ele é ideal para usar o [Composer and their awesome features](https://getcomposer.org/)
com múltiplas versões do PHP. A ideia vem do [plugin do phpunit](https://github.com/CHH/php-build-plugin-phpunit) feito pelo [CHH](https://github.com/CHH).

Antes, eu precisava instalar o Composer globalmente na minha máquina ou fazer
isso em cada um dos Builds do PHP onde quisesse ter o Composer disponível.
Agora, usando este plugin, toda vez que você faz o build de uma nova versão do
PHP usando o `php-build`, o comando `composer` já estará pronto para ser usado.

## Instalação

Você pode escolher entre:

- [usar o script `install.sh`](#install-via-installsh-all-in-one);
- ou [fazer a instalação manualmente](#install-by-hand).

### Instalação via [`install.sh`](https://raw.github.com/rogeriopradoj/php-build-plugin-composer/master/install.sh), tudo em um!

```shell
$ CURRENT_DIR=`(pwd)` && cd `(mktemp -d -t php-build-plugin-composer)` && wget -O install.sh --no-check-certificate http://git.io/Hqr8pQ || curl -Lo install.sh http://git.io/Hqr8pQ && chmod +x install.sh && ./install.sh && cd $CURRENT_DIR
```

Se necessário, o `install.sh` pode receber uma váriavel de ambiente `PREFIX`,
a ser usada caso o php-build estiver instalado em um diretório que não seja
o `/usr/local/`. Exemplo:
   
```shell
$ PREFIX=/path_to_another_directory ./install.sh
```

### Instalação manual

**Primeiramente**, baixe o plugin (ex. no seu diretório home, `~`):

- Ou via `wget`:

```shell
# as a normal account user, $

cd ~
rm -rf php-build-plugin-composer-master master.tar.gz
wget https://github.com/rogeriopradoj/php-build-plugin-composer/archive/master.tar.gz --no-check-certificate
tar -vzxf master.tar.gz
```

- Ou via `curl`:

```shell
$ cd ~
$ rm -rf php-build-plugin-composer-master master.tar.gz
$ curl -LO https://github.com/rogeriopradoj/php-build-plugin-composer/archive/master.tar.gz
$ tar -vzxf master.tar.gz
```

- Ou via `git clone`:

```shell
$ cd ~
$ rm -rf php-build-plugin-composer-master master.tar.gz
$ git clone https://github.com/rogeriopradoj/php-build-plugin-composer.git php-build-plugin-composer-master
```

**Segundo**, garanta que o `composer.sh` em `share/php-build/after-install.d/` está
executável, exemplo:

```shell
$ cd ~/php-build-plugin-composer-master
$ chmod +x share/php-build/after-install.d/composer.sh
```

**Por fim**, copie o diretório `share` na sua instalação do `php-build`, ou
faça um link de `share/php-build/after-install.d/composer.sh` para
`share/php-build/after-install.d/` na sua instalação do `php-build`.

- Copiando

```shell
$ cd ~/php-build-plugin-composer-master
$ cp -r share /usr/local
```

- Fazendo o link
   
```shell
$ cd /usr/local/share/php-build/after-install.d
$ ln -s ~/php-build-plugin-composer-master/share/php-build/after-install.d/composer.sh
```

*Nota 1:* Os dois exemplos acima presupõem que você tenha o `php-build`
instalado no local padrão. Caso contrário, ajuste.

*Nota 2:* Se você não tiver permissão para escrever naquele diretório, execute
os commandos como superusuário, ou com `su -c` ou `sudo`.


## Changelog

Veja o arquivo [README.md](README.md).

## Como contribuir

Veja o arquivo [CONTRIBUTE.md](CONTRIBUTE.md).
