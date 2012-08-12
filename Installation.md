## Installation

### Installation: Hardware required

1. DMX USB Pro
1. Mac running OSX (Lion preferred)
  * homebrew package manager [install instructions here](https://github.com/mxcl/homebrew/wiki/installation)
    1. install homebrew itself

      ```bash
      /usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"
      ```

    2. ONLY DO IF YOU DO NOT ALREADY HAVE XCODE: install compilers and command line tools

        * OS X 10.7 Lion: [GCC-10.7.pkg](https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.7-v2.pkg)
        * OS X 10.6 Snow Leopard: [GCC-10.6.pkg](https://github.com/downloads/kennethreitz/osx-gcc-installer/GCC-10.6.pkg)

1. Cables

  * USB 1.0 cable
  * 1x XLR 5-pin to XLR 3 pin
  * 11x XLR 3-pin male to XLR 3-pin female

### Installation: Software Installation

1. Install Homebrew packages
    * see Troubleshooting section below if you get errors

    ```bash
    brew install git
    brew tap marshally/homebrew-alt
    brew install kinectable_pipe
    brew install open-lighting
    ````

1. Install ruby 1.9.3, if you don't have it already

    ```bash
    brew install rbenv
    echo 'if which rbenv > /dev/null; then eval "\$(rbenv init -)"; fi' >> .bash_profile
    brew install ruby-build
    rbenv install 1.9.3-p194
    rbenv rehash
    ```

1. install ball_of_light excitements
    ```bash
    git clone https://github.com/marshally/ball_of_light
    cd ball_of_light
    bundle install --path vendor/bundle --deployment
    bin/ball_of_light link
    ```

2. Install DMX USB Pro drivers from [http://www.ftdichip.com/Drivers/VCP.htm](http://www.ftdichip.com/Drivers/VCP.htm)


### Installation: Hardware Installation

1. plug in MS Kinect
    * check that Kinect is operational

        ```bash
        ball_of_light test --only kinect
        ```

1. plug in DMX USB Pro
    1. check that the DMX USB Pro is operational

        ```bash
        ball_of_light test --only dmx
        ```

    1. configure DMX ports

        ```bash
        ball_of_light configure
        ```

    1. check that the Open Lighting Architecture system is operational

        ```bash
        ball_of_light test --only ola
        ```

3. Open up the OLA admin console at '[http://localhost:9090/](http://localhost:9090/)'

    ![OLA Console](http://marshally.github.com/ball_of_light/OLA_Admin_one.jpg)

4. Add a new universe
    * universe id=1
    * universe name=BALL_OF_LIGHT
    * select Open DMX Pro OUTPUT
    * click Add Universe (scroll to bottom)

    ![Add Universe](http://marshally.github.com/ball_of_light/OLA_Admin_configure_universe.jpg)
1. Daisy chain connect all of the lights together
1. Set each light to a unique DMX control number, offset by 5
    * e.g. 1,6,11,16,21,26,31,36,41,46,51,56

    ```bash
    ball_of_light lights --list
    ```

1. check that lights are operational with

    ```bash
    ball_of_light lights --center
    ```

1. what to see the raw commands that the lights are executing? pass in --testing

    ```bash
    ball_of_light lights --center --testing
    ```

1. run one of the project scripts

    ```bash
    ruby scripts/0.rb
    # or
    TEST=on ruby scripts/hug.rb
    ```

### Installation: Troubleshooting

If you are having trouble installing pkg-config-2.7 you can cheat with these commands:

```bash
brew install wget
rm /usr/local/Library/Formula/pkg-config.rb
wget  https://raw.github.com/mxcl/homebrew/63415cccaecf9cccf204570ea2242b56ce0ffdc4/Library/Formula/pkg-config.rb /usr/local/Library/Formula/
brew install ball_of_light
```

If the Kinect is not working, you might have to use this command to add the
OpenNI environment variable. (homebrew would have asked you to do this earlier,
but it is easy to miss).

```bash
echo 'export OPEN_NI_INSTALL_PATH=/usr/local' >> ~/.bash_profile
```
