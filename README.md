# nighte1f_microservices
nighte1f microservices repository

# Homework 16
- Создана новая ветка
- С помощью терраформа создаётся хост, на который устанавливается docker-machine
	```
	gitlab-ci/terraform
	terraform apply

	Из минусов - необходимо вручную удалять докер-хост при удалении конфигурации терраформа
	docker-machine rm 'hostname'
	```

- Настроены первоначальные пайплайны
- Добавлен раннер
- Зерегестрирован раннер
- Проведена работа с локальным гитом
	```
	git remote add gitlab http://158.160.114.137/homework/example.git
	git push gitlab gitlab-ci-1
	git tag 2.4.10
	git push gitlab gitlab-ci-1 --tags
	```

- Выполнена донастройка пайплайнов

# Homework 15
- Создана новая ветка
- Выполнена работа с сетями докера
- Выполнена работа проекта с несколькими сетями
	```
	docker network create back_net --subnet=10.0.2.0/24
	docker network create front_net --subnet=10.0.1.0/24

	docker network connect front_net post
	docker network connect front_net comment
	```

- Запущен проект при помощи docker-compose
	```
	docker-compose up -d
	docker-compose ps
	```

- Добавлены параметры в конфигурацию (создан конфиг .env)
- Чтобы указать наименование проекта его необходимо запустить с ключим -p
- Создан docker-compose.override.yml


# Homework 14
- Создана новая ветка
- Скачано приложение, разбитое на несколько компонентов
- Т.к. на актуальных версиях приложение не запускается - были сделаны изменения в конфигах
- Подключаемся к докер-хосту
	```
	eval $(docker-machine env docker-host)
	```

- MongoDB скачано более ранней версии
	```
	docker pull mongo:3.1.8
	```

- В requirements.txt в post.py добавлено
	```
	Jinja2==2.3
	```

- В comment изменен докерфайл (написаны только измененные части)
	```
	FROM ruby:2.7
	RUN apt-get update -qq && apt-get install -y build-essential && gem install bundler -v 2.4.22

	RUN bundle update --bundler
	```

- В ui изменен докерфайл
	```
	FROM ruby:2.7
	RUN apt-get update -qq && apt-get install -y build-essential && gem install bundler -v 1.17.2

	RUN bundle update --bundler
	```

- Проверен запуск контейнеров с другими алиасами не пересобирая образ
Использована опция "-e, --env Set environment variables" в docker run

	```
	docker run -d --network=reddit --network-alias=post_db_new --network-alias=comment_db_new mongo:latest
	docker run -d --network=reddit -e POST_DATABASE_HOST=post_db_new -e POST_DATABASE=posts_new --network-alias=post_new tyatyushkin/post:1.0
	docker run -d --network=reddit -e COMMENT_DATABASE_HOST=comment_db_new -e ENV COMMENT_DATABASE=comments_new --network-alias=comment_new tyatyushkin/comment:1.0
	docker run -d --network=reddit -e  POST_SERVICE_HOST=post_new -e COMMENT_SERVICE_HOST=comment_new -p 9292:9292 tyatyushkin/ui:1.0
	```

- Собран образ используя alpine
	```
	docker build -t nighte1f/ui:3.0 ./ui --file ui/Dockerfile3
	```

- Создан docker volume
	```
	docker volume create reddit_db
	```
- Перезапущены и проверены контейнеры
	```
	docker kill $(docker ps -q)

	docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:3.1.8
	```


# Homework 12/13
- Создана новая ветка репе microservices
- Установлен докер
- Изучены базовые команды
	```
    docker run
	docker ps -a
	docker images
	docker rm
	docker rmi
	docker exec
	docker commit
	docker inspect
	docker system df
	```

- Установлен docker-machine
	```
    $ curl -L https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine &&
    chmod +x /tmp/docker-machine &&
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine
	```

- Изучены команды
	```
    docker-machine create
	eval $(docker-machine env <имя>) - переключиться на докер-машину
	eval $(docker-machine env --unset)- переключиться на локальный докер
	docker-machine ls
	docker-machine rm <имя>
    ```

- Создана докер-машина
	```
    yc compute instance create \
	 --name docker-host \
	 --zone ru-central1-a \
	 --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
	 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1804-lts,size=15 \
	 --ssh-key ~/.ssh/id_rsa.pub

	docker-machine create \
	 --driver generic \
	 --generic-ip-address=<ПУБЛИЧНЫЙ_IP_СОЗДАНОГО_ВЫШЕ_ИНСТАНСА> \
	 --generic-ssh-user yc-user \
	 --generic-ssh-key ~/.ssh/id_rsa \
	 docker-host
    ```

- Создан образ приложения (использовалась убунта 16.04)
	```
    docker build -t reddit:latest .
	docker run --name reddit -d --network=host reddit:latest
    ```

- Образ загружен на докерхаб
	```
    docker login
	docker tag reddit:latest <your-login>/otus-reddit:1.0
	docker push <your-login>/otus-reddit:1.0
	```

- Создан плейбук для установки докера в образ пакера
	```
    docker_install.yml
    ```

- Выданы права предыдущим сервисным аккаунтам
	```
    yc resource-manager folder add-access-binding --id 'id' --role editor --service-account-id 'acc-id'
	yc resource-manager folder add-access-binding --id 'id' --role editor --service-account-id 'acc-id'
	```

- Создана конфигурация пакера
	```
    packer build -var-file=packer/variables.pkr.hcl packer/docker.pkr.hcl
    ```

- Создана конфигурация терраформа, которая генерирует динамический конфиг ансибла
	```
    resource "local_file" "AnsibleInventory" {
	 content = templatefile("inventory.tmpl",
	 {
	  docker_ip = yandex_compute_instance.docker[*].network_interface.0.nat_ip_address,
	 }
	 )
	 filename = "../ansible/inventory.sh"
	}
    ```

    ```
	terraform apply --auto-approve=true
    ```

- Создан ansible.cfg в котором указывается наш динамический инвентори
	```
    [defaults]
	inventory = ./inventory.sh
	```

- Создан плейбук для загрузки и запуска нашего контейнера
	```
    ansible-playbook playbooks/reddit_install.yml
    ```
