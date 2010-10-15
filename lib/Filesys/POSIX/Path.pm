package Filesys::POSIX::Path;

use strict;
use warnings;

sub new {
    my ($class, $path) = @_;
    my @components = split(/\//, $path);

    my @ret = grep {
        $_ && $_ ne '.'
    } @components;

    die('Empty path') unless @components || $path;

    my @hier = $components[0]? @ret: ('', @ret);

    if (@hier == 0) {
        @hier = ('.');
    } elsif (@hier == 1 && !$hier[0]) {
        @hier = ('/');
    }

    return bless \@hier, $class;
}

sub _proxy {
    my ($context, @args) = @_;

    unless (ref $context eq __PACKAGE__) {
        return $context->new(@args);
    }

    return $context;
}

sub components {
    my $self = _proxy(@_);

    return @$self;
}

sub full {
    my $self = _proxy(@_);
    my @hier = @$self;

    return join('/', @$self);
}

sub dirname {
    my $self = _proxy(@_);
    my @hier = @$self;

    if ($#hier) {
        my @parts = @hier[0..$#hier-1];

        if (@parts == 1 && !$parts[0]) {
            return '/';
        }

        return join('/', @parts);
    }

    return '.';
}

sub basename {
    my ($self, $ext) = (_proxy(@_[0..1]), $_[2]);
    my @hier = @$self;

    my $name = $hier[$#hier];
    $name =~ s/$ext$// if $ext;

    return $name;
}

sub shift {
    my ($self) = @_;
    return shift @$self;
}

sub push {
    my ($self, $part) = @_;
    return push @$self, split(/\//, $part);
}

sub pop {
    my ($self) = @_;
    return pop @$self;
}

sub count {
    my ($self) = @_;
    return scalar @$self;
}

1;