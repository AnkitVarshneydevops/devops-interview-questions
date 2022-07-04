#!/bin/bash
sudo apt update -y
sudo apt install ansible -y
sudo apt install net-tools -y
sudo tee -a docker.yml > /dev/null<<EOF
- hosts: localhost
  become_user: root
  become: yes
  tasks:
  - name: Install aptitude
    apt:
      name: aptitude
      state: latest
      update_cache: true

  - name: Install required system packages
    apt:
      pkg:
        - apt-transport-https
        - ca-certificates
        - curl
        - software-properties-common
        - python3-pip
        - virtualenv
        - python3-setuptools
      state: latest
      update_cache: true

  - name: Add Docker GPG apt Key
    apt_key:
      url: https://download.docker.com/linux/ubuntu/gpg
      state: present

  - name: Add Docker Repository
    apt_repository:
      repo: deb https://download.docker.com/linux/ubuntu focal stable
      state: present
  - name: Update apt and install docker-ce
    apt:
      name: docker-ce
      state: latest
      update_cache: true

  - name: Install Docker Module for Python
    pip:
      name: docker
  - name: Create a nginx container
    docker_container:
      name: nginx
      image: nginx
      state: started
      recreate: yes
      ports:
        - "8080:80"
EOF
sudo ansible-playbook /docker.yml
