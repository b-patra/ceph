#!/usr/bin/perl

use strict;

my $usage = "./push_to_client.pl <path_to_kernel_git_tree>\n";

my $kernel = shift @ARGV || die $usage;
die $usage unless -d $kernel;
die $usage unless -e "$kernel/fs/ceph/README";

die "not in a git tree" unless `cd $kernel && git rev-parse HEAD`;

my $dir = '.';
until (-d "$dir/.git") {
    $dir .= "/..";
}

print "pushing changed shared files from $dir to $kernel...\n";
my @files = split(/\n/, `cat $kernel/fs/ceph/README`);
for (@files) {
    next if /^#/;
    my ($orig, $new) = split(/\s+/, $_);
    #print "$dir/$orig -> $new\n";
    system "cp -uv $dir/$orig $kernel/$new";
}

print "pulling changed shared files from $dir to $kernel...\n";
system "cp -uv $kernel/fs/ceph/ioctl.h $dir/src/client/ioctl.h";

print "done.\n";

