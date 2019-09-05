FROM ubuntu:18.04

# Prepare build environment
RUN apt-get update && \
    apt-get -qq -y install gcc g++ \
	 git

RUN apt-get -qq -y install ruby \
	&& gem install Mxx_ru

ARG hgrev=HEAD

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/sobjectizer \
	&& cd sobjectizer \
	&& git checkout $hgrev

RUN echo "*** Building SObjectizer ***" \
	&& cd /tmp/sobjectizer/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET=gcc_linux ruby build_all.rb --mxx-cpp-release

