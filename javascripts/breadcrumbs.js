function breadcrumbs() {
  var url_parts, $html, $li, $content, href, text, url, i;

  url = window.location.pathname;
  url_parts = $.grep(url.replace(/index\.html/, '').split(/\//), function (x) { return x.length > 0; });

  if (url_parts.length === 1) { // if at the top level
    return;
  }

  $html = $('<ol class="breadcrumbs">');
  for (i = 0; i < url_parts.length; ++i) {
    text = url_parts[i];
    href = '/' + url_parts.slice(0, i + 1).join('/');
    $content = (i < url_parts.length - 1) ? $('<a>').prop('href', href).text(text) : text;
    $('<li>').append($content).appendTo($html);
  }
  $html.insertAfter('#breadcrumbs-js');
}

$(function () {
  breadcrumbs();
});
