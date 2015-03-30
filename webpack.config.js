var path    = require("path");
var webpack = require("webpack");
var BowerWebpackPlugin = require("bower-webpack-plugin");

var nodeModulesPath = path.join(__dirname, '/node_modules');

module.exports = {
  cache: true,

  entry: {
    app: "./src/bootstrap-elm.coffee",
    polyfills: "./node_modules/promises-done-polyfill/promises-done-polyfill.js"
  },

  output: {
    path: path.join(__dirname, "dist"),
    publicPath: "dist/",
    filename: "[name].js",
    chunkFilename: "[chunkhash].js"
  },

  module: {
    // Don't parse the output of .elm files for require() calls;
    // they definitely won't have any!
    noParse: /\.elm$/,

    loaders: [
      { test: /\.elm$/,      loader: 'elm-webpack' },
      { test: /\.coffee$/,   loader: 'coffee' },
      { test: /\.mustache$/, loader: 'mustache?minify' },
      { test: /\.json$/,     loader: 'json' },
      { test: /\.styl$/,     loader: 'stylus' },

      { test: /\.woff$/,   loader: "url-loader?prefix=fonts/&limit=5000&mimetype=application/font-woff" },

      { test: /\.ico$/,    loader: "url-loader?prefix=images/&limit=5000&mimetype=application/font-woff" },

      {
        test: /\.(jpe?g|png|gif|svg)$/i,
        loaders: [
            'file?hash=sha512&digest=hex&name=[hash].[ext]',
            'image?bypassOnDebug&optimizationLevel=7&interlaced=false'
        ]
      },

      { test: /\.html$/,   loader: "url-loader" }
    ]
  },

  plugins: [new BowerWebpackPlugin()]
};