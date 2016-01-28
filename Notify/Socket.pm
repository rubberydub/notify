#!/usr/bin/perl
#
# Copyright (C) 2014  Mikey Austin <mikey@jackiemclean.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


package Notify::Socket;

use strict;
use warnings;
use Notify::Config;
use Notify::Message;
use Notify::Logger;
use Data::Dumper;

sub new {
    my ($class, $args) = @_;

    my $self = {
        _options     => $args,
        _unix_socket => undef,
        _inet_socket => undef,
    };

    bless $self, $class;

    return $self;
}

#
# Returns an array of sockets/io handles
# TODO: Not this! Violates encapsulation.
#
sub get_handles {
    my $self = shift;

    my @handles = ($self->{_unix_socket});

    push @handles, $self->{_inet_socket}
        if defined $self->{_inet_socket};

    return @handles;
}

#
# Adds the socket handles to the select interface parameter.
#
sub add_handles {
    my ($self, $select) = @_;

    $select->add($self->{_unix_socket});
    $select->add($self->{_inet_socket})
        if(defined $self->{_inet_socket});
}

1;
