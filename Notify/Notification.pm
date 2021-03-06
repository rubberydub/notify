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


package Notify::Notification;

use strict;
use warnings;
use Notify::Logger;
use Notify::RecipientFactory;
use Time::Piece;

sub new {
    my ($class, $recipient, $body, $subject) = @_;
    my $self = {
        _time      => time,
        _recipient => $recipient,
        _body      => $body,
        _subject   => $subject,
    };

    bless $self, $class;
}

sub get_recipient {
    shift->{_recipient};
}

sub get_body {
    shift->{_body};
}

sub get_subject {
    shift->{_subject};
}

sub get_time {
    shift->{_time};
}

sub get_human_time {
    my $self = shift;
    my $t = Time::Piece->strptime($self->{_time}, '%s');
    $t->cdate;
}

sub send {
    my $self = shift;
    Notify::Logger->write("Sending notification to "
                          . $self->{_recipient}->get_label);
    $self->{_recipient}->send($self->{_body}, $self->{_subject});
}

sub create_from_decoded_json {
    my ($class, $decoded) = @_;
    my $self = $class->new(
        Notify::RecipientFactory::create(
            $decoded->{recipient}->{label}
        ),
        $decoded->{body},
        $decoded->{subject},
    );

    return $self;
}

sub TO_JSON {
    my $self = shift;
    my $output = {
        recipient => $self->{_recipient},
        body      => $self->{_body},
        subject   => $self->{_subject},
        time      => $self->{_time},
    };

    return $output;
}

sub matches {
    my ($self, $other) = @_;

    my $criteria = {
        _label   => $self->{_recipient}->{_label},
        _subject => $self->{_subject},
        _body    => $self->{_body},
    };

    foreach my $key (keys %$criteria) {
        return 0 if defined $other->{$key}
            and $criteria->{$key} ne $other->{$key};
    }

    return 1;
}

1;
