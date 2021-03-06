FROM ubuntu:19.10

# Prepare build environment
RUN apt-get update && \
    apt-get -qq -y install gcc-9 g++-9 \
	 git

RUN apt-get -qq -y install ruby \
	&& gem install Mxx_ru

ARG hgrev=HEAD

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/sobjectizer \
	&& cd sobjectizer \
	&& git checkout $hgrev

# RUN apt-get -qq -y install vim bash

RUN echo "*** Building SObjectizer ***" \
	&& cd /tmp/sobjectizer/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET="gcc_linux c_compiler_name=gcc-9 cpp_compiler_name=g++-9 linker_name=g++-9" ruby build_all.rb --mxx-cpp-release

