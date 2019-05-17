FROM ubuntu:18.04

# Prepare build environment
RUN apt-get update && \
    apt-get -qq -y install gcc g++ \
	 mercurial

RUN apt-get -qq -y install ruby \
	&& gem install Mxx_ru

ARG hgrev=tip

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& hg clone https://bitbucket.com/sobjectizerteam/sobjectizer \
	&& cd sobjectizer \
	&& hg up -r $hgrev

RUN echo "*** Building SObjectizer ***" \
	&& cd /tmp/sobjectizer/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET=gcc_linux ruby build_all.rb --mxx-cpp-release

