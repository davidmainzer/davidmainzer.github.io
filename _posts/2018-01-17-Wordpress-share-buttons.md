---
layout: post
title: "Add Socical Sharing Buttons To Wordpress"
date: 2018-01-17 21:10:06
share: true
tags: 
- Wordpress
- PHP
categories:
description: Within this post I provide some information on how to add social sharing buttons to your Wordpress site.
---

## Add Social Sharing Buttons To Your Wordpress Site

In this post I will provide some informations on how-to add social sharing buttons to your wordpress site without the need for a plugin. There are many nice plugins for Wordpress to add Social Buttons, e.g.
<i class="fa fa-github"> [WPUpper Share Buttons](https://github.com/victorfreitas/wpupper-share-buttons)

Add the following code into `functions.php` file (located into your theme folder)

```php
function my_social_sharing_buttons() {
  global $post;

  // Get current page URL
  $currentURL  ="https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];

  // Get current page title
  $currentTitle = str_replace( ' ', '%20', get_the_title());

  // Get Post Thumbnail for pinterest
  $currentThumbnail = wp_get_attachment_image_src( get_post_thumbnail_id( $post->ID ), 'full' );

  // Construct sharing URL without using any script
  $twitterURL = 'https://twitter.com/intent/tweet?text='.$currentTitle.'&amp;url='.$currentURL.'&amp;via=YourTwitterName';
  $facebookURL = 'https://www.facebook.com/sharer/sharer.php?u='.$currentURL;
  $googleURL = 'https://plus.google.com/share?url='.$currentURL;
  $bufferURL = 'https://bufferapp.com/add?url='.$currentURL.'&amp;text='.$currentTitle;
  $whatsappURL = 'whatsapp://send?text='.$currentTitle . ' ' . $currentURL;
  $linkedInURL = 'https://www.linkedin.com/shareArticle?mini=true&url='.$currentURL.'&amp;title='.$currentTitle;
  $tumblrURL   = 'https://www.tumblr.com/widgets/share/tool?canonicalUrl='.$currentURL;
  $pinterestURL = 'https://pinterest.com/pin/create/button/?url='.$currentURL.'&amp;media='.$currentThumbnail[0].'&amp;description='.$currentTitle;


  $aftercontent .= '  <div data-element="buttons" class=" ">';
  // Facebook
  // you have to add a CSS class for the icons
  // currently we are using fontawesome icons for each social platform therefore you have to include the corresponding CSS files
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '      <a href="'.$facebookURL.'" target="_blank" data-action="open-popup" class=" " title="Share on Facebook" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-facebook"></i>';
  $aftercontent .= '      </a>';
  // Twitter
  $aftercontent .= '      <a href="'.$twitterURL.'" target="_blank" data-action="open-popup" class=" " title="Tweet" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-twitter"></i>';
  $aftercontent .= '      </a>';go
  $aftercontent .= '    </div>';
  // Google+
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '       <a href="'.$googleURL.'" target="_blank" data-action="open-popup" class=" " title="Bei Google+ teilen" rel="nofollow">';
  $aftercontent .= '         <i class="fa fa-google-plus"></i>';
  $aftercontent .= '       </a>';
  $aftercontent .= '    </div>';
  // WhatsApp
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '      <a href="'.$whatsappURL.'" target="_blank" data-whatsapp-wpusb="https://web.whatsapp.com/" class=" " title="Share on WhatsApp" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-whatsapp"></i>';
  $aftercontent .= '      </a>';
  $aftercontent .= '    </div>';
  // Pinterest
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '      <a href="'.$pinterestURL.'" target="_blank" data-action="open-popup" class=" " title="Share on Pinterest" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-pinterest-p"></i>';
  $aftercontent .= '      </a>';
  $aftercontent .= '    </div>';
  // LinkedIn
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '      <a href="'.$linkedInURL.'" target="_blank" data-action="open-popup" class=" " title="Share on Linkedin" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-linkedin"></i>';
  $aftercontent .= '      </a>';
  $aftercontent .= '    </div>';
  // Tumblr
  $aftercontent .= '    <div class=" ">';
  $aftercontent .= '      <a href="'.$tumblrURL.'" target="_blank" data-action="open-popup" class=" " title="Auf Tumblr teilen" rel="nofollow">';
  $aftercontent .= '        <i class="fa fa-tumblr"></i>';
  $aftercontent .= '      </a>';
  $aftercontent .= '    </div>';
  $aftercontent .= '';
  $aftercontent .= '  </div>';
  $aftercontent .= '</div>';

  // write everything into file
  echo $aftercontent;
};

// add stuff into wordpress footer ('wp_footer')
add_filter( 'wp_footer', 'my_social_sharing_buttons');
```

To include *font awesome* to your wordpress theme, add the following lines into your `functions.php`. You have to adapt the path to your `font-awesome.css`.

```php
// Font awesome
function add_font_awesome() {
wp_enqueue_style ('font-awesome', get_stylesheet_directory_uri() . '/fa/css/font-awesome.css');
}
add_action('wp_enqueue_scripts', 'add_font_awesome');
```
