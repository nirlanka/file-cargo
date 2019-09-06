module.exports = {
    mode: "development" || "production",
    module: {
        rules: [
            {
                test: /\.coffee$/,
                loader: "coffee-loader"
            }
        ]
    },
    resolve: {
        extensions: [".web.coffee", ".web.js", ".coffee", ".js"]
    },

    entry: {
        leach: __dirname + "/client/leach.coffee",
        seeder: __dirname + "/client/seeder.coffee"
    },
    output: {
        path: __dirname + "/public/dist",
        filename: "[name].js"
    },
    node: {
        fs: 'empty'
    }
};