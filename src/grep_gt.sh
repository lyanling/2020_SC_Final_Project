#!/bin/bash
a='_groundtruth.txt'
b='_gt.txt'

for i in {1..500}
do
	src="./MIR-ST500/$i/$i${a}"
	des="./sample500/$i${b}"
	#echo $src
	#echo $des
	cp $src $des
done