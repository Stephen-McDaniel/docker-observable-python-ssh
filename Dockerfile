FROM python:3.12.5-bullseye
  
ARG PASSWORD
ARG PROJECTS=/root/python/projects

LABEL author=smartdatasecrets.com

ENV PYTHON_VER=3.12.5

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && apt purge -y python3.9 \
    && mkdir /root/python \
    && mkdir ${PROJECTS}

ADD --chmod=755 https://astral.sh/uv/install.sh ${PROJECTS}/install.sh
RUN ${PROJECTS}/install.sh && rm ${PROJECTS}/install.sh
  
RUN apt-get update
RUN apt install -y build-essential 
RUN apt install -y libssl-dev 
RUN apt install -y libffi-dev 
RUN DEBIAN_FRONTEND='noninteractive' apt install  openssh-server sudo -y

RUN echo root:${PASSWORD} | chpasswd \
    && service ssh start

RUN apt update && apt install -y apt-transport-https ca-certificates dirmngr \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4

# uncomment the next 3 lines if you want to login via ssh key file instead of password
RUN mkdir -p /root/.ssh
COPY ./build/id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh \
    && chmod 600 /root/.ssh/authorized_keys

RUN apt install -y python3-pip

RUN /usr/bin/python3 -m pip install ipykernel -U --user --force-reinstall

WORKDIR ${PROJECTS}

COPY ./build/requirements.txt ${PROJECTS}/requirements.txt

RUN /root/.local/bin/uv pip install --system --no-cache -r ${PROJECTS}/requirements.txt

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash - \
  && apt install -y nodejs \
  && apt install -y build-essential

# check versions
# node -v
# npm -v

# Install VS Code Server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Install VS Code extensions (Python and Jupyter)
RUN code-server --install-extension ms-python.python
RUN code-server --install-extension ms-toolsai.jupyter

RUN npm install -g @observablehq/runtime

WORKDIR /workspace

RUN touch buildcomplete

CMD ["/usr/sbin/sshd","-D"]
