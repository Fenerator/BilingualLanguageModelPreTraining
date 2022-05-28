#!/bin/bash
# Copyright (c) 2019-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

lg=$1

if [ $lg == "tr" ]; then
    echo "*** Preprocessing vocabulary for $lg small training set ... ***"
fi
