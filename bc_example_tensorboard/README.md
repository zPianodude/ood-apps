# Batch Connect - Example Tensorboard Server Container

An example Batch Connect app that launches a Tensorboard server container within a
batch job.

## Prerequisites

This Batch Connect app requires Docker software be installed on the
**compute nodes** that the batch job is intended to run on (**NOT** the
OnDemand node):

- [Docker](https://runnable.com/docker/install-docker-on-linux)

## Install

You can install to your home directory and run as a personal template or install in your site main OOD directory

# Home directory install
```sh
# Download the zip from the GitHub page
git clone https://github.com/zPianodude/ood-apps.git
cd ood-apps

# Copy the example to your ondemand home directory
cp -R bc_example_tensorboard ~/ondemand/dev/bc_example_tensorboard
(~/demand may be different for your site)
```
# Site shared install
<tbd>

# Update files for your site if needed
submit.yml.erb - may need to update the queue and account names
templates/script.sh.erb - may need to update the docker run command for your site

## Using
For the home diretory install, once the app is placed in your ondemand dir, it should show up in your OOD web page under the develop pulldown in the my sandbox apps
