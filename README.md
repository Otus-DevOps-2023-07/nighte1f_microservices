# nighte1f_microservices
nighte1f microservices repository

# Homework 20
- Создана новая ветка
- Установлен миникуб
	```
	minikube start
	kubectl get po -A
	```

- Создан новый кластер
	```
	kubectl config set-cluster 'cluster_name'
	kubectl config set-credentials 'user_name'
	kubectl config set-context context_name \
	--cluster=cluster_name \
	--user=user_name
	kubectl config use-context context_name
	```

- Текущий контекст
	```
	kubectl config current-context
	```

- Все контексты
	```
	kubectl config get-contexts
	```
- Созданы и запущены деплои
	```
	kubectl apply -f ./kubernetes/reddit
	```

- Проверен проброс портов
	```
	kubectl get pods --selector component=ui
	kubectl port-forward <pod-name> 8080:9292
	```

- Созданы и запущеный сервисы
	```
	kubectl apply -f 'service_name'.yml
	```

- Добавлен nodePort для ui (почему-то не хочет работать при использовании докера)
	```
	minikube service ui
	minikube service list
	```

-UPD Переделан миникуб с использованием virtualbox (В ДЕФОЛТЕ ВСЕ ЖЕ ИСПОЛЬЗУЕТ ДОКЕР)
	```
	Удаляем предыдущий
	minikube delete
	minikube start --vm-driver=virtualbox

	!!! Если ругается на KVM - стопаем его и запускаем заново миникуб
	lsmod | grep kvm
	sudo rmmod 'kvm_name'
	```

- Просмотрены аддоны
	```
	minikube addons list
	```

- Включаем аддон dashboard
	```
	minikube addons enable dashboard
	```

- Т.к. он требует наличия аддона metrics-server то включаем и его
	```
	minikube addons enable metrics-server
	```

- Смотрим в каком namespace находится аддон
	```
	minikube service list
	> kubernetes-dashboard
	```

- Получаем инфу об объектах
	```
	kubectl get all -n kubernetes-dashboard --selector k8s-app=kubernetes-dashboard
	```

- Заходим в дашборд
	```
	minikube dashboard --url
	```

- Посмотрены возможности дашборда
- Создан новый namespace
	```
	kubectl apply -f dev-namespace.yml
	```

- Запущено приложение в новом namespace
	```
	kubectl apply -n dev -f
	minikube service ui -n dev
	```

- Развернут кластер в YC
- Добавлена группа узлов
- Произведено подключение к кластеру с локальной вм
	```
	yc managed-kubernetes cluster get-credentials <cluster-name> --external
	```

- Задеплоено приложение в кластер YC в dev namespace
	```
	kubectl apply -f ./kubernetes/reddit/dev-namespace.yml
	kubectl apply -f ./kubernetes/reddit/ -n dev

	kubectl get nodes -o wide
	kubectl describe service ui -n dev | grep NodePort
	```

# Homework 19
- Создана инфра с помощь терраформа и ансибла
- Созданы deployment конфиги
- Создан кластер кубера, т.к. используется свежая версия пришлось устанавливать cri-docker на обоих нодах
	```
	wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.7/cri-dockerd_0.3.7.3-0.ubuntu-bionic_amd64.deb
	apt-get install ./cri-dockerd_0.3.7.3-0.ubuntu-bionic_amd64.deb -y
	```

- Инициализация кластера
	```
	kubeadm init --apiserver-cert-extra-sans=158.160.127.173 --apiserver-advertise-address=0.0.0.0 --control-plane-endpoint=158.160.127.173 --pod-network-cidr=10.244.0.0/16 --cri-socket unix:///var/run/cri-dockerd.sock
	kubeadm join 158.160.127.173:6443 --token 96jyz9.klmqnfwlyfk2mus2 --discovery-token-ca-cert-hash sha256:'HASH' --cri-socket unix:///var/run/cri-dockerd.sock
	```

- На мастер ноде установлен сетевой плагин
	```
	kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/tigera-operator.yaml
	curl https://raw.githubusercontent.com/projectcalico/calico/v3.27.3/manifests/custom-resources.yaml -O
	!!!изменяем сеть в custom-resources.yaml 10.244.0.0/16
	kubectl create -f custom-resources.yaml
	Смотрим чтобы всё выполнилось
	watch kubectl get pods -n calico-system
	```

- Устанавливаем kubectl локально и добавляем конфиг кубера (если работаете под рутом - cat /etc/kubernetes/admin.conf (мастер нода))
- Применяем деплои
	```
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f comment-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f post-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f ui-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f mongo-deployment.yml
	```

- Проверяем что всё запустилось
	```
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' get pods --output=wide
	```

- Так же можно проверить само приложение запустив трафик на контейнера
	```
	На мастер ноде
	kubectl port-forward 'ui container name' --address 0.0.0.0 9292:9292
	```

- Полезные команды
	```
	kubectl get nodes - показывает ноды кластера
	kubectl describe node 'node name' - инфа о ноде
	kubectl get pods - показывает поды
	kubectl describe pod 'pode name' - инфа о поде
	kubectl delete node 'node name' - удалить ноду
	kubeadm reset - сброс ВСЕХ настроек кластера
	```

- Запуск проекта
	```
	cd kubernetes/terraform
	terraform init
	terraform apply
	cd ../ansible
	ansible-playbook playbooks/kuber_install.yml
	cd ../reddid
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f comment-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f post-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f ui-deployment.yml
	kubectl --insecure-skip-tls-verify --kubeconfig 'path to conf' apply -f mongo-deployment.yml
	```

# Homework 18
- Создана новая ветка
- Поднята инфа с помощью терраформа
- Скачана новая версия приложения
- Созданы новые докер образы
- Создан отдельный compose файл для логирования
- Создан отдельный образ для fluentd (сборка образа была изменена на корректную)
	```
	FROM fluent/fluentd:v1.16.2-1.1
	USER root
	RUN gem uninstall -I elasticsearch && gem install elasticsearch -v 7.17.0
	RUN gem install fluent-plugin-elasticsearch --no-document --version 5.0.3
	RUN gem install fluent-plugin-grok-parser --no-document --version 2.6.2
	ADD fluent.conf /fluentd/etc
	```

- Прозведена работа с кибаной
- Добавлены фильтры
- Добавлены фильтры для неструктурированых логов
- Добавлены фильтры с помощью grok-шаблонов (изменены на корректные для свежей версии)
	```
	<filter service.ui>
	  @type parser
	  <parse>
		@type grok
		<grok>
		  pattern %{RUBY_LOGGER}
		</grok>
	  </parse>
	  key_name log
	</filter>

	<filter service.ui>
	  @type parser
	  <parse>
		@type grok
		<grok>
		  pattern service=%{WORD:service} \| event=%{WORD:event} \| request_id=%{GREEDYDATA:request_id} \| message='%{GREEDYDATA:message}'
		</grok>
	  </parse>
	  key_name message
	  reserve_data true
	</filter>
	```

- Произведена работа с zipkin
- Запуск проекта
	```
	cd logging/infra/terraform
	terraform apply --auto-approve=true
	eval $(docker-machine env logging)
	cd docker
	make
	make push
	docker-compose up -d
	docker-compose -f docker-compose-logging.yml up -d
	```

- Проверка проекта
	```
	'внешний адрес':9292 - reddit
	'внешний адрес':5601 - kibana
	'внешний адрес':9411 - zipkin
	```

# Homework 17
- Создана новая ветка
- Резвернута вм с помощью терраформа
- Запущен Prometheus
- Изменена структура директорий
- Создан докер образ прометеуса
- Созданы образы микросервисов
- Добавлены экспортеры для мониторига
- Добавлен экспортер для mongodb
- Добавлен экспортер blackbox
- Создан make file
	```
	make - создание образов
	make push - пуш на докерхаб
	```

- Запуск проекта
	```
	в каталоге docker:
	eval $(docker-machine env docker-host-0)
	make
	docker-compose up -d
	```

- Проверка проекта
	```
	'внешний адрес':9292 - reddit
	'внешний адрес':9090 - prometheus
	'внешний адрес':9115 - blackbox
	```

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
