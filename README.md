# What is Protlak

Protlak is mac script that helps you focus on work and avoid procrastination. To turn it on, run:

```bash
sudo ./protlak.sh work
```

It will turn off mail, set your skype status to do-not-disturb and redirect HTTP traffic to unproductive websites to local instance of node.js server, that tells you to get back to work.

To turn it off, run:

```bash
sudo ./protlak.sh play
```

## Warning

This script is provided as-is, with no warranty. It works on my computer!

## Acknowledgements

This script is written in duct-type-programming style, bringing together various scripts found on internet. 
Updating the hosts file and general structure of the script is taken from https://github.com/leftnode/get-shit-done . 
AppleScripts that manipulate running apps are copied from http://www.jirifabian.net/wordpress/?p=374 .
Idea of bringing up local HTTP server that shows helpful message every time you try to access blocked site is inspired
by @jurahu.