module.exports = {
    mode: "development" || "production",
    resolve: {
        extensions: [ ".web.js", ".js"]
    },

    entry: {
        leach: __dirname + "/client/leach.js",
        seeder: __dirname + "/client/seeder.js"
    },
    output: {
        path: __dirname + "/public/dist",
        filename: "[name].js"
    },
    node: {
        fs: 'empty'
    },
    optimization: {
        splitChunks: {
            chunks: 'all',
            cacheGroups: {
                vendor: {
                    test: /[\\/]node_modules[\\/]/,
                    name: 'libs'
                }
            }
        },
    },
};