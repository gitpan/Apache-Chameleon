#!/usr/local/bin/perl -wT
use strict;
use lib qw(../lib);

use Test::More tests => 1;

use_ok('Apache::Chameleon');
use Apache::Chameleon;

#use_ok('Apache::Chameleon::Test::FakeRequest');
#use Apache::Chameleon::Test::FakeRequest;

#$Apache::Chameleon::Test::FakeRequest::CONFIG = { 
#    dbconn => 'dbi:mysql:Chameleon', 
#    dbuser => 'root', 
#    dbpass => 'passwd' }; 

#$Apache::Chameleon::Test::FakeRequest::PARAMETERS = { 
#    'User-Agent' => 'lwp-request/2.01',
#    content => ('foo', 'bar'), 
#    args => ('baz', 'zoo') };

#my $r = Apache::Chameleon::Test::FakeRequest->new();

#print STDERR $r->dir_config('dbconn');
#isa_ok($r, 'Apache::Chameleon::Test::FakeRequest', 'Apache::FakeRequest instance');

#my $ret = Apache::Chameleon->handler($r);
#ok(defined $ret, 'defined value($ret)');
#ok($ret == 200, 'handler returned 200, OK');
