FROM archlinux:latest

# Prepare build environment
RUN pacman -Sy --noconfirm clang \
	&& pacman -Sy --noconfirm ruby rubygems rake \
	&& pacman -Sy --noconfirm wget \
	&& pacman -Sy --noconfirm git \
	&& pacman -Sy --noconfirm openssl

RUN pacman -Sy --noconfirm libffi

RUN \
	export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" \
	&& export PATH="$PATH:$GEM_HOME/bin" \
	&& gem install Mxx_ru

ARG hgrev=HEAD

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/sobjectizer \
	&& cd sobjectizer \
	&& git checkout $hgrev

RUN echo "*** Building SObjectizer ***" \
	&& export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" \
	&& export PATH="$PATH:$GEM_HOME/bin" \
	&& cd /tmp/sobjectizer/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET=clang_linux ruby build_all.rb --mxx-cpp-release

