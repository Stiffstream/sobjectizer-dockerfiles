FROM archlinux:latest

# Prepare build environment
RUN pacman -Sy --noconfirm gcc \
	&& pacman -Sy --noconfirm ruby rubygems rake \
	&& pacman -Sy --noconfirm wget \
	&& pacman -Sy --noconfirm git \
	&& pacman -Sy --noconfirm openssl

RUN echo "*** Getting CMake ***" \
	&& pacman -Sy --noconfirm cmake make

ARG hgrev=HEAD

RUN echo "*** Downloading SObjectizer ***" \
	&& cd /tmp \
	&& git clone https://github.com/stiffstream/sobjectizer \
	&& cd sobjectizer \
	&& git checkout $hgrev

RUN echo "*** Building SObjectizer ***" \
	&& cd /tmp/sobjectizer/dev \
	&& mkdir cmake_build \
	&& cd cmake_build \
	&& cmake -DCMAKE_INSTALL_PREFIX=target \
		-DBUILD_ALL=ON \
		-DCMAKE_BUILD_TYPE=Release .. \
	&& cmake --build . --config Release --parallel 3 \
	&& cmake --build . --target test \
	&& cmake --build . --target install

