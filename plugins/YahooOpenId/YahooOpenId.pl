#!/usr/bin/perl -w
#
# This software is licensed under the Gnu Public License, or GPL v2.
# 
# Copyright 2007, Six Apart, Ltd.

package MT::Plugin::YahooOpenId;

use MT;
use strict;
use base qw( MT::Plugin );
our $VERSION = '1.04';

require MT::Auth::Yahoo;

my $plugin = MT::Plugin::YahooOpenId->new({
    key         => 'YahooOpenId',
    id          => 'YahooOpenId',
    name        => 'Yahoo OpenID Login',
    description => "Provide a customized login box for users logging into Movable Type from Yahoo!.",
    version     => $VERSION,
    author_name => "Byrne Reese",
    author_link => "http://www.majordojo.com/",
});

sub instance { $plugin; }

MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        commenter_authenticators => {
            'Yahoo' => {
                class => 'MT::Auth::Yahoo',
                label => 'Yahoo!',
                login_form_params => \&_commenter_auth_params,
                condition => \&_openid_commenter_condition,
                logo => 'plugins/YahooOpenId/images/yahoo.png',
                login_form => <<YAHOO,
<form method="post" action="<mt:var name="script_url">">
<input type="hidden" name="__mode" value="login_external" />
<input type="hidden" name="blog_id" value="<mt:var name="blog_id">" />
<input type="hidden" name="entry_id" value="<mt:var name="entry_id">" />
<input type="hidden" name="static" value="<mt:var name="static" escape="html">" />
<fieldset>
<mtapp:setting
    id="yahoo_display"
    show_label="0"
    label="<__trans phrase="Your Yahoo! Username">">
<input type="hidden" name="key" value="Yahoo" />
<input type="hidden" name="openid_url" value="yahoo.com" />
</mtapp:setting>
<div class="pkg">
  <p class="left">
    <input src="<mt:var name="static_uri">plugins/YahooOpenId/images/yahoo-button.png" type="image" name="submit" value="<MT_TRANS phrase="Sign In">" />
  </p>
</div>
<p><img src="<mt:var name="static_uri">images/comment/blue_moreinfo.png"> <a href="http://openid.yahoo.com/">Turn on OpenID for your Yahoo! account now</a></p>
</fieldset>
</form>
YAHOO
            },
        },
    });
}

sub _commenter_auth_params {
    my ( $key, $blog_id, $entry_id, $static ) = @_;
    my $params = {
        blog_id => $blog_id,
        static  => $static,
    };
    $params->{entry_id} = $entry_id if defined $entry_id;
    return $params;
}

sub _openid_commenter_condition {
    eval "require Digest::SHA1;";
    return $@ ? 0 : 1;
}

1;
__END__

