FROM ubuntu:19.04

# Prepare build environment
RUN apt-get update && \
    apt-get -qq -y install gcc-9 g++-9 \
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
	&& MXX_RU_CPP_TOOLSET="gcc_linux c_compiler_name=gcc-9 cpp_compiler_name=g++-9 linker_name=g++-9" ruby build_all.rb --mxx-cpp-release

