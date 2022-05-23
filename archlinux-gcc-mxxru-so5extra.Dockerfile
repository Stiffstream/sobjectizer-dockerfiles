FROM archlinux:latest

# Prepare build environment
RUN pacman -Sy --noconfirm gcc \
	&& pacman -Sy --noconfirm ruby rubygems rake \
	&& pacman -Sy --noconfirm wget \
	&& pacman -Sy --noconfirm git \
	&& pacman -Sy --noconfirm openssl

RUN \
	export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" \
	&& export PATH="$PATH:$GEM_HOME/bin" \
	&& gem install Mxx_ru

ARG hgrev=HEAD

RUN echo "*** Downloading so5extra ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/so5extra \
	&& cd so5extra \
	&& git checkout $hgrev

# COPY so5extra-externals.rb /tmp/so5extra/externals.rb

RUN echo "*** Building so5extra ***" \
	&& export GEM_HOME="$(ruby -e 'puts Gem.user_dir')" \
	&& export PATH="$PATH:$GEM_HOME/bin" \
	&& cd /tmp/so5extra \
	&& mxxruexternals \
	&& cd /tmp/so5extra/dev \
	&& cp local-build.rb.example local-build.rb \
	&& MXX_RU_CPP_TOOLSET=gcc_linux ruby build.rb --mxx-cpp-release

