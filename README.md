# haasbot_docker
Docker for Haasbot Haasonline

Install docker and docker-composer: 
  Docker https://goo.gl/yB3uEn
  Composer: https://goo.gl/bW8mim

Clone Repo: sudo git clone https://github.com/tonymorella/haasbot_docker.git

Copy linux32.tar file to repo directory

Build:
  sudo docker-compose build
  sudo docker-compose up -d

To access localy:
  sudo docker exec -ti haasonline_haasbot /bin/bash
