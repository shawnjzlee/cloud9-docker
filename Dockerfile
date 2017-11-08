# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential curl libssl-dev apache2-utils git libxml2-dev sshfs 
RUN apt-get install -y software-properties-common python-software-properties
RUN add-apt-repository -y ppa:git-core/ppa
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN add-apt-repository -y ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get install -y gcc-5 g++-5
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 60 --slave /usr/bin/g++ g++ /usr/bin/g++-5
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN apt-get install -y ruby2.4
RUN gem install cucumber rspec

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN sudo apt-get install -y nodejs
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9

#
# Workaround, new npm version try to remove node_modules before build
# is behavior is not present on npm 4.6.1
# Let's switch to 4.6.1 temporarily then switch back
#

RUN sudo npm i -g npm@4.6.1
RUN sudo scripts/install-sdk.sh
RUN git reset HEAD --hard
RUN sudo npm i -g npm

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# Add supervisord conf
ADD conf/cloud9.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
EXPOSE 80
EXPOSE 3000

# ------------------------------------------------------------------------------
# Copy endpoint.sh bash script into container
COPY conf/endpoint.sh /bin/endpoint.sh

CMD ["endpoint.sh"]
