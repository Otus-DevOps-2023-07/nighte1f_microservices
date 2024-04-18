# nighte1f_microservices
nighte1f microservices repository

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
