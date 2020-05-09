FROM archlinux/base:latest

# Prepare build environment
RUN pacman -Sy --noconfirm gcc \
	&& pacman -Sy --noconfirm ruby rubygems rake \
	&& pacman -Sy --noconfirm wget \
	&& pacman -Sy --noconfirm git \
	&& pacman -Sy --noconfirm openssl

RUN gem install Mxx_ru

ARG hgrev=HEAD

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/sobjectizer \
	&& cd sobjectizer \
	&& git checkout $hgrev

RUN echo "*** Building SObjectizer ***" \
	&& export PATH=${PATH}:~/.gem/ruby/2.7.0/bin \
	&& cd /tmp/sobjectizer/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET=gcc_linux ruby build_all.rb --mxx-cpp-release

