---
layout: post
title: Loading jQuery from Google CDN and dependent scripts in WordPress
categories:
- technology
tags:
- javascripts
- jquery
- tip
- wordpress
---
I'm using a WordPress theme that loads jQuery and other JavaScripts in the header.php script:

``` html
<script type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/jquery.prettyPhoto.js"></script>
<script type="text/javascript" src="<?php bloginfo('template_directory'); ?>/js/custom.js"></script>
```

Using Chrome's Developer console (i.e., hit F12) to view the Resources for the page, I could see that jQuery is being loaded.
<img title="jquery-cdn-1" src="http://www.yentran.org/blog/wp-content/uploads/2012/04/jquery-cdn-11.png" width="333" height="279" />
I wanted to load jQuery from Google's Content Delivery Network ([why](http://encosia.com/3-reasons-why-you-should-let-google-host-jquery-for-you)?). My initial attempt was to simply change  the jQuery reference to the CDN location (I also upgraded to version 1.7.1 while I was at it):

``` html
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
```

This worked, and Chrome's Developer console showed that jQuery was being loaded from the CDN. However, there was another problem. WordPress apparently also loads jQuery by default, so the page ended up with an extra copy.

<img title="jquery-cdn-2" src="http://www.yentran.org/blog/wp-content/uploads/2012/04/jquery-cdn-21.png" width="400" height="415" />

To remove the redundant copy, I removed the jQuery references from the header.php script, then added the following lines to the functions.php script in the theme folder which use WordPress's built-in function **wp_enqueue_script** to ensure that only one copy of jQuery is included.

``` php
function load_cdn_jQuery() {
 wp_deregister_script( 'jquery' );
 wp_register_script('jquery', 'http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js');
 wp_enqueue_script('jquery');
}
add_action('wp_enqueue_scripts', 'load_cdn_jQuery');
```

This worked and only a single copy of jQuery remained. However, the other scripts which depend on jQuery now break because they are being loaded before jQuery.

Following the instructions provided in the [wp_enqueue_script reference](http://codex.wordpress.org/Function_Reference/wp_enqueue_script), I added the following lines to functions.php to ensure that their dependency on jQuery is enforced:

``` php
function my_scripts_method() {
 wp_enqueue_script(
 'pretty.photo',
 get_template_directory_uri() . '/js/jquery.prettyPhoto.js',
 array('jquery')
 );
 wp_enqueue_script(
 'custom',
 get_template_directory_uri() . '/js/custom.js',
 array('jquery')
 );
}
add_action('wp_enqueue_scripts', 'my_scripts_method');
```

The corresponding references, of course, should be removed from header.php.

Finally, verifying with the Developer console shows that everything is loaded correctly.

<img title="jquery-cdn-3" src="http://www.yentran.org/blog/wp-content/uploads/2012/04/jquery-cdn-31.png" width="399" height="414" />
