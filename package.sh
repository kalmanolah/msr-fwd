#!/bin/bash

MSR_FWD_VERSION="0.0.1"

cd "$(dirname "$0")"

mkdir -p build
mkdir -p build/usr/local/etc
mkdir -p build/usr/local/bin
mkdir -p build/usr/lib/systemd/system

cp msr-fwd.cfg build/usr/local/etc/
cp msr-fwd.sh build/usr/local/bin/
cp msr-fwd.service build/usr/lib/systemd/system/

for TARGET in rpm deb
do
    fpm -f -s python -t $TARGET \
        --python-bin python3 \
        --python-disable-dependency pyusb \
        --depends python-usb \
        ./msr-cli/setup.py

    fpm -f -s dir -t $TARGET \
        --name "msr-fwd" \
        --version "$MSR_FWD_VERSION" \
        --iteration "1" \
        --architecture noarch \
        --prefix / \
        --vendor "Inuits" \
        --description "Magnetic Stripe Reader CLI + Magnetic Stripe Reader Forwarder" \
        --depends "python-msr-cli" \
        --maintainer "Kalman Olah <kalman@inuits.eu>" \
        --exclude "rpmbuild" \
        --epoch "1" \
        --rpm-auto-add-directories \
        --url "https://github.com/kalmanolah/msr-fwd" \
        -C ./build .
done
