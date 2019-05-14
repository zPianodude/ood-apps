# Batch Connect - Example Tensorboard Server Container

An example Batch Connect app that launches a Tensorboard server container within a
batch job.

## Prerequisites

This Batch Connect app requires Docker software be installed on the
**compute nodes** that the batch job is intended to run on (**NOT** the
OnDemand node):

- [Docker](https://runnable.com/docker/install-docker-on-linux)

## Install

These are command line only installation directions.

We start by downloading a zipped package of this code. This allows us to start
with a fresh directory that has no git history as we will be building off of
this.

```sh
# Download the zip from the GitHub page
wget https://gitlab-master.nvidia.com/lcapps/cluw/-/archive/master/cluw-master.tar.gz

# Create a catchy directory
mkdir my_tensorboard_app

# Unzip the downloaded file into this directory
tar xzvf cluw-master.tar.gz -C my_tensorboard_app --strip-components=1

# Change the working directory to this new directory
cd my_tensorboard_app
```

From here you will make any modifications to the code that you would like and
version your changes in your own repository:

```sh
# Version our app by making a new Git repository
git init

#
# Make all your code changes while testing them in the OnDemand Dashboard
#
# ...
#

# Add the files to the Git repository
git add --all

# Commit the staged files to the Git repository
git commit -m "my first commit"
```

## Contributing

1. Fork it ( https://gitxxx/lcapps/cluw/bc_example_tensorboard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
