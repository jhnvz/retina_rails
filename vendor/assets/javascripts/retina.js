(function() {

  var root = (typeof exports == 'undefined' ? window : exports);

  var config = {
    // Ensure Content-Type is an image before trying to load @2x image
    // https://github.com/imulus/retinajs/pull/45)
    check_mime_type: true
  };



  root.Retina = Retina;

  function Retina() {}

  Retina.configure = function(options) {
    if (options == null) options = {};
    for (var prop in options) config[prop] = options[prop];
  };

  Retina.init = function(context) {
    if (context == null) context = root;

    var existing_onload = context.onload || new Function;

    context.onload = function() {
      var images = document.getElementsByTagName("img"), retinaImages = [], i, image;
      for (i = 0; i < images.length; i++) {
        image = images[i];
        if ($(image).attr('data-retina') != 'true') {
          retinaImages.push(new RetinaImage(image));
        }
      }
      existing_onload();
    };
  };

  Retina.isRetina = function(){
    var mediaQuery = "(-webkit-min-device-pixel-ratio: 1.5),\
                      (min--moz-device-pixel-ratio: 1.5),\
                      (-o-min-device-pixel-ratio: 3/2),\
                      (min-resolution: 1.5dppx)";

    if (root.devicePixelRatio > 1)
      return true;

    if (root.matchMedia && root.matchMedia(mediaQuery).matches)
      return true;

    return false;
  };


  root.RetinaImagePath = RetinaImagePath;

  function RetinaImagePath(path) {
    this.path = path;
    this.at_2x_path = path.replace(/(?:-[a-f0-9]{32})?(\.\w+)$/, function(match) { return "@2x" + match; });
  }

  RetinaImagePath.confirmed_paths = [];

  RetinaImagePath.prototype.is_external = function() {
    return !!(this.path.match(/^https?\:/i) && !this.path.match('//' + document.domain));
  };

  RetinaImagePath.prototype.check_2x_variant = function(callback) {
    var http, that = this;
    if (this.is_external()) {
      return callback(false);
    } else if (this.at_2x_path in RetinaImagePath.confirmed_paths) {
      return callback(true);
    } else {
      http = new XMLHttpRequest;
      http.open('HEAD', this.at_2x_path);
      http.onreadystatechange = function() {
        if (http.readyState != 4) {
          return callback(false);
        }

        if (http.status >= 200 && http.status <= 399) {
          if (config.check_mime_type) {
            var type = http.getResponseHeader('Content-Type');
            if (type == null || !type.match(/^image/i)) {
              return callback(false);
            }
          }

          RetinaImagePath.confirmed_paths.push(that.at_2x_path);
          return callback(true);
        } else {
          return callback(false);
        }
      };
      http.send();
    }
  };



  function RetinaImage(el) {
    this.el = el;
    this.path = new RetinaImagePath(this.el.getAttribute('src'));
    var that = this;
    this.path.check_2x_variant(function(hasVariant) {
      if (hasVariant) that.swap();
    });
  }

  root.RetinaImage = RetinaImage;

  RetinaImage.prototype.swap = function(path) {
    if (typeof path == 'undefined') path = this.path.at_2x_path;

    var that = this;
    function load() {
      if (! that.el.complete) {
        setTimeout(load, 5);
      } else {
        that.el.setAttribute('width', that.el.offsetWidth);
        that.el.setAttribute('height', that.el.offsetHeight);
        that.el.setAttribute('src', path);
        that.el.setAttribute('data-retina', true);
      }
    }
    load();
  }




  if (Retina.isRetina()) {
    Retina.init(root);
  }

})();
