UP_TARGETS := --up-title --up-pre-actions --up-create-network --up-create-volume --up --ssh --up-post-actions

define RESOLVER_BODY_DARWIN
# Generated by druidfi/stonehenge
nameserver 127.0.0.1
port 6053
endef

define RESOLVER_BODY_LINUX
# Generated by druidfi/stonehenge
nameserver 127.0.0.48
endef

PHONY += up
up: $(UP_TARGETS) ## Launch Stonehenge

PHONY += --up-title
--up-title:
	$(call step,Start Stonehenge on $(OS))

export RESOLVER_BODY_DARWIN
PHONY += --up-pre-actions
--up-pre-actions:
ifeq ($(OS),Darwin)
	$(call step,Create resolver file on $(OS)...)
	@test -d /etc/resolver || sudo mkdir -p /etc/resolver
	@sudo sh -c "printf '$$RESOLVER_BODY_DARWIN' > /etc/resolver/${DOCKER_DOMAIN}" && echo "Resolver file created"
else ifeq ($(OS),ubuntu)
else ifeq ($(OS),linux)
endif

PHONY += --up-create-network
--up-create-network:
	$(call step,Create network ${NETWORK_NAME} on $(OS)...)
	@docker network inspect ${NETWORK_NAME} > /dev/null || \
		docker network create ${NETWORK_NAME} && echo "Network created"

PHONY += --up-create-volume
--up-create-volume:
	$(call step,Create volume ${SSH_VOLUME_NAME} on $(OS)...)
	@docker volume inspect ${SSH_VOLUME_NAME} > /dev/null || \
		docker volume create ${SSH_VOLUME_NAME} && echo "SSH volume created"

PHONY += --up
--up:
	$(call step,Start the containers on $(OS)...)
	@${DOCKER_COMPOSE_CMD} up -d --force-recreate --remove-orphans

PHONY += --ssh
--ssh:
	$(call step,Adding your SSH key on $(OS)...)
	@test -f ~/.ssh/id_rsa && docker run --rm -it \
		--volume=$$HOME/.ssh/id_rsa:/$$HOME/.ssh/id_rsa \
		--volumes-from=${PREFIX}-ssh-agent \
		--name=${PREFIX}-ssh-agent-add-key \
		amazeeio/ssh-agent ssh-add ~/.ssh/id_rsa || echo "No SSH key found"

export RESOLVER_BODY_LINUX
PHONY += --up-post-actions
--up-post-actions:
ifeq ($(OS),Darwin)
else ifeq ($(OS),ubuntu)
	$(call step,Handle DNS on $(OS) $(UBUNTU_VERSION)...)
	sudo /bin/cp -rf /etc/resolv.conf /etc/resolv.conf.default
	sudo /bin/cp -rf /etc/systemd/resolved.conf /etc/systemd/resolved.conf.default
	sudo sh -c "printf '$$RESOLVER_BODY_LINUX' >> /etc/resolv.conf"
	sudo sh -c "echo "DNSStubListener=no" >> /etc/systemd/resolved.conf"
	sudo systemctl daemon-reload
	sudo systemctl restart systemd-resolved.service
else ifeq ($(OS),linux)
endif
	$(call success,SUCCESS! Open http://portainer.${DOCKER_DOMAIN} ...)
