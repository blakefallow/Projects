(function () {
    'use strict';

    var pkgcloud = require('pkgcloud');
    var fs = require('fs');

    var fileName = 'insert_file_name_here';
    var rs = fs.createWriteStream(fileName);

    rs.on('finish', function () {
        console.log('%s was successfuly downloaded', fileName);
    });

    rs.on('error', function (err) {
        console.error('There was an error writing the file!');
        throw new Error(err);
    });

    var client = pkgcloud.providers.rackspace.storage.createClient({
      username: 'insert_username_here',
      apiKey: 'insert_cloud_key_here',
      service: 'storage',
      region: 'ORD'

    });

    client.download({
        container: 'insert_container_name_here',
        remote: fileName
    }, function (err, result) {
        if (err) {
            throw new Error(err);
        }

        console.log('RESULT', result);
    }).pipe(rs);
})
();

