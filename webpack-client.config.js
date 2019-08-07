var path = require("path")
var CopyWebpackPlugin = require('copy-webpack-plugin')

const backendAddress = process.env.BACKEND_ADDRESS
if (!backendAddress || backendAddress == "") {
  console.log("BACKEND_ADDRESS env variable is required")
  process.exit()
}

console.log(">>>>>> >>>>>>> BACKEND ADDRESS = ", backendAddress)

module.exports = {
  entry: {
    app: __dirname + '/src/index.js'
  },
  output: {
    path: __dirname + '/public',
    filename: '[name].js',
  },
  module: {
    rules: [
      {
        test: /\.(css|scss)$/,
        use: [
          'style-loader',
          'css-loader',
           {
             loader: 'sass-loader',
              options: {
                includePaths: [__dirname + "/node_modules"]
              }
          },
        ]
      },
      {
        test:    /\.html$/,
        exclude: /node_modules/,
        loader:  'file-loader?name=[name].[ext]',
      },
      {
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader",
      query: {
        presets: ["es2015"]
      }
    },
      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        //loader:  'elm-webpack-loader?verbose=true&warn=true',
        loader:  'elm-hot-loader!elm-webpack-loader?verbose=false&warn=true&debug=false',
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff',
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file-loader',
      }
    ],
    noParse: /\.elm$/,
  },
  plugins: [
      new CopyWebpackPlugin([
        {
          context: __dirname +'/src/res/',
          from: '**/*'
        }
      ])
  ],
  devServer: {
        hot: true,
        inline: true,
        host: '0.0.0.0', // to accepts requests from outside container
        port: '8888',
        https: {
          spdy: {
            protocols: ['http/1.1'],
          },
        },
        proxy: {
          '/api/*': backendAddress,
          '/wapi/*': backendAddress,
          '/static/*': backendAddress,
          '/assets/*': backendAddress,
          '/avatar/*': backendAddress
        }
    }
}
