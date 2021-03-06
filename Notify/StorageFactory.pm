#!/usr/bin/perl
#
# Copyright (C) 2016  Mikey Austin <mikey@jackiemclean.net>
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


package Notify::StorageFactory;

use strict;
use warnings;
use Notify::Config;
use Module::Load;

sub create {
    my ($class, $type) = @_;
    my $options = Notify::Config->get('storage');
    my $storage = undef;

    if($options and $options->{enabled}) {
        my $classname = "Notify::Storage::$options->{provider}";
        load $classname;

        eval {
            $storage = $classname->new($type, $options);
        };
    }

    return $storage;
}

1;
