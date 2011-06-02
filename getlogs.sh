#!/bin/bash

rm data/continuous/*
scp qa:/tmp/continuous.zip data/continuous
unzip -d data/continuous data/continuous/continuous.zip

rm data/nightly/*
scp qa:/tmp/nightly.zip data/nightly
unzip -d data/nightly data/nightly/nightly.zip
