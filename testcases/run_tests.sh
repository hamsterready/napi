#!/bin/bash

path_root="/home/vagrant";

# prepare the environment
vagrant ssh -c "/vagrant/testcases/prepare_gcc3.sh $path_root"
vagrant ssh -c "cd /vagrant/testcases && ./prepare.pl $path_root"

