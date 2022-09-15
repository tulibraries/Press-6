// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./src/jquery"
import "sifter"
import "microplugin"
import "./controllers"
import * as bootstrap from "bootstrap"
import "trix"
import Trix from "trix";
import "@rails/actiontext"
import "./src/selectize"
import "./src/jumble"
import "./src/administrate-trix"


var _gaq = _gaq || [];

function loadtracking() {
  window._gaq.push(['_setAccount', 'UA-2152985-17']);
  window._gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/analytics.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
}

loadtracking();
