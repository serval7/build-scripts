#!/bin/sh -ue

current=$(cd $(dirname ${BASH_SOURCE:-$0}); pwd)
export PATH=${current}/install/bin:${PATH}
