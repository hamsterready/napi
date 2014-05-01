#!/bin/bash

# prepare the environment
vagrant ssh -c 'cd /vagrant/testcases && ./prepare_gcc3.sh && ./prepare.pl'

