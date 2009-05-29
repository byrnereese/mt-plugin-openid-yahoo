package MT::Auth::Yahoo;
use strict;

use base qw( MT::Auth::OpenID );

sub url_for_userid {
    my $class = shift;
    my ($uid) = @_;
    return "https://me.yahoo.com/$uid";
};

sub _get_nickname {
    my $class = shift;
    my ($vident, $blog_id) = @_;
    my $url = $vident->url;
    if( $url =~ m(^https?://me.yahoo.com/([\w.]+)([^/]*)$) ||
	$url =~ m(^http://www.flickr.com/photos/(.*)$)
    ) {
        return $1;
    }
    *MT::Auth::OpenID::_get_nickname->($class,@_);
}

1;
